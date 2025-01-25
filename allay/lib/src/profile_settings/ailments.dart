import 'package:allay/src/profile_settings/profile_settings.dart';
import 'package:allay/src/util/error.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/network.dart';
import '../models/user.dart';
import '../util/validator.dart';
import '../widgets/colors.dart';
import '../widgets/file_picker.dart';
import '../widgets/input_field.dart';
import '../widgets/text_widgets.dart';

final ailmentsCountProvider = StateProvider.autoDispose<int>((ref) {
  return (ref.watch(networkUserProvider).value?.medicalProfile?.ailments??[]).length;
});

final ailmentsProvider = StateNotifierProvider.autoDispose<AilmentsProviderNotifier, Map<int, Ailment>>((ref) {
  return AilmentsProviderNotifier(ref);
});

class AilmentsProviderNotifier extends StateNotifier<Map<int, Ailment>> {
  final Ref ref;

  AilmentsProviderNotifier(this.ref) : super({}){
    _fetch();
  }

  void _fetch() async {
    state = (ref.watch(medicalProfileProvider)?.ailments?.asMap())??{};
  }

  void setState(Map<int, Ailment> newVal) {
    state = newVal;
  }

  void removeItem(int index) {
    Map<int, Ailment> ailmentMap = {};
    ailmentMap.addAll(state);
    ailmentMap.remove(index);
    state = ailmentMap;
  }

  void addItem() {
    Map<int, Ailment> ailmentMap = {};
    ailmentMap.addAll(state);
    int index = ref.read(ailmentsCountProvider.notifier).state + 1;
    ailmentMap[index] = Ailment();
    ref.read(ailmentsCountProvider.notifier).state = index;
    state = ailmentMap;
  }

  void updateItem(int index, Ailment newVal) {
    Map<int, Ailment> ailmentMap = {};
    ailmentMap.addAll(state);
    ailmentMap[index] = newVal;
    state = ailmentMap;
  }

  Ailment? getItem(int index) {
    return state[index];
  }

  List<Ailment>? getAilments() {
    Map<int, Ailment> map = state;
    return map.values.where((e) => e.ailmentType != null).toList();
  }
}

class AilmentsWidget extends ConsumerStatefulWidget {
  final MedicalProfile? medicalProfile;
  final GlobalKey<FormState> globalKey;
  const AilmentsWidget({Key? key, required this.medicalProfile, required this.globalKey}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AilmentsWidgetState();
}

class AilmentsWidgetState extends ConsumerState<AilmentsWidget> {
  late MedicalProfile? _medicalProfile;
  late GlobalKey<FormState> _globalKey;

  @override
  void initState() {
    _medicalProfile = widget.medicalProfile;
    _globalKey = widget.globalKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Ailment> ailmentMapFromServer = (_medicalProfile?.ailments??[]).asMap();
    Map<int, Ailment> ailmentMap = ref.watch(ailmentsProvider);
    var ailmentsButtonLabel = ailmentMap.isNotEmpty ? "Add another condition" : "Add a condition";
    List<Widget> ailments = ailmentMap.entries.map((e) {
      Ailment? initialVal = ailmentMapFromServer[e.key];
      return _AilmentWidget(
        initialAilmentValue: initialVal,
        index: e.key,
        onDelete: (index) {
          ref.read(ailmentsProvider.notifier).removeItem(index);
        }
      );
    }).toList();
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...ailments,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide (
                      color: secondaryBlue
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                primary: Colors.white,
                fixedSize: Size(MediaQuery.of(context).size.width-50, 50)
              ),
              onPressed: () {
                bool isValid = _globalKey.currentState?.validate()??true;
                if (isValid) {
                  ref.read(ailmentsProvider.notifier).addItem();
                }
              },
              icon: const Icon(Icons.add, color: secondaryBlue),
              label: LabelSmall12SemiBold(ailmentsButtonLabel, color: secondaryBlue,)
            ),
          )
        ],
      ),
    );
  }
}

class _AilmentWidget extends ConsumerStatefulWidget {
  final Ailment? initialAilmentValue;
  final int index;
  final ValueChanged<int> onDelete;

  const _AilmentWidget({
    Key? key,
    required this.initialAilmentValue,
    required this.index,
    required this.onDelete
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AilmentWidgetState();
}

class _AilmentWidgetState extends ConsumerState<_AilmentWidget> {
  late TextEditingController _ailmentTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _symptomsController;
  late Ailment? ailmentFromServer;
  late int index;
  late ValueChanged<int> onDelete;

  @override
  void initState() {
    ailmentFromServer = widget.initialAilmentValue;
    index = widget.index;
    onDelete = widget.onDelete;
    super.initState();
    _ailmentTypeController = getTextEditingController(ailmentFromServer?.ailmentType??"");
    _descriptionController = getTextEditingController(ailmentFromServer?.description??"");
    _symptomsController = getTextEditingController((ailmentFromServer?.symptoms??[]).join("\n"));
  }

  @override
  void dispose() {
    _ailmentTypeController.dispose();
    _descriptionController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  Ailment cloneAilmentFromServer(Ailment currentObj) {
    return Ailment(
      dateOfDiagnosis: currentObj.dateOfDiagnosis,
      description: currentObj.description,
      healthRecords: currentObj.healthRecords,
      ailmentType: currentObj.ailmentType,
      symptoms: currentObj.symptoms
    );
  }

  Ailment _getUpdatedAilmentObject(dynamic newVal, String propertyName, Ailment currentObj) {
    switch(propertyName) {
      case "ailmentType":
        return cloneAilmentFromServer(currentObj)..ailmentType = newVal;
      case "description":
        return cloneAilmentFromServer(currentObj)..description = newVal;
      case "healthRecordIds":
        return cloneAilmentFromServer(currentObj)..healthRecords = newVal;
      case "symptoms":
        return cloneAilmentFromServer(currentObj)..symptoms = newVal;
      case "dateOfDiagnosis":
        return cloneAilmentFromServer(currentObj)..dateOfDiagnosis = newVal;
      default:
        throw Exception('Invalid argument name');
    }
  }

  void _updateHealthRecordIds(List<dynamic> files, currentObj, WidgetRef ref) async{
    List<S3Resource> healthRecords = [];
    for (var file in files) {
      String fileType;
      String fileName;
      if (file is XFile?) {
        fileType = file!.path.split(".").last;
        fileName = file.name;
      } else if (file is PlatformFile){
        fileType = file.path!.split(".").last;
        fileName = file.name;
      } else {
        showErrorSnackBar("Invalid file type $file", context);
        return;
      }
      S3Resource fileResource =  await getHealthRecordUploadUrl(fileType);
      fileResource.fileName = fileName;
      fileResource.file = file;
      healthRecords.add(fileResource);
    }
    Ailment ailmentObj = _getUpdatedAilmentObject(healthRecords, "healthRecordIds", currentObj);
    ref.read(ailmentsProvider.notifier).updateItem(index, ailmentObj);
  }

  @override
  Widget build(BuildContext context) {
    Ailment currentObj = ref.watch(ailmentsProvider.notifier).getItem(index)!;
    Widget removeWidget = IconButton(
        onPressed: () => onDelete(index),
        icon: Icon(Icons.remove_circle_outline, size: 20, color: Colors.red.shade400,)
    );
    List<S3Resource> healthRecordIds = currentObj.healthRecords??[];
    Widget files = healthRecordIds.isNotEmpty ?
    GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: healthRecordIds.map((e) {
        return Chip(
          backgroundColor: Colors.green.shade100,
          labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          label: LabelSmall12SemiBold(e.fileName??"", color: Colors.green,),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: Colors.green.shade200)),
          deleteIcon: const Icon(Icons.cancel_outlined, size: 20.0, color: Colors.green,),
          onDeleted: () {
            List<S3Resource> result = healthRecordIds.where((element) => element!=e).toList();
            ref.read(ailmentsProvider.notifier).updateItem(index, _getUpdatedAilmentObject(result, 'healthRecordIds', currentObj));
          }
        );
      }).toList(),
    ): Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration (
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: subTextColor,
            width: 0.1,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LabelSmall12(currentObj.ailmentType??"Add new ailment", color: subTextColor,),
                ),
                removeWidget
              ],
            ),
            AllayTextField(
              label: "Ailment Type",
              validator: (val) => nonEmptyTextValidator("Ailment Type", val),
              controller: _ailmentTypeController,
              onChanged: (newVal) {
                ref.read(ailmentsProvider.notifier).updateItem(index, _getUpdatedAilmentObject(newVal, 'ailmentType', currentObj));
              },
            ),
            AllayTextField(
              label: "Description",
              controller: _descriptionController,
              maxLines: 4,
              onChanged: (newVal) {
                ref.read(ailmentsProvider.notifier).updateItem(index, _getUpdatedAilmentObject(newVal, 'description', currentObj));
              },
            ),
            AllayDateWidget(
              label: "Diagnosis Date",
              initialValue: currentObj.dateOfDiagnosis,
              validator: (val) => validateDateField("Initial Date Of Diagnosis", val),
              onDateSelected: (newVal) {
                ref.read(ailmentsProvider.notifier).updateItem(index, _getUpdatedAilmentObject(newVal, 'dateOfDiagnosis', currentObj));
              }
            ),
            AllayTextField(
              label: "Symptoms",
              controller: _symptomsController,
              maxLines: 4,
              textInputType: TextInputType.multiline,
              onChanged: (newVal) {
                List<String> result = newVal.split('\n');
                ref.read(ailmentsProvider.notifier).updateItem(index, _getUpdatedAilmentObject(result, 'symptoms', currentObj));
              },
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: files,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  primary: secondaryBlue,
                  fixedSize: Size(MediaQuery.of(context).size.width-50, 50)
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: AllayFilePicker(
                          allowMultiSelect: true,
                          onFilesPicked: (files) {
                            _updateHealthRecordIds(files, currentObj, ref);
                          },
                        )
                      );
                    },
                    elevation: 10,
                    useRootNavigator: true,
                    isScrollControlled: true,
                  );
                },
                icon: const Icon(Icons.upload_rounded),
                label: const LabelSmall12SemiBold("Upload related medical records", color: Colors.white,)
              ),
            ),
          ],
        ),
      ),
    );
  }
}