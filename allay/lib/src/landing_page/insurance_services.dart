import 'package:allay/src/widgets/allay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InsuranceServices extends StatelessWidget {
  const InsuranceServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageSection(
        SectionContainer(
            label: "Insurance",
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
            HomeSectionIconButton(icon: Icons.health_and_safety, label: 'Buy Insurance', size: 25.0),
            HomeSectionIconButton(icon: Icons.add_moderator, label: 'Add Dependents', size: 25.0),
            HomeSectionIconButton(icon: Icons.update, label: 'Update Plan', size: 25.0),
          ],
        )
    );
  }
}