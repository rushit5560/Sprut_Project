import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  PrimaryContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      child: Center(child: child),
      height: 6.h,
      width: 6.h,
      decoration: BoxDecoration(
          color: colorScheme.primary, borderRadius: BorderRadius.circular(5)),
    );
  }
}
