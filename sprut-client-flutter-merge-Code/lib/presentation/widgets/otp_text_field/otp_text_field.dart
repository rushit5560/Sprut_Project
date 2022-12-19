import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';

class OtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget suffixIcon;
  Function(String) onChanged;

  OtpTextField({required this.controller, this.prefixIcon, this.validator,required this.onChanged,required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
        height: 7.h,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(9)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 4,
              ),
              prefixIcon!,
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: PinCodeTextField(
                  validator: validator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  cursorColor: colorScheme.primary,
                  appContext: context,
                  keyboardType: TextInputType.phone,
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    errorBorderColor: Colors.red,
                      selectedColor: colorScheme.primary,
                      activeColor: colorScheme.primary,
                      fieldOuterPadding: EdgeInsets.symmetric(horizontal: 3),
                      fieldWidth: 30,
                      shape: PinCodeFieldShape.underline,
                      borderWidth: 1,
                      fieldHeight: 30,
                      inactiveColor: Colors.grey[400]),
                  animationDuration: Duration(milliseconds: 300),

                  // enableActiveFill: true,
                  textStyle: textTheme.bodyText1!.copyWith(fontSize: 10.sp),
                  controller: controller,
                  onCompleted: (v) {
                    // Navigator.of(context).pop();
                  },
                  onChanged: onChanged,
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
            suffixIcon
            ],
          ),
        ));
  }
}
