import 'package:allay/src/util/specialities.dart';
import 'package:allay/src/widgets/allay_containers.dart';
import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Specialities extends StatelessWidget {
  const Specialities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePageSection(
     SectionContainer (
        label: 'Specialities',
        child: _SpecialitiesWidget(),
      ),
    );
  }
}

class _SpecialitiesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: GridView.count(
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        shrinkWrap: true,
        primary: true,
        children: _getSpecialities(),
      ),
    );
  }

  List<Widget> _getSpecialities() {
    var subset = medicalSpecialities.sublist(0, 7);
    var result = subset.map((e) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(e.icon?.icon, color: secondaryBlue, size: 30,),
          ),
          ButtonLabel(e.label, color: secondaryTextColor,)
        ],
      );
    }).toList();
    result.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.arrow_forward, color: secondaryTextColor, size: 25.0),
            ),
            ButtonLabel('See More', color: secondaryTextColor)
          ],
        )
    );
    return result;
  }
}