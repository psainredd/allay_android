import 'package:allay/src/profile_settings/profile_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../widgets/colors.dart';
import '../widgets/text_widgets.dart';
import 'address_info.dart';
import 'basic_profile_info.dart';
import 'profile_photo.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  final User user;
  final GlobalKey<FormState> globalKey;
  final VoidCallback onMoveToNextPage;
  const ProfileWidget({Key? key, required this.user, required this.onMoveToNextPage, required this.globalKey}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileWidgetState();
}

class ProfileWidgetState extends ConsumerState<ProfileWidget> {
  late User _user;
  late GlobalKey<FormState> _globalKey;
  late VoidCallback _onMoveToNextPage;

  @override
  void initState() {
    _user = widget.user;
    _globalKey = widget.globalKey;
    _onMoveToNextPage = widget.onMoveToNextPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
        child: Column(
          children: [
            const TopWidget(),
            BasicProfileInfo(formKey: _globalKey, userFromServer: _user),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 12),
              child: Divider(height: 0.1, color: subTextColor, indent: 8.0, endIndent: 8.0, thickness: 0.2,),
            ),
            AddressWidget(address: _user.address),
            FillMedicalDetailsButton(
              formKey: _globalKey,
              medicalProfileFromServer: _user.medicalProfile,
              onPressed: onFillMedicalProfile,
            )
          ],
        )
      ),
    );
  }

  void onFillMedicalProfile() {
    Address address = ref.read(addressProvider);
    String? profilePictureUrl = ref.read(profilePictureProvider);
    User userBasicProfile = ref.read(basicProfileProvider)
      ..address = address
      ..profilePictureUrl = profilePictureUrl;
    ref.read(userProfileProvider.notifier).state = userBasicProfile;
    _onMoveToNextPage();
  }
}

class FillMedicalDetailsButton extends ConsumerWidget {
  final GlobalKey<FormState>? formKey;
  final MedicalProfile? medicalProfileFromServer;
  final VoidCallback? onPressed;
  const FillMedicalDetailsButton({Key? key, this.formKey, this.medicalProfileFromServer, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
              ),
              primary: Colors.green
            ),
            onPressed: onPressed,
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Icon(Icons.arrow_back_outlined),
            ),
            label: const LabelSmall("Fill Medical Details", color: Colors.white,)
          ),
        ),
      ),
    );
  }
}