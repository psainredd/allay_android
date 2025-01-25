import 'package:allay/src/login/login_page.dart';
import 'package:allay/src/login/timer.dart';
import 'package:allay/src/models/verify_otp_request.dart';
import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/error.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:telephony/telephony.dart';

import '../models/user.dart';
import '../widgets/buttons.dart';

class OTPNotifier extends StateNotifier<List<int>> {
  OTPNotifier() : super(List.generate(6, (index) => -1));

  void update(int index, String value) {
    var newValues = state;
    if (value.isEmpty) {
      newValues[index] = -1;
    } else {
      newValues[index] = int.parse(value);
    }
    state = newValues;
  }

  List<int> getValues() {
    return state;
  }

  void set(String value) {
    var newValue = List.generate(6, (index) => -1);
    if (value.length !=6 ) {
      return;
    }
    for(int i=0; i<6; i++) {
     newValue[i] = int.parse(value[i]);
    }
    state = newValue;
  }
}

final otpProvider = StateNotifierProvider.autoDispose<OTPNotifier, List<int>>((ref) => OTPNotifier());

final smsPermissionProvider = StateProvider<bool>((ref) => false);

class VerifyOTP extends ConsumerStatefulWidget {
  final DateTime otpExpirationTime;
  final String otpMessageRegex;
  const VerifyOTP({Key? key, required this.otpExpirationTime, required this.otpMessageRegex}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends ConsumerState<VerifyOTP> {
  final Telephony telephony = Telephony.instance;
  late DateTime _otpExpirationTime;
  late Duration _duration;
  late RegExp _regExp;

  @override
  void initState() {
    _otpExpirationTime = widget.otpExpirationTime;
    _duration = _otpExpirationTime.difference(DateTime.now());
    _regExp = RegExp(widget.otpMessageRegex);
    _requestSMSPermission();
    super.initState();
  }

  void _readMessages(SmsMessage message, BuildContext context, WidgetRef ref) {
    String msg = message.body??"";
    if (_regExp.hasMatch(msg)) {
      var match = _regExp.matchAsPrefix(msg);
      ref.read(otpProvider.notifier).set(match?.group(2)??"");
    }
  }

  void _requestSMSPermission() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    ref.read(smsPermissionProvider.notifier).state = permissionsGranted??false;
    if(permissionsGranted??false) {
      telephony.listenIncomingSms(
        onNewMessage:(message) => _readMessages(message, context, ref),
        listenInBackground: false
      );
    }
  }

  void _onVerifyOTP(BuildContext context) {
    List<int> otpValues = ref.read(otpProvider.notifier).getValues();
    String otp = "";
    for (var e in otpValues) {
      if (e == -1) {
        showErrorSnackBarOnTop("Please enter a valid OTP", context);
        return;
      }
      otp = otp + e.toString();
    }
    String mobileNumber = ref.read(mobileNumberProvider);
    VerifyOTPRequest request = VerifyOTPRequest(mobileNumber, otp);
    ref.watch(verifyOTPProvider(request).future).
      then((user) {
        ref.read(savedUserInfoProvider.notifier).update(user);
        Navigator.pop(context);
      }).
      onError((error, _) {showErrorSnackBarOnTop("Could not verify OTP", context);});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Wrap (
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        child: HeadingSemiBold("Enter OTP"),
                      ),
                      OTPWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: TimerWidget(_duration.inSeconds),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ElevatedButton (
                      style: primaryButtonStyle,
                      onPressed: () => _onVerifyOTP(context),
                      child: const Text("Verify OTP"),
                    ),
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}

class OTPWidget extends ConsumerWidget {
  final List<FocusNode> focusNodes = List<FocusNode>.generate(6, (index) => FocusNode());
  OTPWidget({Key? key}) : super(key: key);

  void _onValueChanged(String value, int index, WidgetRef ref) {
    if (value.isEmpty) {
      if (index > 0) {
        focusNodes[index-1].requestFocus();
      }
    } else {
      if (index < 5) {
        focusNodes[index+1].requestFocus();
      }
    }
    ref.read(otpProvider.notifier).update(index, value);
  }

  Widget _getOTPCell (int index, List<int> otpValues, WidgetRef ref) {
    TextEditingController controller = TextEditingController()
      ..text = otpValues[index]==-1?"": otpValues[index].toString();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: TextFormField (
          controller: controller,
          focusNode: focusNodes[index],
          onChanged: (value) => _onValueChanged(value, index, ref),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          selectionControls: CustomTextSelectionControls(ref),
          cursorWidth: 0.7,
          onTap: () => focusNodes[index].requestFocus(),
          cursorColor: primaryTextColor,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            focusColor: primaryTextColor,
            contentPadding: EdgeInsets.all(2.0),
            border: OutlineInputBorder(borderSide: BorderSide(color: subTextColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: subTextColor)),
            hintText: "\u00B7",
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<int> otpValues = ref.watch(otpProvider);
    var widgets =  List<Widget>.generate(6, (index) => _getOTPCell(index, otpValues, ref));
    return Center(
      child: (
        Padding (
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widgets
              )
            ],
          ),
        )
      ),
    );
  }
}

bool isValidOTP(String? text) {
  String pattern = r'^[0-9]{6}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(text??"");
}

class CustomEditableTextState extends EditableTextState {
  final WidgetRef ref;

  CustomEditableTextState(this.ref);

  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if(data == null) {
      return;
    }

    if (!isValidOTP(data.text)) {
      return;
    }
    hideToolbar();
    FocusManager.instance.primaryFocus?.unfocus();
    ref.read(otpProvider.notifier).set(data.text??"");
  }
}

class CustomTextSelectionControls extends MaterialTextSelectionControls {
  final WidgetRef ref;
  late CustomEditableTextState customEditableTextState;
  CustomTextSelectionControls(this.ref) {
    customEditableTextState = CustomEditableTextState(ref);
  }

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    customEditableTextState.pasteText(SelectionChangedCause.toolbar);
  }
}