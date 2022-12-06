import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryElevatedBackBtn extends StatelessWidget {
  final String buttonText;
  final bool buttonTypeTwo;
  final VoidCallback onPressed;
  final height;
  final bool isHomeScreen;
  final Color? color;
  final Widget? widget;
  final fontSize;
  PrimaryElevatedBackBtn({
    required this.buttonText,
    this.widget,
    this.fontSize,
    this.isHomeScreen = false,
    this.buttonTypeTwo = false,
    this.color,
    this.height = 60.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width, height)),
        backgroundColor:
            MaterialStateProperty.all(color ?? colorScheme.primary),
        // elevation: MaterialStateProperty.all(3),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: isHomeScreen == false
            ? Text(buttonText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText2!.copyWith(
                    color: colorScheme.background, fontSize: fontSize ?? 14.sp))
            : widget,
      ),
    );
  }
}
