import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const CustomInkwell({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child:child
    );
  }
}
