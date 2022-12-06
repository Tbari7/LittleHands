import 'package:flutter/material.dart';

class AppDropDownButton<T> extends StatelessWidget {
  const AppDropDownButton({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  final String hintText;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: DropdownButtonFormField(
        isDense: true,
        hint: Text(hintText),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
