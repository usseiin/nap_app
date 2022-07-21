import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: DateTime(1800),
        lastDate: DateTime(2050),
      ),
    );
  }
}
