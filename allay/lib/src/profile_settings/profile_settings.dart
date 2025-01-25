import 'dart:core';

import 'package:allay/src/models/enum.dart';
import 'package:allay/src/profile_settings/address_info.dart';
import 'package:allay/src/profile_settings/basic_medical_info.dart';
import 'package:allay/src/profile_settings/basic_profile_info.dart';
import 'package:allay/src/profile_settings/medical_profile.dart';
import 'package:allay/src/profile_settings/profile_photo.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/image.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../util/allay_shared_prefs.dart';
import '../util/error.dart';
import '../models/user.dart';
import '../widgets/file_picker.dart';
import '../widgets/input_field.dart';
import 'ailments.dart';
import 'basic_profile_widget.dart';

class UserProfile extends ConsumerStatefulWidget {
  final String? title;
  const UserProfile({Key? key, this.title}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserProfileState();
}

class UserProfileState extends ConsumerState<UserProfile> {
  late String title;
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void initState() {
    title = widget.title??"Update Profile";
    super.initState();
  }

  Widget _getErrorWidget() {
    return const Center(
      child: HeadingSemiBold('Error occurred.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userAsync = ref.watch(networkUserProvider);
    var child = userAsync.when(
      data: (data) => ProfileWidget(
        user: data!,
        onMoveToNextPage: () => _onMoveToNextPageFromProfileInfo(data),
        globalKey: _globalKey
      ),
      error: (error, stackTrace) => _getErrorWidget(),
      loading: () => const Center(child: CircularProgressIndicator())
    );
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: HeadingSemiBold(title, color: Colors.white),
      ),
      body: child
    );
  }

  void _onMoveToNextPageFromProfileInfo(User userFromServer) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MedicalProfileWidget(
        medicalProfile: userFromServer.medicalProfile,
        onSave: onSave,
      );
    }));
  }

  void onSave() async {
    List<Ailment>? ailments = ref.read(ailmentsProvider.notifier).getAilments();
    MedicalProfile profile = ref.read(basicMedicalProfileProvider)..ailments = ailments;
    User user = ref.read(userProfileProvider)!..medicalProfile = profile;
    var healthRecords = [];
    user.medicalProfile?.ailments?.forEach((ailment) {
      healthRecords.addAll(ailment.healthRecords??[]);
    });
    if(healthRecords.isNotEmpty) {
      int numberOfFilesUploaded = 0;
      showSnackBarMessage("Uploading medical records.", context);
      ref.read(fileUploadProgressProvider.notifier).state = true;
      for (S3Resource record in healthRecords) {
        try {
          if (record.file is XFile?) {
            await uploadImage(record.preSignedURL!, record.file, record.fileType!);
          } else {
            await uploadFile(record.preSignedURL!, record.file, record.fileType!);
          }
          numberOfFilesUploaded++;
        } catch(e) {
          record.uploadFailed = true;
          showErrorSnackBar("Error while uploading file ${record.fileName}", context);
        }
        record.file = null;
      }
      if (numberOfFilesUploaded == healthRecords.length) {
        showSnackBarSuccessMessage("Successfully uploaded medical records.", context);
      } else if (numberOfFilesUploaded == 0){
        showErrorSnackBar("Record upload failed", context);
      } else {
        showSnackBarMessage("Partially uploaded medical records", context);
      }
      ref.read(fileUploadProgressProvider.notifier).state = false;
    }
    user.medicalProfile?.ailments?.forEach((ailment) {
      var updatedHealthRecords = ailment.healthRecords?.where((element) => element.uploadFailed == false).toList();
      ailment.healthRecords = updatedHealthRecords;
    });
    ref.read(networkUserProvider.notifier).updateAndSave(user).then((updatedUser) {
      ref.invalidate(userProfileProvider);
      ref.invalidate(medicalProfileProvider);
      showSnackBarSuccessMessage("Successfully updated user profile", context);
      ref.read(savedUserInfoProvider.notifier).update(updatedUser);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      showErrorSnackBar("Error occurred while updating user.", context);
    });
  }
}

final userProfileProvider = StateProvider<User?>((ref) => ref.watch(networkUserProvider).value);
final medicalProfileProvider = StateProvider<MedicalProfile?>((ref) => ref.watch(networkUserProvider).value?.medicalProfile);