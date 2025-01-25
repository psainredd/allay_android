import 'package:allay/src/widgets/allay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagnosticService extends StatelessWidget {
  const DiagnosticService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageSection(
        SectionContainer(
            label: "Diagnostics",
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
            HomeSectionIconButton(icon: FontAwesomeIcons.fileWaveform, label: 'Off Prescription', size: 20,),
            HomeSectionIconButton(icon: Icons.monitor_heart, label: 'Body checkup' , size: 25,),
            HomeSectionIconButton(icon: Icons.inventory, label: 'Collect samples' , size: 23,),
            HomeSectionIconButton(icon: Icons.timeline, label: 'Check status', size: 25,),
          ],
        )
    );
  }
}