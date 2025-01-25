import 'package:allay/src/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const allayFontFamily = 'Poppins';

class _GenericTextWidget extends StatelessWidget {
  final String value;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  const _GenericTextWidget(this.value, this.fontSize, this.fontWeight, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color fontColor = color??Theme.of(context).textTheme.bodyText1?.color??primaryTextColor;
    return Text (
        value,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: fontColor,
            overflow: TextOverflow.ellipsis,
            fontFamily: allayFontFamily
        )
    );
  }
}

class HeadingBold extends StatelessWidget {
  final String value;
  final Color? color;
  final double? size;
  const HeadingBold(this.value, {Key? key, this.color, this.size = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return _GenericTextWidget(value, size??16, FontWeight.bold, color: fontColor);
  }
}

class HeadingSemiBold extends StatelessWidget {
  final String value;
  final Color? color;
  final double? size;
  const HeadingSemiBold(this.value, {Key? key, this.color, this.size = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return _GenericTextWidget(value, size??16, FontWeight.w500, color: fontColor);
  }
}

class HeadingThin extends StatelessWidget {
  final String value;
  final Color? color;
  const HeadingThin(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return _GenericTextWidget(value, 16, FontWeight.w300, color: fontColor);
  }
}

class BodyText2 extends StatelessWidget {
  final String value;
  final Color? color;
  const BodyText2(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText2?.color;
    return _GenericTextWidget(value, 12, FontWeight.w400, color: fontColor);
  }
}

class BodyText1 extends StatelessWidget {
  final String value;
  final Color? color;
  const BodyText1(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return _GenericTextWidget(value, 12, FontWeight.w400, color: fontColor);
  }
}

class Label extends StatelessWidget {
  final String value;
  final Color? color;
  const Label(this.value, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return  _GenericTextWidget(value, 14, FontWeight.w500, color: fontColor);
  }
}

class LabelBold extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelBold(this.value, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return  _GenericTextWidget(value, 14, FontWeight.w500, color: fontColor);
  }
}


class LabelSmall extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelSmall(this.value, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return  _GenericTextWidget(value, style.fontSize??13, style.fontWeight??FontWeight.w400, color: fontColor);
  }
}

class LabelSmall12 extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelSmall12(this.value, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return  _GenericTextWidget(value, style.fontSize??12, style.fontWeight??FontWeight.w400, color: fontColor);
  }
}

class LabelSmall12SemiBold extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelSmall12SemiBold(this.value, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return  _GenericTextWidget(value, style.fontSize??12, style.fontWeight??FontWeight.w400, color: fontColor);
  }
}

class ButtonLabel extends StatelessWidget {
  final String value;
  final Color? color;
  const ButtonLabel(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??primaryTextColor;
    return  _GenericTextWidget(value, 10, FontWeight.w500, color: fontColor);
  }
}

class LabelTiny extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelTiny(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??primaryTextColor;
    return  _GenericTextWidget(value, 11, FontWeight.w300, color: fontColor);
  }
}

class LabelTinyRegular extends StatelessWidget {
  final String value;
  final Color? color;
  const LabelTinyRegular(this.value, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??primaryTextColor;
    return  _GenericTextWidget(value, 11, FontWeight.w400, color: fontColor);
  }
}

class LabelIconSmall12 extends StatelessWidget {
  final String value;
  final Color? color;
  final IconData icon;
  const LabelIconSmall12(this.value, this.icon, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      children: [Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 2.0, 0),
          child: Icon(icon, size: 14, color: fontColor),
        ),
        _GenericTextWidget(value, style.fontSize??12, style.fontWeight??FontWeight.w500, color: fontColor)
      ],
    );
  }
}

class LabelIconSmall extends StatelessWidget {
  final String value;
  final Color? color;
  final IconData icon;
  const LabelIconSmall(this.value, this.icon, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 13, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      children: [Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 2.0, 0),
        child: Icon(icon, size: 16, color: fontColor),
      ),
        _GenericTextWidget(value, style.fontSize??13, style.fontWeight??FontWeight.w500, color: fontColor)
      ],
    );
  }
}

class LabelIcon extends StatelessWidget {
  final String value;
  final Color? color;
  final IconData icon;
  final double? spacing;
  final double? iconSize;
  final MainAxisAlignment? alignment;
  const LabelIcon(this.value, this.icon, {Key? key, this.color, this.spacing=2.0, this.alignment = MainAxisAlignment.start, this.iconSize = 16}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      mainAxisAlignment: alignment??MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, spacing??2.0, 0),
          child: Icon(icon, size: iconSize??16, color: fontColor),
        ),
        _GenericTextWidget(value, style.fontSize??14, style.fontWeight??FontWeight.w500, color: fontColor)
      ],
    );
  }
}

class LabelIconBold extends StatelessWidget {
  final String value;
  final Color? color;
  final Icon icon;
  const LabelIconBold(this.value, this.icon, {Key? key, this.color}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      children: [Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 2.0, 0),
        child: Icon(icon.icon, size: 16, color: fontColor),
      ),
        _GenericTextWidget(value, style.fontSize??14, style.fontWeight??FontWeight.w600, color: fontColor)
      ],
    );
  }
}

class LabelWithPrefix extends StatelessWidget {
  final String value;
  final Color? color;
  final String prefix;
  const LabelWithPrefix(this.value, {Key? key, this.color, required this.prefix}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      children: [
        _GenericTextWidget(prefix, (style.fontSize??12)+1, FontWeight.w600, color: fontColor),
        _GenericTextWidget(value, style.fontSize??13, style.fontWeight??FontWeight.w500, color: fontColor)
      ],
    );
  }
}

class LabelWithSuffix extends StatelessWidget {
  final String value;
  final Color? color;
  final String suffix;
  const LabelWithSuffix(this.value, {Key? key, this.color, required this.suffix}) : super(key: key);

  static TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    Color? fontColor = color??Theme.of(context).textTheme.bodyText1?.color;
    return Row(
      children: [
        _GenericTextWidget(value, style.fontSize??13, style.fontWeight??FontWeight.w500, color: fontColor),
        _GenericTextWidget(suffix, (style.fontSize??12)+1, FontWeight.w600, color: fontColor),
      ],
    );
  }
}
