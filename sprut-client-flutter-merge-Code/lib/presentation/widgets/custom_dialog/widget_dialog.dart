import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../resources/app_constants/app_constants.dart';

class WidgetDialog extends StatelessWidget {
  final Widget? messageWidget;
  final Widget titleWidget;
  final String icons;
  final String okButtonText;
  final String closeButtonText;
  final bool isSingleButton;
  final bool isBothButtonHide;
  final bool isCloseDialog;
  final Function() onPositivePressed;
  final Function() onNegativePressed;

  WidgetDialog(
      {this.messageWidget,
      required this.titleWidget,
      required this.icons,
      required this.okButtonText,
      required this.closeButtonText,
      required this.isSingleButton,
      required this.isBothButtonHide,
      required this.isCloseDialog,
      required this.onPositivePressed,
      required this.onNegativePressed});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: AppThemes.foodBgColor,
      child: WillPopScope(
        onWillPop: () async => isCloseDialog,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsPath.cashBackBgImagePng),
                fit: BoxFit.fill),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      icons,
                    ),
                    height: 63,
                    width: 63,
                    decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(top: 24.0),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 24.0),
                    child: titleWidget,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: messageWidget,
                    ),
                  ),
                ),
                if(!isBothButtonHide)...[
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: onPositivePressed,
                        child: Text(
                          okButtonText,
                          style: TextStyle(
                              color: AppThemes.colorWhite,
                              fontSize: 12.sp,
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(107.0, 6.h)),
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                          MaterialStateProperty.all(colorScheme.primary),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: AppThemes.darkGrey.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isSingleButton) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          onPressed: onNegativePressed,
                          child: Text(
                            closeButtonText,
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12.sp,
                                fontFamily: AppConstants.fontFamily,
                                fontWeight: FontWeight.w400),
                          ),
                          style: ButtonStyle(
                            minimumSize:
                            MaterialStateProperty.all(Size(107.0, 1.h)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ]
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
