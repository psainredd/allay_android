import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  final String label;
  final Widget child;
  const SectionContainer({required this.label, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSemiBold(label),
              child
            ],
          ),
        )
    );
  }
}

class HomePageSection extends StatelessWidget {
  final Widget child;
  const HomePageSection(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey, width: 0.5)
        ),
        child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: child
        ),
      ),
    );
  }
}

class HomeSectionBody extends StatelessWidget {
  final Widget child;
  const HomeSectionBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: child
    );
  }
}

class HomeSectionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function()? onPressed;
  final Color? iconColor;
  final Color? labelColor;
  final double? size;

  const HomeSectionIconButton(
      { Key? key,
        required this.icon,
        required this.label,
        this.onPressed,
        this.iconColor = secondaryBlue,
        this.labelColor = secondaryTextColor,
        this.size = 30
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(icon, color: iconColor, size: size,),
            ),
          ),
          ButtonLabel(label, color: labelColor,)
        ],
      ),
      onTap: onPressed,
    );
  }

}