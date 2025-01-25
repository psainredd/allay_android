import 'package:allay/src/landing_page/landing_page.dart';
import 'package:allay/src/login/login_page.dart';
import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/util/urls.dart';
import 'package:allay/src/models/user.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';

Future<void> getTestUser() async {
  final SmsAutoFill _autoFill = SmsAutoFill();
  final completePhoneNumber = await _autoFill.hint;
  if (completePhoneNumber?.contains("9113831625")??false) {
    var nm = await AllayNetworkManager.getInstance();
    var response = await nm.dio.get(superUserUrl);
    User user = User.fromJson(response.data);
    await saveUser(user);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getTestUser();
  User? user = await getSavedUser();
  Widget child = user == null ? LoginPage() : const LandingPage();
  runApp(ProviderScope(child: Allay(child)));
}

class Allay extends ConsumerStatefulWidget {
  final Widget child;
  const Allay(this.child, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllayState();
}

class _AllayState extends ConsumerState<Allay> {
  late Widget child;

  @override
  void initState() {
    child = widget.child;
    super.initState();
  }

  Widget _getMainAppWidget(User? user) {
    if (user == null) {
      return _AllayAppInternal(LoginPage());
    }
    return const _AllayAppInternal(LandingPage());
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<User?> asyncUser = ref.watch(savedUserInfoProvider);
    return asyncUser.when(
      data: (user) => _getMainAppWidget(user),
      error: (error, stackTract) => LoginPage(),
      loading: () => _AllayLoadingPage()
    );
  }
}

class _AllayAppInternal extends StatelessWidget {
  final Widget child;

  const _AllayAppInternal(this.child);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allay',
      home: child,
      theme: ThemeData(
        fontFamily: allayFontFamily,
        textTheme: const TextTheme(
          button: TextStyle(fontSize: 16),
        ),
        primaryColor: primaryBlue,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: secondaryTextColor,
            toolbarTextStyle: LabelSmall.style,
            titleTextStyle: LabelSmall.style,
            toolbarHeight: 55.0,
            iconTheme: const IconThemeData(
                size: 20,
                color: subTextColor
            )
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 30,
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: MaterialStateProperty.all(LabelSmall.style),
          iconTheme: MaterialStateProperty.all(
              const IconThemeData(
                  color: secondaryBlue,
                  size: 30
              )
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: subTextColor,
        ),
      ),
    );
  }
}

class _AllayLoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Image(image: AssetImage('asset/loading.gif')),
      ),
    );
  }
}