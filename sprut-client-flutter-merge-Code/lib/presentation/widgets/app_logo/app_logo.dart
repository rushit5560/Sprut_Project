import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetsPath.logo,height: 14.h,);
  }
}