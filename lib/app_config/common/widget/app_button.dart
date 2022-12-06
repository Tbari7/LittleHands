import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import '../constants/app_color/app_color.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.isLoading,
      this.color = AppColor.primary})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      color: color,
      child: isLoading
          ? const CircularProgressIndicator(color: AppColor.white)
          : Text(text),
    );
  }
}
