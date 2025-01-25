import 'dart:core';

import 'package:allay/src/landing_page/appointments.dart';
import 'package:allay/src/landing_page/diagnostic_services.dart';
import 'package:allay/src/landing_page/doctors.dart';
import 'package:allay/src/landing_page/insurance_services.dart';
import 'package:allay/src/landing_page/pharma_services.dart';
import 'package:allay/src/landing_page/specialities.dart';
import 'package:allay/src/landing_page/location.dart';
import 'package:allay/src/landing_page/services.dart';
import 'package:allay/src/landing_page/main_search.dart';
import 'package:allay/src/profile_settings/profile_settings.dart';
import 'package:allay/src/util/allay_shared_prefs.dart';
import 'package:allay/src/util/camera.dart';
import 'package:allay/src/util/network.dart';
import 'package:allay/src/widgets/custom_icons.dart';
import 'package:allay/src/widgets/nav_drawer.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../util/error.dart';
import '../util/specialities.dart';

List<Widget> _getActionWidgets() =>
    [
      IconButton (
          onPressed: () {},
          icon: const Icon(Icons.notifications, color:primaryBlue)
      ),
    ];

LocationWidget _getLocationWidget() =>
    const LocationWidget(
        preferredSize: Size.fromHeight(25.0),
        child: Location(color: subTextColor,)
    );

FloatingActionButton _getFloatingActionButton (context) =>
    FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Camera())
        );
      },
      child: const Icon(Icons.qr_code_scanner_outlined),
      mini: false,
      backgroundColor: Colors.greenAccent,
    );

BottomNavigationBar _getBottomNavBar() =>
    BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      iconSize: 25,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      selectedItemColor: secondaryBlue,
      unselectedItemColor: subTextColor,
      showUnselectedLabels: true,
      elevation: 20.0,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home)
        ),
        BottomNavigationBarItem(
          label: 'Consult Doctor',
          icon: Icon(MedicalIcons.doctor)
        ),
        BottomNavigationBarItem(
            label: 'Quick scan',
            icon: Icon(Icons.qr_code_scanner)
        ),
        BottomNavigationBarItem(
            label: 'Buy Medicines',
            icon: Icon(Icons.medication)
        ),
        BottomNavigationBarItem(
            label: 'Insurance',
            icon: Icon(Icons.health_and_safety)
        )
      ],
    );

void showSearchPage(List<SearchItem> searchItems, BuildContext context) {
  showSearch(
    context: context,
    delegate: MainSearchDelegate(context: context, suggestions: searchItems),
  );
}

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    User user  = ref.watch(savedUserInfoProvider).value!;
    if (user.isActive??false) {
      return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const LocationWidget(preferredSize: Size.fromHeight(25.0)),
          actions: _getActionWidgets(),
          elevation: 0,
          iconTheme: const IconThemeData(
              size: 25.0
          ),
        ),
        body: const LandingPageBody(),
        bottomNavigationBar: _getBottomNavBar()
      );
    } else {
      return const UserProfile(title: "Create Profile");
    }
  }
}

class LandingPageBody extends ConsumerWidget {
  const LandingPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userAsyncValue = ref.watch(networkUserProvider);
    List<SearchItem> specialities = [];
    ref.watch(specialitiesProvider).when(
        data: (data) => specialities = data,
        error: (error, stackTrace) => showErrorSnackBar("Something went wrong", context),
        loading: () => {}
    );
    return userAsyncValue.when(
      data: (data) => _getWidget(data!, specialities),
      error: (error, stackTrace) => _getErrorWidget(),
      loading: () => const Center(child: CircularProgressIndicator())
    );
  }

  Widget _getWidget(User user, List<SearchItem> specialities) {
    return SingleChildScrollView(
      child: Container (
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelSmall('Welcome ${user.firstName}!', color: secondaryBlue),
            MainSearch(specialities: specialities),
            ServicesGrid(specialities: specialities),
            Appointments(),
            Specialities(),
            Doctors(),
            PharmaServices(),
            DiagnosticService(),
            InsuranceServices()
          ],
        ),
      ),
    );
  }

  Widget _getErrorWidget() {
    return const Center(
      child: Label('Something went wrong'),
    );
  }
}