import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationStatusBar extends GetView<HomeViewController> {
  /// Location status bar using on [Main Map Screen]

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    
    return Obx(() {
      if (controller.getLocationState() == locationState.Uknown) {
        return Container();
      }

      log(controller.getLocationState().toString());
      if (controller.getLocationState() == locationState.Permission_Service) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (controller.locationData == null) {
                    Helpers.showCircularProgressDialog(context: context);
                    await controller.fetchUserLocation();
                    Navigator.pop(context);

                    // gMapController.animateCamera(cameraUpdate)
                    await controller.updateCurrentLocationMarker();
                    controller.animateToCurrent();
                  } else {
                    await controller.updateCurrentLocationMarker();
                    // ProgressLoader().dismiss();
                    controller.animateToCurrent();
                  }
                },
                child: Container(

                    // margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Image.asset(
                      "assets/images/gps.png",
                      height: 2.5.h,
                    )),
              )
            ],
          ),
        );
      }
      if ((controller.getLocationState() ==
              locationState.NoPermission_NoService) ||
          (controller.getLocationState() ==
              locationState.NoPermission_Service) ||
          (controller.getLocationState() ==
              locationState.Permission_NoService)) {
        var colorScheme = Theme.of(context).colorScheme;
        var textTheme = Theme.of(context).textTheme;

        return Container(
          // color: Colors.blue,
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 7, left: 10, right: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xfff5f5f5),
                ),
                child: Text(
                  "Turn on GPS for automatic determination of your location",
                  style: textTheme.bodyText1!
                      .copyWith(color: AppThemes.dark, fontSize: 10.sp),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await controller.fetchUserLocation();
                },
                child: Container(
                    width: 16.w,
                    height: 7.5.h,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          AssetsPath.powerSvg,
                          height: 3.h,
                        ),
                      ],
                    )),
              )
            ],
          ),
        );
      }
      return Container();
    });
  }
}
