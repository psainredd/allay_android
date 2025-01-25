import 'package:allay/src/widgets/text_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../profile_settings/profile_settings.dart';
import 'colors.dart';

class AllayImagePicker extends ConsumerWidget {
  final ImagePicker _imagePicker = ImagePicker();
  final ValueChanged<XFile?> onImagePicked;

  AllayImagePicker({Key? key, required this.onImagePicked}) : super(key: key);

  final EdgeInsetsGeometry buttonPadding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(5.0);

  Size _getButtonSize(BuildContext context) {
    return Size(MediaQuery.of(context).size.width-50, 50);
  }

  void takeImage(ImageSource imageSource, WidgetRef ref, BuildContext context) async {
    XFile? image;
    if (imageSource == ImageSource.camera) {
      image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 20,
          preferredCameraDevice: CameraDevice.front);
    } else {
      image = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    onImagePicked(image);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: const BorderSide(color: secondaryBlue)
              ),
              primary: Colors.white,
              fixedSize: _getButtonSize(context),
              onPrimary: secondaryBlue
            ),
            onPressed: () => takeImage(ImageSource.camera, ref, context),
            icon: const Icon(Icons.camera_alt),
            label: const LabelSmall12SemiBold("Take a picture", color: secondaryBlue,)
          ),
          const SizedBox(height: 20.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius
              ),
              fixedSize: _getButtonSize(context),
              primary: secondaryBlue
            ),
            onPressed: () => takeImage(ImageSource.gallery, ref, context),
            icon: const Icon(Icons.photo_library),
            label: const LabelSmall12SemiBold("Upload photo from gallery", color: Colors.white,)
          ),
        ],
      ),
    );
  }
}

class AllayFilePicker extends ConsumerWidget {
  final ImagePicker _imagePicker = ImagePicker();
  final ValueChanged<List<dynamic>> onFilesPicked;
  final bool allowMultiSelect;
  AllayFilePicker({Key? key, required this.onFilesPicked, this.allowMultiSelect = false}) : super(key: key);
  final EdgeInsetsGeometry buttonPadding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  final BorderRadiusGeometry borderRadius = BorderRadius.circular(5.0);

  Size _getButtonSize(BuildContext context) {
    return Size(MediaQuery.of(context).size.width-50, 50);
  }

  void takeImage(ImageSource imageSource, WidgetRef ref, BuildContext context) async {
    if (imageSource == ImageSource.camera) {
      XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front);
      if (image != null) {
        onFilesPicked([image]);
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: allowMultiSelect,
        allowCompression: true,
        allowedExtensions: ['jpg', 'png', 'pdf', 'docx', 'doc']
      );
      if (result != null) {
        onFilesPicked(result.files);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: const BorderSide(color: secondaryBlue)
              ),
              primary: Colors.white,
              fixedSize: _getButtonSize(context),
              onPrimary: secondaryBlue
            ),
            onPressed: () => takeImage(ImageSource.camera, ref, context),
            icon: const Icon(Icons.camera_alt),
            label: const LabelSmall12SemiBold("Take a picture", color: secondaryBlue,)
          ),
          const SizedBox(height: 20.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius
              ),
              fixedSize: _getButtonSize(context),
              primary: secondaryBlue
            ),
            onPressed: () => takeImage(ImageSource.gallery, ref, context),
            icon: const Icon(Icons.photo_library),
            label: const LabelSmall12SemiBold("Upload a file", color: Colors.white,)
          ),
        ],
      ),
    );
  }
}