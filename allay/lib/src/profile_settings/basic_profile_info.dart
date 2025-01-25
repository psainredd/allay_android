import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enum.dart';
import '../models/user.dart';
import '../widgets/input_field.dart';
import '../widgets/text_widgets.dart';

final basicProfileProvider = StateProvider.autoDispose<User>((ref) {
  String? firstName = ref.watch(firstNameProvider);
  String? lastName = ref.watch(lastNameProvider);
  String? mobileNumber = ref.watch(mobileNumberProvider);
  String? emailId = ref.watch(emailIdProvider);
  String? gender = ref.watch(genderProvider);
  String? emergencyContact = ref.watch(emergencyContactProvider);
  DateTime? dob = ref.watch(dobProvider);
  User user = ref.watch(savedUserInfoProvider).value!;
  return user
    ..firstName = firstName
    ..lastName = lastName
    ..mobileNumber = mobileNumber
    ..emailId = emailId
    ..gender = gender
    ..emergencyContact = emergencyContact
    ..dateOfBirth = dob;
});

final firstNameProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.firstName;
});
final lastNameProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.lastName;
});
final mobileNumberProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.mobileNumber;
});
final emailIdProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.emailId;
});
final genderProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.gender;
});
final emergencyContactProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.emergencyContact;
});
final dobProvider = StateProvider.autoDispose<DateTime?>((ref) {
  return ref.watch(networkUserProvider).value?.dateOfBirth;
});

class BasicProfileInfo extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? formKey;
  final User userFromServer;
  const BasicProfileInfo({Key? key, this.formKey, required this.userFromServer}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BasicProfileInfoState();
}

class BasicProfileInfoState extends ConsumerState<BasicProfileInfo> {
  late User _userFromServer;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailIdController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emergencyContactController;
  late GlobalKey<FormState>? _formKey;

  @override
  void initState() {
    _formKey = widget.formKey;
    _userFromServer = widget.userFromServer;
    _firstNameController = getTextEditingController(_userFromServer.firstName??"");
    _lastNameController = getTextEditingController(_userFromServer.lastName??"");
    _emailIdController = getTextEditingController(_userFromServer.emailId??"");
    _mobileNumberController = getTextEditingController(_userFromServer.mobileNumber??"");
    _emergencyContactController = getTextEditingController(_userFromServer.emergencyContact??"");
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailIdController.dispose();
    _mobileNumberController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(firstNameProvider);
    ref.watch(lastNameProvider);
    ref.watch(mobileNumberProvider);
    ref.watch(emailIdProvider);
    ref.watch(dobProvider);
    ref.watch(genderProvider);
    ref.watch(emergencyContactProvider);
    return Form(
      key: _formKey,
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: HeadingSemiBold("Basic Details"),
          ),
          AllayTextField(
            label: "First Name",
            validator: (val) => nonEmptyTextValidator("First name", val),
            controller: _firstNameController,
            isReadOnly: _userFromServer.firstName != null,
            onChanged: (newVal) {
              ref.read(firstNameProvider.notifier).state = newVal;
            }
          ),
          AllayTextField(
            label: "Surname",
            controller: _lastNameController,
            onChanged: (newVal) => ref.read(lastNameProvider.notifier).state = newVal,
          ),
          AllayTextField(
            label: "Mobile Number",
            controller: _mobileNumberController,
            isReadOnly: true,
          ),
          DOBWidget(dobFromServer: _userFromServer.dateOfBirth),
          AllayDropDownInputField<String>(
            label: "Gender",
            value: _userFromServer.gender,
            validator: (val) {
              if (val == null) {
                return "Gender cannot be empty";
              }
              return null;
            },
            itemGenerator: () => getDropdownMenuItems(Gender.values.map((e) => e.text).toList()),
            selectedItemBuilder: (context) => getSelectedItems(Gender.values.map((e) => e.text).toList()),
            isReadOnly: _userFromServer.gender?.isNotEmpty??false,
            onChanged: (newVal) => ref.read(genderProvider.notifier).state = newVal
          ),
          AllayTextField(
            label: "Email Id",
            textInputType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return null;
              }
              if (isValidEmailId(val)) {
                return null;
              }
              return "Please enter a valid email address";
            },

            controller: _emailIdController,
            onChanged: (newVal) => ref.read(emailIdProvider.notifier).state = newVal,
          ),
          AllayTextField(
            label: "Emergency Contact",
            textInputType: TextInputType.phone,
            maxLength: 10,
            controller: _emergencyContactController,
            validator: (val) {
              if (val == null || val.isEmpty || isValidMobileNumber(val)) {
                return null;
              }
              return "Please enter a valid mobile number";
            },
            onChanged: (newVal) {
              ref.read(emergencyContactProvider.notifier).state = newVal;
            },
          ),
        ],
      ),
    );
  }
}

class DOBWidget extends ConsumerWidget {
  final GlobalKey<FormState>? globalKey;
  final DateTime? dobFromServer;
  const DOBWidget({Key? key, this.globalKey, required this.dobFromServer}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? dob = ref.watch(dobProvider);
    return AllayDateWidget (
      formKey: globalKey,
      label: "Date of birth",
      validator: (val) => validateDateField("Date of birth", val),
      isReadOnly: dobFromServer != null,
      initialValue: dob,
      onDateSelected: (val) => ref.read(dobProvider.notifier).state = val,
    );
  }
}