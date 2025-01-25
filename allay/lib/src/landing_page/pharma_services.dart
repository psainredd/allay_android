import 'package:allay/src/widgets/allay_containers.dart';
import 'package:allay/src/widgets/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PharmaServices extends StatelessWidget {
  const PharmaServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageSection(
        SectionContainer(
          label: "Pharmacy",
          child: _Services()
        )
    );
  }
}

class _Services extends StatelessWidget {
  const _Services({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeSectionBody(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          HomeSectionIconButton(icon: MedicalIcons.prescription_document_filled, label: 'Refill Prescription', size: 25.0),
          HomeSectionIconButton(icon: Icons.countertops, label: 'OTC Medications', size: 25.0),
          HomeSectionIconButton(icon: Icons.medication_sharp, label: 'Medications with Rx', size: 25.0),
        ],
      )
    );
  }
}