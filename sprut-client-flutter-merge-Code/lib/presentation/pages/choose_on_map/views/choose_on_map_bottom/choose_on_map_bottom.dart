import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/configs/responsive/responsive.dart';

class ChooseOnMapBottomView extends GetView<ChooseOnMapController> {
  final HomeViewController homeScreenController = Get.put(HomeViewController());
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return GetBuilder<ChooseOnMapController>(builder: (_) {
      return AnimatedContainer(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        height: MediaQuery.of(context).size.height *
            (controller.isBottomSheetExpanded ? 1 : 0.210),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(0),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 9,
                      ),

                      SizedBox(
                        height: 6,
                      ),
                      controller.isBottomSheetExpanded
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedOpacity(
                                opacity:
                                    controller.closeButtonVisible ? 1.0 : 0.0,
                                duration: Duration(seconds: 1),
                                child: Container(
                                    child: InkWell(
                                  onTap: () {
                                    // collapseSheet();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7)),
                                      color: colorScheme.primary,
                                    ),
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                  ),
                                )),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      // Divider(
                      //   color: Colors.grey.shade600,
                      //   // height: 20,
                      //   endIndent: 130,
                      //   indent: 130,
                      //   thickness: 4,
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          AssetsPath.location,
                                          height: 5.h,
                                          width: 4.w,
                                        ),
                                        // Container(
                                        //     width: 1,
                                        //     height: 3.h,
                                        //     color: Color(0xffEADB57)),
                                        // SizedBox(height: 3),
                                        // Icon(
                                        //   Icons.arrow_forward,
                                        //   color: colorScheme.primary,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          TextField(
                                            cursorColor: colorScheme.primary,
                                            // key: UniqueKey(),
                                            // onTap: () {
                                            //   value.expandSheet();
                                            // },

                                            onTap: () {
                                              controller.lastFocus =
                                                  "whereToArrive";
                                              controller.update();

                                              if (controller.whereToGoTapCount >
                                                  1) {
                                                // lastFocus = "whereToArrive";
                                                // updateSuggestions();
                                                if (controller
                                                    .wheretoGoController
                                                    .text
                                                    .isNotEmpty) {
                                                  if (controller
                                                          .whereToAriveEdtingController
                                                          .text !=
                                                      controller.cache[
                                                          "whereToGoControllerText"]) {}
                                                }
                                              }

                                              controller.update();
                                            },

                                            controller: controller
                                                .whereToAriveEdtingController,
                                            readOnly: !controller
                                                .isBottomSheetExpanded,
                                            onSubmitted: (v) {
                                              if (controller
                                                      .whereToAriveEdtingController
                                                      .text
                                                      .isNotEmpty &&
                                                  controller
                                                          .whereToAriveEdtingController
                                                          .text !=
                                                      controller.cache[
                                                          'whereToArriveControllerText']) {
                                                return;
                                              }
                                              if (controller
                                                          .whereToAriveEdtingController
                                                          .text ==
                                                      controller.cache[
                                                          'whereToArriveControllerText'] &&
                                                  controller.destinationAddress
                                                          .name !=
                                                      null &&
                                                  controller
                                                      .whereToAriveEdtingController
                                                      .text
                                                      .isNotEmpty) {
                                                return;
                                              }
                                            },
                                            style: textTheme.bodyText1!
                                                .copyWith(
                                                    fontSize: 10.sp,
                                                    color: AppThemes.dark),
                                            focusNode: controller
                                                .whereToAriveFocusNode,
                                            onChanged: (text) {
                                              if (text.isEmpty) {
                                                controller.suggestions = [];
                                                controller.update();
                                                return;
                                              }
                                              // updateControllerCache();
                                            },
                                            textInputAction: controller
                                                    .wheretoGoController
                                                    .text
                                                    .isEmpty
                                                ? TextInputAction.next
                                                : TextInputAction.done,
                                            decoration: InputDecoration(
                                              suffixIcon: controller
                                                      .isMainMapScreen
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        HomeViewController
                                                            homeViewController =
                                                            Get.put(
                                                                HomeViewController());
                                                        log(homeViewController
                                                            .lastFocus);
                                                        homeViewController
                                                            .suggestions = [];
                                                        homeViewController
                                                            .update();
                                                        homeViewController
                                                            .updateSearchTerm(
                                                                "");
                                                        homeViewController
                                                            .updateSuggestions();
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () {
                                                          homeViewController
                                                              .updateSuggestions();
                                                        });
                                                        homeViewController
                                                            .update();
                                                        if (controller
                                                            .isMainMapScreen) {
                                                          if (homeViewController
                                                                  .lastFocus ==
                                                              "whereToGo") {
                                                            homeViewController
                                                                    .wheretoGoController
                                                                    .text =
                                                                controller
                                                                    .whereToAriveEdtingController
                                                                    .text;
                                                          } else if (homeViewController
                                                                  .lastFocus ==
                                                              "whereToArrive") {
                                                            homeViewController
                                                                    .whereToAriveEdtingController
                                                                    .text =
                                                                controller
                                                                    .whereToAriveEdtingController
                                                                    .text;
                                                          }

                                                          controller
                                                                  .isMainMapScreen =
                                                              false;
                                                          Get.back();
                                                          return;
                                                        }

                                                        if (controller
                                                            .isHomeAddressScreen) {
                                                          controller
                                                                  .addHomeAddressEditingController
                                                                  .text =
                                                              controller
                                                                  .whereToAriveEdtingController
                                                                  .text;
                                                        } else if (controller
                                                            .isWorkAddressScreen) {
                                                          controller
                                                                  .addWorkAddressEditingController
                                                                  .text =
                                                              controller
                                                                  .whereToAriveEdtingController
                                                                  .text;
                                                        }
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        width: 45,
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                              labelStyle: textTheme.bodyText2!
                                                  .copyWith(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontSize: 9.sp,
                                                      letterSpacing: 0.50,
                                                      color: colorScheme
                                                          .secondary),
                                              isDense: true,
                                              border: InputBorder.none,
                                              labelText:
                                                  "Is this address appropriate?",
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 8, top: 5, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: PrimaryElevatedBtn(
                                  height: Responsive.isSmallMobile(context)
                                      ? 50.0
                                      : 60.0,
                                  buttonText: "Confirm",
                                  onPressed: () {

                                    
                                    HomeViewController homeViewController =
                                        Get.put(HomeViewController());
                                    log(homeViewController.lastFocus);
                                    homeViewController.suggestions = [];
                                    homeViewController.update();
                                    homeViewController.updateSearchTerm("");
                                    homeViewController.updateSuggestions();
                                    Future.delayed(Duration(seconds: 1), () {
                                      homeViewController.updateSuggestions();
                                    });
                                    homeViewController.update();
                                    if (controller.isMainMapScreen) {
                                      if (homeViewController.lastFocus ==
                                          "whereToGo") {
                                        homeViewController
                                                .wheretoGoController.text =
                                            controller
                                                .whereToAriveEdtingController
                                                .text;
                                      } else if (homeViewController.lastFocus ==
                                          "whereToArrive") {
                                        homeViewController
                                                .whereToAriveEdtingController
                                                .text =
                                            controller
                                                .whereToAriveEdtingController
                                                .text;
                                      }

                                      controller.isMainMapScreen = false;
                                      Get.back();
                                      return;
                                    }

                                    if (controller.isHomeAddressScreen) {
                                      controller.addHomeAddressEditingController
                                              .text =
                                          controller
                                              .whereToAriveEdtingController
                                              .text;
                                    } else if (controller.isWorkAddressScreen) {
                                      controller.addWorkAddressEditingController
                                              .text =
                                          controller
                                              .whereToAriveEdtingController
                                              .text;
                                    }
                                    Get.back();
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              !controller.isBottomSheetExpanded
                  ? Container()
                  : Positioned(
                      bottom: 10,
                      left: 7,
                      right: 7,
                      child: PrimaryElevatedBtn(
                          widget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(AssetsPath.locatorWhite, height: 2.h),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Choose on map",
                                  style: textTheme.bodyText2!.copyWith(
                                      color: colorScheme.background,
                                      fontSize: 11.sp)),
                            ],
                          ),
                          isHomeScreen: true,
                          fontSize: 12.sp,
                          buttonText: "",
                          onPressed: () {})),
            ],
          ),
        ),
      );
    });
  }
}
