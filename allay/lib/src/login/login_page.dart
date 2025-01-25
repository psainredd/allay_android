import 'package:allay/src/login/verify_otp.dart';
import 'package:allay/src/util/error.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/util/urls.dart';
import 'package:allay/src/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/verify_otp_request.dart';
import '../util/validator.dart';

_launchUrl(String url) async {
  await launch(url);
}

final mobileNumberProvider = StateProvider.autoDispose<String>((ref) => "");

bool _isValidMobileNumber(String? mobileNumber) {
  var input = mobileNumber??'';
  String pattern = '^[0-9]{10}\$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(input);
}

String? _validateMobileNumber(String? mobileNumber) {
  if (_isValidMobileNumber(mobileNumber)) {
    return null;
  }
  return "Please enter a valid mobile number";
}

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var focusNode = FocusNode();
    return (
        Scaffold(
          body: Center(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/login_abstract.png'),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          children: [
                            const HeaderWidget(),
                            MobileNumberWidget(focusNode: focusNode),
                          ],
                        ),
                        BottomWidget(focusNode: focusNode,)
                      ],
                    ),
                  ),
                ],
              )
          ),
        )
    );
  }
}

class MobileNumberWidget extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode? focusNode;
  MobileNumberWidget({Key? key, this.focusNode}) : super(key: key);

  void _getMobileNumber(WidgetRef ref) async {
    final SmsAutoFill _autoFill = SmsAutoFill();
    final completePhoneNumber = await _autoFill.hint;
    if (completePhoneNumber != null) {
      ref.read(mobileNumberProvider.notifier).state =
          getNumberWithoutCountryCode(completePhoneNumber);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String mobileNumber = ref.watch(mobileNumberProvider);
    TextEditingController controller = TextEditingController()
      ..text = mobileNumber
      ..selection = TextSelection.fromPosition(TextPosition(offset: mobileNumber.length));
    if (mobileNumber.isEmpty) {
      _getMobileNumber(ref);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Form(
        key: _formKey,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          validator: _validateMobileNumber,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          onTap: () {},
          onEditingComplete: () {
            _formKey.currentState!.validate();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          cursorColor: primaryTextColor,
          cursorWidth: 0.7,
          onChanged: (value) => ref.read(mobileNumberProvider.notifier).state = value,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(6.0),
            focusColor: primaryTextColor,
            labelText: 'Mobile Number',
            counterText: "",
            prefix: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('+91',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor
                    )
                )
            ),
            border: UnderlineInputBorder(),
            hintText: 'Enter mobile number',
          ),
        ),
      ),
    );
  }
}


class BottomWidget extends ConsumerWidget {
  const BottomWidget({Key? key, this.focusNode}) : super(key: key);
  final FocusNode? focusNode;

  void _onProceedPressed(BuildContext context, String mobileNumber, WidgetRef ref) {
    if (!_isValidMobileNumber(mobileNumber)) {
      focusNode?.requestFocus();
      showErrorSnackBar("Invalid mobile number.", context);
      return;
    }
    var requestBody = SendOTPRequest(mobileNumber: mobileNumber);
    var responseFuture = ref.read(sendOTPProvider(requestBody).future);
    responseFuture.then((response) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: VerifyOTP(
              otpExpirationTime: response.expirationTime,
              otpMessageRegex: response.otpMessageFormat,
            ),
          );
        },
        elevation: 10,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        useRootNavigator: true,
        isDismissible: false,
        isScrollControlled: true,
      );
    }).onError((error, stackTrace) {
      showErrorSnackBar("Unable to request OTP", context);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String mobileNumber = ref.watch(mobileNumberProvider);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () => _onProceedPressed(context, mobileNumber, ref),
                style:  primaryButtonStyle,
                child: const Text("Proceed")
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: TermsAndConditionsWidget(),
            )
          ],
        )
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: HeadingBold('Login or Create account'),
            ),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: BodyText2('Log in or create an account to join Allay'),
            ),
          ],
        ),
      )
    );
  }
}

class TermsAndConditionsWidget extends StatelessWidget {
  const TermsAndConditionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          style: const TextStyle(color: subTextColor, fontSize: 10, fontFamily: fontFamily),
          children: [
            const TextSpan(text: 'By proceeding, you agree to our '),
            TextSpan(
                text: 'Terms & Conditions',
                style: const TextStyle(color: secondaryBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchUrl(termsNConditionsUrl);
                  }
            ),
            const TextSpan(text: ' & '),
            TextSpan(
                text: 'Privacy Policy.',
                style: const TextStyle(color: secondaryBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchUrl(privacyUrl);
                  }
            ),
            const TextSpan(text: ' Allay guarantees that your data will not be used for purposes other than the ones you approved.'),
          ]
        )
    );
  }
}