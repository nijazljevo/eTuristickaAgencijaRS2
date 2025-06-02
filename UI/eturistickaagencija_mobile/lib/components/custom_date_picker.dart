import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key,
      required this.dateController,
      required this.hint,
      this.validator});
  final Function(String)? validator;
  final TextEditingController dateController;
  final String hint;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.dateController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_month_outlined),
            labelText: widget.hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.dateController.text =
                    DateFormat("dd. MM. yyyy.").format(DateTime.now());
              },
            )),
        readOnly: true,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) => widget.validator != null
            ? widget.validator!(value ?? '') ?? null
            : null,
        onTap: () {
          //DateTime? resultingDate = DateTime.parse(widget.dateController.text);
          showCupertinoDialog(
              CupertinoDatePicker(
                minimumDate: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.tryParse(widget.dateController.text),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    widget.dateController.text =
                        DateFormat("dd. MM. yyyy.").format(newDateTime);
                    //resultingDate = newDateTime;
                  });
                },
              ),
              context);
        });
  }
}

void showCupertinoDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
