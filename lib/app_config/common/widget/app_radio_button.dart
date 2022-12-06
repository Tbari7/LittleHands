import 'package:flutter/material.dart';

class AppRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String text;

  const AppRadioButton({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.groupValue,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(text),
    );
  }
}
