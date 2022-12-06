import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/home_screen/views/add_addresses_views/add_home_address_view.dart';
import 'package:sprut/presentation/pages/home_screen/views/add_addresses_views/add_work_address_view.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../resources/configs/routes/routes.dart';
import '../../../order_history/controllers/order_history_controller.dart';

class BottomSheetOptions extends GetView<HomeViewController> {
  ChooseOnMapController chooseOnMapController =
      Get.put(ChooseOnMapController());
  OrderHistoryController orderViewController =
      Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(left: 8, top: 5, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              if (!chooseOnMapController.isBottomSheetExpanded) {
                chooseOnMapController.isHomeAddressScreen = true;
                chooseOnMapController.isWorkAddressScreen = false;

                // chooseOnMapController.addHomeAddressEditingController.text =
                //     controller.cacheAddress["homeAddress"];

                showDialog(
                    context: context, builder: (context) => AddHomeAddress());
              }
            },
            child: Container(
                padding: EdgeInsets.all(10),
                height: 7.2.h,
                alignment: Alignment.center,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 3,
                      child: SvgPicture.asset(
                        AssetsPath.homeSvg,
                        height: 2.5.h,
                      ),
                    ),
                    controller.databaseService.getFromDisk(
                                    DatabaseKeys.userHomeAddress) ==
                                "" ||
                            controller.databaseService.getFromDisk(
                                    DatabaseKeys.userHomeAddress) ==
                                null
                        ? Positioned(
                            right: 10,
                            top: 8,
                            child: _circleBubble(colorScheme),
                          )
                        : SizedBox(),
                    Positioned(
                      bottom: 0,
                      child: Text(language.home,
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 7.sp,
                              color: colorScheme.secondaryContainer)),
                    ),
                  ],
                )),
          ),
          GestureDetector(
            onTap: () async {
              if (!chooseOnMapController.isBottomSheetExpanded) {
                chooseOnMapController.isHomeAddressScreen = false;
                chooseOnMapController.isWorkAddressScreen = true;

                // chooseOnMapController.addWorkAddressEditingController.text =
                //     controller.cacheAddress["workAddress"];

                showDialog(
                    context: context, builder: (context) => AddWorkAddress());
              }
              // List addresses = await fetchTripAddresses();
              // print(addresses);
            },
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 12,
              // ),
              padding: EdgeInsets.all(10),
              height: 7.2.h,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white,
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 3,
                    child: SvgPicture.asset(
                      AssetsPath.workSvg,
                      height: 2.5.h,
                    ),
                  ),
                  controller.databaseService
                                  .getFromDisk(DatabaseKeys.userWorkAddress) ==
                              "" ||
                          controller.databaseService
                                  .getFromDisk(DatabaseKeys.userWorkAddress) ==
                              null
                      ? Positioned(
                          right: 6,
                          top: 8,
                          child: _circleBubble(colorScheme),
                        )
                      : SizedBox(),
                  Positioned(
                    bottom: 0,
                    child: Text(language.work,
                        style: textTheme.bodyText1!.copyWith(
                            fontSize: 7.sp,
                            color: colorScheme.secondaryContainer)),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              orderViewController.lastOrder = true;
              Get.toNamed(Routes.orderHistoryView);
            },
            child: Container(
              // margin: EdgeInsets.symmetric(
              //   horizontal: 12,
              // ),
              padding: EdgeInsets.all(15),
              height: 7.h,
              width: MediaQuery.of(context).size.width * 0.53,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetsPath.historySvg,
                    height: 2.5.h,
                  ),
                  SizedBox(width: 10),
                  Text(language.lastTrip,
                      style: textTheme.bodyText1!.copyWith(
                          fontSize: 10.sp,
                          color: colorScheme.secondaryContainer))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _circleBubble(ColorScheme colorScheme) {
    return Container(
        child: Center(
          child: Icon(
            Icons.add,
            color: colorScheme.background,
            size: 10,
          ),
        ),
        width: 11,
        height: 11,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppThemes.circleBubbleColor,
        ));
  }
}
