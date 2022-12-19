import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 400;

  static bool isMediumMobile(BuildContext context) =>
      MediaQuery.of(context).size.width > 400 &&
      MediaQuery.of(context).size.width <= 760;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 760 &&
      MediaQuery.of(context).size.width <=1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >1024;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    if (_size.width >= 1100) {
      return desktop;
    } else if (_size.width >= 850) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
