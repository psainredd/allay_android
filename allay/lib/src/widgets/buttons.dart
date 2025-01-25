import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const fontFamily = 'Poppins';
const defaultFontFamily = TextStyle(fontFamily: fontFamily);
const fontSize18 = TextStyle(fontSize: 18);
const fontSizeSemiBold = TextStyle(fontWeight: FontWeight.w600);

final primaryButtonStyle =
  ElevatedButton.styleFrom(
      elevation: 0,
      primary: secondaryBlue,
      fixedSize: const Size.fromHeight(55),
  );

final textButtonStyle = TextButton.styleFrom(primary: secondaryBlue);

class PopUpButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData iconData;
  final Color? color;
  const PopUpButton({
    required this.label,
    this.onPressed,
    this.color,
    required this.iconData,
    Key? key
  }):super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: GestureDetector(
        child: Container(
          alignment: AlignmentDirectional.topStart,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: subTextColor, width: 0.2),
              borderRadius: BorderRadius.circular(5.0)
          ),
          child: TextButton.icon (
            onPressed:onPressed,
            icon: Icon(iconData, color: color??subTextColor, size: 20.0),
            label: LabelSmall(label, color: color??subTextColor)
          ),
        ),
        onTap: () => onPressed,
      )
    );
  }
}