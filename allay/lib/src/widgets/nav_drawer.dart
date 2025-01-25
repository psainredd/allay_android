import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/custom_icons.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavDrawer extends StatelessWidget {
  final GlobalKey _headerKey = GlobalKey();
  NavDrawer({Key? key}) : super(key: key);

  double _getHeaderHeight() {
    final RenderBox renderBox = _headerKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size; // or _widgetKey.currentContext?.size
    return size.height;
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[50],
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: 315,
            expandedHeight: 315,
            automaticallyImplyLeading: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: _DrawerHeader(key: _headerKey),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _DrawerMenu();
              },
              childCount: 1
            )
          )
        ],
      )
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight+16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _Avatar(),
          const HeadingSemiBold('Pragya Jaiswal', size: 18, color: secondaryTextColor),
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom:4),
            child: _DrawerHeaderLabel(
              icon: Icons.cake,
              label: '12 Jan 1991, 31 years',
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom:0),
            child: _DrawerHeaderLabel(
              icon: Icons.location_on,
              label: 'Bangalore, India',
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 95.0,
      backgroundColor: Colors.grey[200],
      child: const CircleAvatar(
        foregroundImage: NetworkImage(
          'https://3.bp.blogspot.com/-p4yxNFlMWxA/XqgGrtv8A8I/AAAAAAAAAsY/cFcb1IaJmHMVdzUqYLgMYTJh3okuufcqwCLcBGAsYHQ/s1600/Pragya-Jaiswal-1.jpg'
        ),
        radius: 85.0,
      ),
    );
  }
}

class _DrawerHeaderLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _DrawerHeaderLabel({Key? key, required this.label, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LabelIcon(
      label,
      icon,
      spacing: 8,
      color: subTextColor,
      alignment: MainAxisAlignment.center,
    );
  }
}

class _DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          const ListTile(
            title: Label('Dashboard', color: secondaryBlue),
            leading: Icon(Icons.dashboard, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('My Doctors', color: secondaryBlue),
            leading: Icon(MedicalIcons.doctor, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Appointments', color: secondaryBlue),
            leading: Icon(Icons.calendar_month, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Prescriptions', color: secondaryBlue),
            leading: Icon(MedicalIcons.prescription_document_filled, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Medical Records', color: secondaryBlue),
            leading: Icon(FontAwesomeIcons.notesMedical, color: secondaryBlue, size: 20),
          ),
          const ListTile(
            title: Label('Billing History', color: secondaryBlue),
            leading: Icon(Icons.receipt_long, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Pharmacy', color: secondaryBlue),
            leading: Icon(Icons.local_pharmacy, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Diagnostics', color: secondaryBlue),
            leading: Icon(MedicalIcons.tac, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Insurance', color: secondaryBlue),
            leading: Icon(Icons.health_and_safety, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Profile Settings', color: secondaryBlue),
            leading: Icon(Icons.manage_accounts, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('Logout', color: secondaryBlue),
            leading: Icon(Icons.logout_outlined, color: secondaryBlue),
          ),
          const ListTile(
            title: Label('About Us', color: secondaryTextColor),
          ),
        ],
      ).toList()
    );
  }

}