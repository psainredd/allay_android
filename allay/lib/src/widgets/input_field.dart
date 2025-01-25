import 'package:allay/src/widgets/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

const labelColor = subTextColor;
const InputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(
        color: secondaryTextColor,
        width: 0.3)
);
const InputBorder _errorBorder = OutlineInputBorder(
    borderSide: BorderSide(
        color: Colors.red,
        width: 0.5)
);
const outerPadding = EdgeInsets.all(10.0);
var innerPadding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0);
Widget _getLabel(value) => LabelSmall(value??"", color: labelColor);
var textStyle = const TextStyle( fontSize: 16 );
typedef DateSelectionCallback = void Function(DateTime date);

TextEditingController getTextEditingController(String value) {
  return TextEditingController(text: value)
    ..selection = TextSelection.fromPosition(TextPosition(offset: value.length));
}

List<Widget> getSelectedItems(List<dynamic> items) {
  return items.map((element) =>
      DropdownMenuItem<String>(
        child: Row(
          children: [
            Label(element),
          ],
        ),
        value: element,
      )
  ).toList()
    ..insert(0, const DropdownMenuItem<String>(
      child: Label("-"),
    ));
}

List<DropdownMenuItem<String>> getDropdownMenuItems(List<dynamic> items) {
  DropdownMenuItem<String> getMenuItem(String label, String? value) =>
      DropdownMenuItem<String>(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(label),
            const Divider(thickness: 0.2, color: subTextColor)
          ],
        ),
        value: value,
      );
  var result =  items.map((element) =>
      getMenuItem(element, element)).toList()
    ..insert(0, getMenuItem("-", null));
  return result;
}

class AllayTextField<T> extends ConsumerWidget {
  final GlobalKey<FormState>? formKey;
  final String? label;
  final String? hintText;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool? isEnabled;
  final bool? isReadOnly;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final ProviderBase<String?>? provider;
  final int? maxLength;
  final int? maxLines;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;

  const AllayTextField({
    this.formKey,
    this.label,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.isEnabled,
    this.isReadOnly,
    this.suffixIcon,
    this.maxLength,
    this.validator,
    this.controller,
    this.provider,
    this.onEditingComplete,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: outerPadding,
      child: TextFormField (
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        readOnly: isReadOnly??false,
        enabled: isEnabled,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          suffixIcon: suffixIcon,
          contentPadding: innerPadding,
          label: _getLabel(label),
          hintText: hintText,
          focusedBorder: _border,
          focusColor: primaryTextColor,
          disabledBorder: _border,
          enabledBorder: _border,
          errorBorder: _errorBorder,
          counterText: "",
          focusedErrorBorder: _errorBorder
        ),
        cursorWidth: 1.0,
        cursorHeight: 25,
        style: textStyle,
        keyboardType: textInputType,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
        onEditingComplete: () {
          if (onEditingComplete != null) {
            onEditingComplete!();
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}

typedef DropDownItemGenerator<T> = List<DropdownMenuItem<T>> Function();

class AllayDropDownInputField<T> extends ConsumerWidget {
  final String? label;
  final T? value;
  final GestureTapCallback? onTap;
  final ValueChanged<T?>? onChanged;
  final bool? isEnabled;
  final bool? isReadOnly;
  final FormFieldSetter<T>? onSaved;
  final DropdownButtonBuilder? selectedItemBuilder;
  final DropDownItemGenerator<T> itemGenerator;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autoValidateMode;

  const AllayDropDownInputField({
    this.label,
    required this.itemGenerator,
    this.onTap,
    this.onChanged,
    this.value,
    this.isEnabled,
    this.isReadOnly,
    this.onSaved,
    this.selectedItemBuilder,
    this.validator,
    this.autoValidateMode,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: outerPadding,
      child: DropdownButtonFormField<T> (
        onSaved: onSaved,
        value: value,
        autovalidateMode: autoValidateMode,
        selectedItemBuilder: selectedItemBuilder,
        alignment: AlignmentDirectional.topStart,
        items: itemGenerator(),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          label: _getLabel(label),
          contentPadding: innerPadding,
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          errorBorder: _errorBorder
        ),
        style: textStyle,
      ),
    );
  }
}

String? validateDateField(String label, String? val) {
  if (val == null || val.isEmpty) {
    return "Please provide " + label;
  }
  try {
    DateFormat('dd-MM-yyyy').parse(val);
  } on FormatException catch (ex) {
    return "Please enter a valid date";
  }
  return null;
}

String getFormattedDate(DateTime? date) {
  if (date == null) {
    return "";
  }
  return DateFormat('dd-MM-yyyy').format(date);
}

class AllayDateWidget extends ConsumerWidget {
  final GlobalKey<FormState>? formKey;
  final FormFieldValidator<String>? validator;
  final String? label;
  final TextEditingController? controller;
  final bool? isReadOnly;
  final DateTime? initialValue;
  final DateTime? initialDateInPicker;
  final DateTime? firstDateInPicker;
  final DateTime? lastDateInPicker;
  final DateSelectionCallback? onDateSelected;

  const AllayDateWidget({
    this.formKey,
    this.validator,
    this.label,
    this.controller,
    this.isReadOnly,
    this.initialValue,
    this.initialDateInPicker,
    this.firstDateInPicker,
    this.lastDateInPicker,
    this.onDateSelected,
    Key? key,
  }) : super(key: key);

  void _showDate(BuildContext context, WidgetRef ref) async {
    if (isReadOnly??false) return;
    var date = await showDatePicker(
        context: context,
        initialDate: initialDateInPicker??DateTime(1991),
        firstDate: firstDateInPicker??DateTime(1900),
        lastDate: lastDateInPicker??DateTime.now()
    );
    if (date == null) return;
    if (onDateSelected != null) {
      onDateSelected!(date);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? valueString = getFormattedDate(initialValue);
    return AllayTextField (
        formKey: formKey,
        label: label,
        validator: validator,
        suffixIcon: const Icon(Icons.calendar_month),
        isReadOnly: true,
        controller: getTextEditingController(valueString),
        onTap: () => _showDate(context, ref)
    );
  }
}