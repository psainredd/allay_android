import 'package:allay/src/models/enum.dart';
import 'package:allay/src/models/user.dart';
import 'package:allay/src/profile_settings/profile_settings.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/network.dart';
import '../widgets/input_field.dart';
import '../widgets/text_widgets.dart';

final basicMedicalProfileProvider = StateProvider.autoDispose<MedicalProfile>((ref) {
  String? hStr = ref.watch(heightProvider);
  int? height = hStr != null ? int.tryParse(hStr): null;
  String? wStr = ref.watch(weightProvider);
  double? weight = wStr != null ? double.tryParse(wStr): null;
  String? bloodType = ref.watch(bloodTypeProvider);
  List<String>? allergies = ref.watch(allergiesProvider);
  return MedicalProfile(
    heightInCentiMeters: height,
    weight: weight,
    bloodType: bloodType,
    allergies: allergies
  );
});

final heightProvider = StateProvider.autoDispose<String?> ((ref){
  return ref.watch(medicalProfileProvider)?.heightInCentiMeters?.toString();
});
final weightProvider = StateProvider.autoDispose<String?> ((ref){
  return ref.watch(medicalProfileProvider)?.weight?.toString();
});
final bloodTypeProvider = StateProvider.autoDispose<String?> ((ref){
  return ref.watch(medicalProfileProvider)?.bloodType;
});
final allergiesProvider = StateProvider.autoDispose<List<String>?> ((ref){
  return ref.watch(medicalProfileProvider)?.allergies;
});

class BasicMedicalInfo extends ConsumerStatefulWidget {
  final MedicalProfile? medicalProfile;
  final GlobalKey formKey;
  const BasicMedicalInfo({Key? key, required this.medicalProfile, required this.formKey}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BasicMedicalInfoState();
}

class BasicMedicalInfoState extends ConsumerState<BasicMedicalInfo> {
  late GlobalKey _formKey;
  late MedicalProfile? _medicalProfileFromServer;
  late TextEditingController _heightEditingController;
  late TextEditingController _weightEditingController;
  late TextEditingController _allergiesEditingController;

  @override
  void initState() {
    _medicalProfileFromServer = widget.medicalProfile;
    _formKey = widget.formKey;
    var currentMedicalProfileState = ref.read(medicalProfileProvider);
    _heightEditingController = getTextEditingController(currentMedicalProfileState?.heightInCentiMeters?.toString()??"");
    _weightEditingController = getTextEditingController(currentMedicalProfileState?.weight?.toString()??'');
    _allergiesEditingController = getTextEditingController(currentMedicalProfileState?.allergies?.join("\n")??"");
    super.initState();
  }

  @override
  void dispose() {
    _heightEditingController.dispose();
    _weightEditingController.dispose();
    _allergiesEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(heightProvider);
    ref.watch(weightProvider);
    String? bloodType = ref.watch(bloodTypeProvider);
    ref.watch(allergiesProvider);
    String? heightFromServer = _medicalProfileFromServer?.heightInCentiMeters?.toString();
    String? bloodTypeFromServer = _medicalProfileFromServer?.bloodType;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: HeadingSemiBold("Basic Medical Info"),
          ),
          AllayTextField(
            label: "Height",
            controller: _heightEditingController,
            isReadOnly: heightFromServer?.isNotEmpty??false,
            textInputType: TextInputType.number,
            validator: (val) {
              if (val == null || val.isEmpty || int.tryParse(val)!=null) {
                return null;
              }
              return "Please enter valid height value";
            },
            maxLength: 3,
            suffixIcon: const Padding(
              padding: EdgeInsets.all(16.0),
              child: LabelSmall12("cms", color: subTextColor),
            ),
            onChanged: (newVal) => ref.read(heightProvider.notifier).state = newVal
          ),
          AllayTextField(
            label: "Weight",
            controller: _weightEditingController,
            textInputType: TextInputType.number,
            validator: (val) {
              if (val == null || val.isEmpty || double.tryParse(val)!=null) {
                return null;
              }
              return "Please enter valid weight value";
            },
            maxLength: 3,
            suffixIcon: const Padding(
              padding: EdgeInsets.all(16.0),
              child: LabelSmall12("kgs", color: subTextColor),
            ),
            onChanged: (newVal) => ref.read(weightProvider.notifier).state = newVal
          ),
          AllayDropDownInputField(
            label: "Blood Type",
            value: bloodType,
            itemGenerator: () => getDropdownMenuItems(BloodType.values.map((e) => e.text).toList()),
            selectedItemBuilder: (context) => getSelectedItems(BloodType.values.map((e) => e.text).toList()),
            isReadOnly: bloodTypeFromServer != null,
            onChanged: (newVal) => ref.read(bloodTypeProvider.notifier).state = newVal.toString(),
          ),
          AllayTextField(
            label: "Allergies",
            maxLines: 4,
            controller: _allergiesEditingController,
            textInputType: TextInputType.multiline,
            onChanged: (newVal) => ref.read(allergiesProvider.notifier).state = newVal.split("\n"),
          )
        ],
      ),
    );
  }
}