import 'package:allay/src/landing_page/landing_page.dart';
import 'package:allay/src/util/specialities.dart';
import 'package:allay/src/widgets/custom_icons.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ServiceWidget _getConsultation(List<SearchItem> specialties, BuildContext context) =>
  ServiceWidget (
    'Doctors',
    icon: MedicalIcons.doctor,
    onPressed: () => showSearchPage(specialties, context),
    backgroundImage: 'tile_background.png',
    caption: 'Book Appointment',
  );

ServiceWidget _getPharmacy() =>
  ServiceWidget (
    'Pharmacy',
    icon: Icons.medication_sharp,
    onPressed: () {},
    backgroundImage: 'tile_background_90.png',
    caption: 'Buy medicines ',
  );

ServiceWidget _getDiagnostics() =>
  ServiceWidget (
    'Diagnostics',
    icon: MedicalIcons.tac,
    onPressed: () {},
    backgroundImage: 'tile_background_180.png',
    caption: 'Health checkup & tests',
  );

ServiceWidget _getInsurance() =>
  ServiceWidget (
    'Insurance',
    icon: Icons.health_and_safety,
    onPressed: () {},
    backgroundImage: 'tile_background_270.png',
    caption: 'Buy insurance'
  );

class ServicesGrid extends ConsumerWidget {
  final List<SearchItem> specialities;
  const ServicesGrid({Key? key, required this.specialities}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      crossAxisCount: 2,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _getConsultation(specialities, context),
        _getDiagnostics(),
        _getPharmacy(),
        _getInsurance()
      ],
    );
  }
}

class ServiceWidget extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Function? onPressed;
  final String? backgroundImage;
  final String? caption;

  const ServiceWidget(
    this.label,
    { Key? key,
    this.icon,
    this.onPressed,
    this.backgroundImage,
    this.caption }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() => ServiceWidgetState();
}

class ServiceWidgetState extends State<ServiceWidget> {
  String label = '';
  IconData? icon;
  Function? onPressed;
  String caption='';
  String image='';

  @override
  void initState() {
    super.initState();
    label = widget.label;
    icon  = widget.icon;
    onPressed = widget.onPressed;
    caption = widget.caption??'';
    image = widget.backgroundImage??'assets/background.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage('assets/$image'),
          fit: BoxFit.cover
        )
      ),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.greenAccent, size: 30.0,),
              HeadingSemiBold(label, color: Colors.white),
              LabelTiny(caption, color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}