import 'package:allay/src/widgets/colors.dart';
import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

SnackBar _getErrorSnackBar(
    String message,
    BuildContext context,
    EdgeInsetsGeometry? margin) {
  return  SnackBar(
    content: LabelIconSmall12(message, Icons.error_outline, color:Colors.white),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    margin: margin,
  );
}

void showErrorSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(_getErrorSnackBar(message, context, null));
}

void showErrorSnackBarOnTop(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    _getErrorSnackBar(message, context,
      EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 20
      ),
    )
  );
}

SnackBar _getInfoSnackBar(
    String message,
    BuildContext context,
    EdgeInsetsGeometry? margin) {
  return  SnackBar(
    content: LabelIconSmall12(message, Icons.info_outline, color:Colors.white),
    backgroundColor: secondaryBlue,
    behavior: SnackBarBehavior.floating,
    margin: margin,
  );
}

void showSnackBarMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(_getInfoSnackBar(message, context, null));
}

void showSnackBarMessageOnTop(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    _getInfoSnackBar(message, context,
      EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        right: 20,
        left: 20
      )
    )
  );
}

SnackBar _getSuccessSnackBar(
    String message,
    BuildContext context,
    EdgeInsetsGeometry? margin) {
  return  SnackBar(
    content: LabelIconSmall12(message, Icons.check_circle_outline, color:Colors.white),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    margin: margin,
  );
}

void showSnackBarSuccessMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(_getSuccessSnackBar(message, context, null));
}

void showSnackBarSuccessMessageOnTop(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      _getSuccessSnackBar(message, context,
          EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20
          )
      )
  );
}