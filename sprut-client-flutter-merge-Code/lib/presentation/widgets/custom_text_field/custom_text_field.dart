import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObsecure;
  final String hintText;
  final bool isOther;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType textInputType;
  final bool isHomeScreen;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.onChanged,
      this.isObsecure = false,
      this.isHomeScreen = false,
      this.focusNode,
      this.isOther=false,
      this.inputFormatters,
      this.validator,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.textInputType = TextInputType.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: colorScheme.background, width: 1.5),
    );

    final focusedBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: isHomeScreen ? colorScheme.background : colorScheme.primary,
          width: 1.5),
    );

    return TextFormField(
      inputFormatters: inputFormatters,
      validator: validator,
      cursorColor: colorScheme.primary,
      onChanged: onChanged,
      style: textTheme.bodyText2!.copyWith(
          fontSize: 10.sp,
          color: AppThemes.dark,
          decoration: TextDecoration.none),
      controller: controller,
      decoration: InputDecoration(
          prefixText: isHomeScreen==true ? "" : isOther==true? "+380":"",
          prefixStyle: textTheme.bodyText2!
              .copyWith(fontSize: 10.sp, color: AppThemes.dark),
          contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelStyle: textTheme.bodyText2!.copyWith(
              decoration: TextDecoration.none,
              fontSize: 9.sp,
              letterSpacing: 0.50,
              color: colorScheme.secondary),
          labelText: hintText,
          border: inputBorder,
          focusedBorder: focusedBorder,
          enabledBorder: inputBorder,
          filled: true,
          fillColor: colorScheme.background),
      keyboardType: textInputType,
      obscureText: isObsecure,
    );
  }
}
