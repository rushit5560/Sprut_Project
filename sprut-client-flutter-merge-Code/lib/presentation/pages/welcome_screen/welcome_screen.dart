import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import '../../../resources/app_constants/app_constants.dart';
import '../../../resources/app_themes/app_themes.dart';
import '../../../resources/assets_path/assets_path.dart';
import '../../../resources/configs/service_locator/service_locator.dart';
import '../../../resources/services/database/database.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>{

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  String _selectedType = '0';

  @override
  Widget build(BuildContext context) {
    if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP){
      Helpers.systemStatusBar();
    }else {
      Helpers.systemStatusBar1();
    }
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: SvgPicture.asset(
                            AssetsPath.welcomeScreen,
                          ),
                          margin: EdgeInsets.only(top: 10.h, bottom: 20),
                        ),
                        Text(
                          language.welcome,
                          style: textTheme.headline2!.copyWith(
                              fontSize: 26.sp,
                              color: Helpers.primaryTextColor()),
                        ),
                        Text(
                          "SPRUT",
                          style: textTheme.headline2!.copyWith(
                              fontSize: 25.sp, color: colorScheme.primary),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(language.welcomeHeadline,
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 10.sp,
                                  color: Helpers.secondaryTextColor())),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 32.0, bottom: 23.0),
                          child: Text(
                            "${language.welcome_screen_message}",
                            style: textTheme.headline2!.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Helpers.secondaryTextColor()),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
                            databaseService.saveToDisk(DatabaseKeys.isLoginTypeSelected, AppConstants.TAXI_APP);
                            if(mounted) {
                              setState(() {
                                _selectedType = "0";
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 24.0, right: 24.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(
                                    width: 1, color: AppThemes.lightLineColor),
                                color: Helpers.primaryBackgroundColor(colorScheme)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      activeColor: colorScheme.primary,
                                      fillColor: MaterialStateColor.resolveWith((states) => states == MaterialState.selected ? colorScheme.primary : colorScheme.primary),
                                      groupValue: _selectedType,
                                      value: "0",
                                      onChanged: (value) {
                                        // print("Change Value!!!!");
                                        databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
                                        databaseService.saveToDisk(DatabaseKeys.isLoginTypeSelected, AppConstants.TAXI_APP);
                                        if(mounted) {
                                          setState(() {
                                            _selectedType = value.toString();
                                          });
                                        }
                                      },
                                    ),
                                    SvgPicture.asset(
                                      AssetsPath.taxiSmallIcon,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 8.0),
                                      child: Text(
                                        "${language.txt_taxi}",
                                        style: TextStyle(
                                            color: Helpers.primaryTextColor(),
                                            fontFamily:
                                            AppConstants.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        if(Helpers.getSubmitCity() == "Vinnytsia")...[
                          GestureDetector(
                            onTap: () async {
                              databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
                              databaseService.saveToDisk(DatabaseKeys.isLoginTypeSelected, AppConstants.FOOD_APP);
                              if(mounted) {
                                setState(() {
                                  _selectedType = "1";
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  border: Border.all(
                                      width: 1, color: AppThemes.lightLineColor),
                                  color: Helpers.primaryBackgroundColor(colorScheme)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                        activeColor: colorScheme.primary,
                                        fillColor: MaterialStateColor.resolveWith((states) => states == MaterialState.selected ? colorScheme.primary : colorScheme.primary),
                                        groupValue: _selectedType,
                                        value: "1",
                                        onChanged: (value) {
                                          // print("Change Value ----->");
                                          databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
                                          databaseService.saveToDisk(DatabaseKeys.isLoginTypeSelected, AppConstants.FOOD_APP);
                                          if(mounted) {
                                            setState(() {
                                              _selectedType = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                      SvgPicture.asset(
                                        AssetsPath.taxiSmallIcon,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 8.0),
                                        child: Text(
                                          "${language.txt_delivery}",
                                          style: TextStyle(
                                              color: Helpers.primaryTextColor(),
                                              fontFamily:
                                              AppConstants.fontFamily,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: PrimaryElevatedBtn(
                        buttonText: language.getStarted,
                        onPressed: () {
                          debugPrint("_selectedType :: $_selectedType");
                          if(_selectedType == "0"){
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.homeScreen, (route) => false);
                          }else if(_selectedType == "1"){
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.foodHomeScreen, (route) => false);
                          }
                          // Helpers.getLocation();
                          //  Get.put(HomeViewController());

                        }),
                  )
                ]),
          ),
        ),
        backgroundColor: Helpers.primaryBackgroundColor(colorScheme));
  }

}



/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          language.welcome,
                          style: textTheme.headline2!.copyWith(fontSize: 24.sp),
                        ),
                        Text(
                          "SPRUT",
                          style: textTheme.headline2!.copyWith(
                              fontSize: 25.sp, color: colorScheme.primary),
                        ),
                        Text(language.welcomeHeadline,
                            style: textTheme.bodyText1!.copyWith(
                                fontSize: 10.sp, color: colorScheme.secondary)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: PrimaryElevatedBtn(
                        buttonText: language.getStarted,
                        onPressed: () {
                          // Helpers.getLocation();
                          //  Get.put(HomeViewController());
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.homeScreen, (route) => false);
                        }),
                  )
                ]),
          ),
        ),
        backgroundColor: colorScheme.background);
  }
}
*/
