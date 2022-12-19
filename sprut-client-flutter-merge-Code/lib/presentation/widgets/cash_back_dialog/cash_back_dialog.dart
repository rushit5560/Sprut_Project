import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../resources/app_constants/app_constants.dart';

class CashBackDialog extends StatelessWidget {
  final String message;

  CashBackDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: AppThemes.foodBgColor,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsPath.cashBackBgImagePng),
                fit: BoxFit.fill)),
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
                    AssetsPath.cashBackLogo,
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
                  child: Text(
                    language.what_a_cash_back,
                    style: textTheme.bodyText2!
                        .copyWith(fontSize: 13.sp, color: AppThemes.colorWhite),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    language.cashBackInfoMessage,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText2!.copyWith(
                        fontSize: 10.sp,
                        color: AppThemes.colorTextLight,
                        fontFamily: AppConstants.fontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: AppThemes.colorWhite,
                          fontSize: 12.sp,
                          fontFamily: AppConstants.fontFamily,
                          fontWeight: FontWeight.w400),
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
            ],
          ),
        ),
      ),
    );
  }
}
