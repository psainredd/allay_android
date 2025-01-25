
import 'package:allay/src/profile_settings/ailments.dart';
import 'package:allay/src/profile_settings/profile_settings.dart';
import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/error.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/colors.dart';
import '../widgets/text_widgets.dart';
import 'basic_medical_info.dart';

class MedicalProfileWidget extends ConsumerWidget {
  final MedicalProfile? medicalProfile;
  final VoidCallback onSave;
  final GlobalKey<FormState> _medicalProfileKey = GlobalKey();
  final GlobalKey<FormState> _ailmentsKey = GlobalKey();
  MedicalProfileWidget({Key? key, required this.medicalProfile, required this.onSave}) : super(key: key);

  Widget _getSaveButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: primaryBlue,
      ),
      onPressed: () {
        bool isMedicalProfileValid = (_medicalProfileKey.currentState?.validate())!
            && (_ailmentsKey.currentState?.validate())!;
        if (!isMedicalProfileValid) {
          return;
        }
        onSave();
      },
      icon: const Icon(Icons.save, color: Colors.white),
      label: const Label("Save", color: Colors.white)
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool areFilesBeingUploaded = ref.watch(fileUploadProgressProvider);
    var progressBar = areFilesBeingUploaded?const LinearProgressIndicator() : Container();
    return WillPopScope(
      onWillPop: () async {
        bool isMedicalProfileFormValid = (_medicalProfileKey.currentState?.validate())!;
        bool isAilmentsFormValid = (_ailmentsKey.currentState?.validate())!;
        List<Ailment>? ailments = isAilmentsFormValid ? ref.read(ailmentsProvider.notifier).getAilments(): medicalProfile?.ailments;
        MedicalProfile? profile = (isMedicalProfileFormValid ? ref.read(basicMedicalProfileProvider) : medicalProfile)?..ailments = ailments;
        ref.read(medicalProfileProvider.notifier).state = profile;
        return true;
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white
          ),
          actions: [_getSaveButton(context, ref)],
          backgroundColor: primaryBlue,
          title: const HeadingSemiBold("Update Medical Profile", color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Container (
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration : BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                border: Border.all(
                    color: subTextColor,
                    width: 0.5
                )
            ),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                progressBar,
                BasicMedicalInfo(
                  medicalProfile: medicalProfile,
                  formKey: _medicalProfileKey,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 12),
                  child: Divider(height: 0.1, color: subTextColor, indent: 8.0, endIndent: 8.0, thickness: 0.2,),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: HeadingSemiBold("Known health conditions"),
                ),
                AilmentsWidget(
                  medicalProfile: medicalProfile,
                  globalKey: _ailmentsKey,
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}

final fileUploadProgressProvider = StateProvider.autoDispose<bool>((ref) =>false);