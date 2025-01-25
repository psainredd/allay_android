import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../widgets/colors.dart';
import '../widgets/input_field.dart';
import '../widgets/text_widgets.dart';
import 'basic_profile_info.dart';
import 'profile_settings.dart';

final statesProvider = StateProvider<List<String>?>((ref) => []);

final addressLine1Provider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.houseNumber;
});
final addressLine2Provider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.streetName;
});
final addressLine3Provider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.locality;
});
final areaProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.area;
});
final cityNameProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.cityName;
});
final stateProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.state;
});
final pinCodeProvider = StateProvider.autoDispose<String?>((ref) {
  return ref.watch(networkUserProvider).value?.address?.pinCode;
});

final addressProvider = StateProvider.autoDispose<Address>((ref) {
  String? houseNumber = ref.watch(addressLine1Provider);
  String? streetName = ref.watch(addressLine2Provider);
  String? locality = ref.watch(addressLine3Provider);
  String? area = ref.watch(areaProvider);
  String? cityName = ref.watch(cityNameProvider);
  String? state = ref.watch(stateProvider);
  String? pinCode = ref.watch(pinCodeProvider);
  return Address(
    houseNumber: houseNumber,
    streetName: streetName,
    locality: locality,
    area: area,
    cityName: cityName,
    state: state,
    pinCode: pinCode
  );
});

class AddressWidget extends ConsumerWidget {
  final Address? address;
  const AddressWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AddressInfo(address: address);
  }
}

class AddressInfo extends ConsumerStatefulWidget {
  final Address? address;
  const AddressInfo({Key? key, required this.address}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddressInfoState();
}

class AddressInfoState extends ConsumerState<AddressInfo> {
  late Address? _address;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _addressLine3Controller;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _pinCodeController;

  @override
  void initState() {
    _address = widget.address;
    Address? currentState = (ref.read(userProfileProvider)?.address)??_address;
    _addressLine1Controller = getTextEditingController(currentState?.houseNumber??"");
    _addressLine2Controller = getTextEditingController(currentState?.streetName??"");
    _addressLine3Controller = getTextEditingController(currentState?.locality??"");
    _areaController = getTextEditingController(currentState?.area??"");
    _cityController = getTextEditingController(currentState?.cityName??"");
    _pinCodeController = getTextEditingController(currentState?.pinCode??"");
    super.initState();
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _addressLine3Controller.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addressLine1Provider);
    ref.watch(addressLine2Provider);
    ref.watch(addressLine3Provider);
    ref.watch(areaProvider);
    ref.watch(cityNameProvider);
    ref.watch(stateProvider);
    ref.watch(pinCodeProvider);
    var asyncStates = ref.watch(indianStatesProvider);
    var states =[];
    asyncStates.when(
      data: (data) => states = data,
      error: (error, stackTrace) => states = [],
      loading: () => states =[]
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: HeadingSemiBold("Address"),
        ),
        AllayTextField(
          label: "Address Line 1",
          controller: _addressLine1Controller,
          onChanged: (newVal) => ref.read(addressLine1Provider.notifier).state = newVal
        ),
        AllayTextField(
          label: "Address Line 2",
          controller: _addressLine2Controller,
          onChanged: (newVal) => ref.read(addressLine2Provider.notifier).state = newVal
        ),
        AllayTextField(
          label: "Address Line 3",
          controller: _addressLine3Controller,
          onChanged: (newVal) => ref.read(addressLine3Provider.notifier).state = newVal
        ),
        AllayTextField(
          label: "Area",
          controller: _areaController,
          onChanged: (newVal) => ref.read(areaProvider.notifier).state = newVal
        ),
        AllayTextField(
          label: "City",
          controller: _cityController,
          onChanged: (newVal) => ref.read(cityNameProvider.notifier).state = newVal
        ),
        AllayDropDownInputField<String>(
          label: "State",
          itemGenerator: () => getDropdownMenuItems(states),
          value: states.isNotEmpty? _address?.state : null,
          selectedItemBuilder: (context) => getSelectedItems(states),
          onChanged: (newVal) => ref.read(stateProvider.notifier).state = newVal
        ),
        AllayTextField(
          label: "Pin Code",
          controller: _pinCodeController,
          textInputType: TextInputType.number,
          onChanged: (newVal) => ref.read(pinCodeProvider.notifier).state = newVal
        ),
      ],
    );
  }
}