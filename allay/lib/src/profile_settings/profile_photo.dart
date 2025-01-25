import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/network.dart';
import '../widgets/colors.dart';
import '../widgets/file_picker.dart';
import '../widgets/image.dart';
import '../widgets/text_widgets.dart';

final showProfilePicProgressBar = StateProvider.autoDispose<bool>((ref) => false);

final profilePictureProvider = StateNotifierProvider.autoDispose<ProfilePictureProviderNotifier, String?>(
  (ref) => ProfilePictureProviderNotifier(ref)
);

class ProfilePictureProviderNotifier extends StateNotifier<String?> {
  final Ref ref;
  ProfilePictureProviderNotifier(this.ref) : super(null){
    _fetch();
  }

  void _fetch() async {
    state = await getGetProfilePictureUrl();
  }

  void updateImage(XFile image, String fileType, BuildContext context) async {
    String url = await getUploadProfilePictureUrl(fileType);
    uploadImage(url, image, fileType);
    state = image.path;
  }
}


class TopWidget extends ConsumerWidget {
  const TopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var showProgressBar = ref.watch(showProfilePicProgressBar);
    return Column(
      children: [
        const ProfilePhotoWidget(),
        (showProgressBar? const LinearProgressIndicator(): Container()),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: Divider(height: 0.1, color: subTextColor, indent: 8.0, endIndent: 8.0, thickness: 0.2,),
        ),
      ],
    );
  }
}

class ProfilePhotoWidget extends ConsumerWidget {
  const ProfilePhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String imageSrc = ref.watch(profilePictureProvider)??"";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RectangularPhoto (
            imageSrc: imageSrc.isEmpty?'assets/tile_background.png': imageSrc,
            margin: const EdgeInsets.fromLTRB(2, 2, 24, 2),
            width: 125,
            height: 125,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  primary: secondaryBlue,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: AllayImagePicker(
                          onImagePicked: (image) {
                            if (image != null) {
                              ref.read(profilePictureProvider.notifier).
                              updateImage(image, image.path.split(".").last, context);
                            }
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
                label: const LabelSmall12SemiBold("Upload photo", color: Colors.white,)
              ),
              const SizedBox(height: 10.0),
              const LabelTinyRegular("Allowed only JPG & PNG. Max Size 2MB.", color: subTextColor)
            ],
          )
        ],
      ),
    );
  }
}
