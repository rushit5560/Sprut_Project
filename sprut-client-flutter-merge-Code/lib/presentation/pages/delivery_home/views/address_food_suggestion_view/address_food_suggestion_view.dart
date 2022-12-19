import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/address_food_suggestion_controller.dart';

class AddressFoodSuggestionView extends GetView<AddressFoodSuggestionController> {
  final bool isHomeAddressScreen, isWorkAddressScreen, isOtherAddressScreen;

  AddressFoodSuggestionView(
      {this.isHomeAddressScreen = false,
      this.isWorkAddressScreen = false,
      this.isOtherAddressScreen = false});

  // HomeViewController homeViewController =
  // Get.put(HomeViewController(), permanent: true);


  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<AddressFoodSuggestionController>(
        builder: (_) => FutureBuilder(
            future: controller.osmFoodSuggestionsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                controller.suggestions = [];
              }

              {
                return NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      // FocusScope.of(context).unfocus();

                      /// your code
                    }

                    // FocusScope.of(context).unfocus();
                    log("postion");

                    //How many pixels scrolled from pervious frame
                    print(notification.scrollDelta);

                    //List scroll position
                    print(notification.metrics.pixels);
                    return true;
                  },
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // color: Colors.blue,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                            // height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.only(bottom: controller.recentlyAddedList.isNotEmpty ? 0 : 20),
                            child: GestureDetector(
                              onTap: () {
                                // FocusScope.of(context).unfocus();
                              },
                              child: NotificationListener<
                                  ScrollUpdateNotification>(
                                child: Scrollbar(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics: NeverScrollableScrollPhysics(),
                                    // keyboardDismissBehavior:
                                    //     ScrollViewKeyboardDismissBehavior
                                    //         .onDrag,
                                    itemCount: controller.suggestions.length + 3 + controller.lastThreeAddresses.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: Colors.green,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              isHomeAddressScreen == false ||
                                                  isWorkAddressScreen ==
                                                      false
                                                  ? GestureDetector(
                                                behavior: HitTestBehavior
                                                    .translucent,
                                                onTap: () {
                                                  //check GPS enable
                                                  controller.onFoodMyLocationTap(context);
                                                  // if(homeViewController.serviceEnabled){
                                                  //   controller.onFoodMyLocationTap(context);
                                                  // }else {
                                                  //   homeViewController.getLocationState();
                                                  // }
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        AssetsPath
                                                            .locationWhite,
                                                        height: 2.5.h),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(" ${language.myLocation}",
                                                              style: textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                  fontSize:
                                                                  10.sp,
                                                                  color: AppThemes.colorWhite)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                                  : SizedBox(),
                                              isHomeAddressScreen == false ||
                                                  isWorkAddressScreen ==
                                                      false
                                                  ? controller.divider(context)
                                                  : SizedBox(),
                                            ],
                                          ),
                                        );
                                        // if((homeViewController
                                        //     .getLocationState() ==
                                        //     locationState
                                        //         .NoPermission_NoService) ||
                                        //     (homeViewController.getLocationState() ==
                                        //         locationState
                                        //             .NoPermission_Service) ||
                                        //     (homeViewController.getLocationState() ==
                                        //         locationState
                                        //             .Permission_NoService)){
                                        //   return Container();
                                        // }else {
                                        //   return Container(
                                        //     alignment: Alignment.center,
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 8, vertical: 4),
                                        //     margin: EdgeInsets.only(
                                        //       left: 20,
                                        //       right: 20,
                                        //       bottom: 0,
                                        //     ),
                                        //     decoration: BoxDecoration(
                                        //       // color: Colors.green,
                                        //     ),
                                        //     child: Column(
                                        //       crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //       children: [
                                        //         isHomeAddressScreen == false ||
                                        //             isWorkAddressScreen ==
                                        //                 false
                                        //             ? GestureDetector(
                                        //           behavior: HitTestBehavior
                                        //               .translucent,
                                        //           onTap: () {
                                        //             //check GPS enable
                                        //             if(homeViewController.serviceEnabled){
                                        //               controller.onFoodMyLocationTap(context);
                                        //             }else {
                                        //               homeViewController.getLocationState();
                                        //             }
                                        //           },
                                        //           child: Row(
                                        //             children: [
                                        //               Image.asset(
                                        //                   AssetsPath
                                        //                       .locationWhite,
                                        //                   height: 2.5.h),
                                        //               Padding(
                                        //                 padding:
                                        //                 const EdgeInsets
                                        //                     .all(8.0),
                                        //                 child: Column(
                                        //                   crossAxisAlignment:
                                        //                   CrossAxisAlignment
                                        //                       .start,
                                        //                   children: [
                                        //                     Text(" ${language.myLocation}",
                                        //                         style: textTheme
                                        //                             .bodyText1!
                                        //                             .copyWith(
                                        //                             fontSize:
                                        //                             10.sp,
                                        //                             color: AppThemes.colorWhite)),
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         )
                                        //             : SizedBox(),
                                        //         isHomeAddressScreen == false ||
                                        //             isWorkAddressScreen ==
                                        //                 false
                                        //             ? controller.divider(context)
                                        //             : SizedBox(),
                                        //       ],
                                        //     ),
                                        //   );
                                        // }
                                      }

                                      if (index == 1) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userHomeAddress) ==
                                                          "" ||
                                                      controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userHomeAddress) ==
                                                          null
                                                  ? SizedBox()
                                                  : ((isHomeAddressScreen ==
                                                                  false ||
                                                              isWorkAddressScreen ==
                                                                  false) &&
                                                          ((controller.isHomeSuggestion &&
                                                                  controller
                                                                          .suggestions
                                                                          .length >
                                                                      0) ||
                                                              controller
                                                                      .suggestions
                                                                      .length ==
                                                                  0))
                                                      ? GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: () {
                                                            print('herehome');
                                                            SuggestionItem item = SuggestionItem(
                                                                lon: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .homeAddressLongitude),
                                                                lat: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .homeAddressLatitude),
                                                                name: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .userHomeAddress));

                                                            controller
                                                                .onSuggestionTap(
                                                                    item,
                                                                    isOtherAddressScreen);

                                                            if (controller
                                                                .lastFocus ==
                                                                "whereToDeliver") {
                                                              FocusScope.of(
                                                                  context)
                                                                  .requestFocus(
                                                                  controller
                                                                      .wheretoDeliverFocusNode);
                                                              controller
                                                                  .lastFocus =
                                                              "whereToDeliver";
                                                              //set index course
                                                              }

                                                            // if (controller
                                                            //     .lastFocus ==
                                                            //     "whereToBuildingAddress") {
                                                            //   FocusScope.of(
                                                            //       context)
                                                            //       .requestFocus(
                                                            //       controller
                                                            //           .wheretoDeliverFocusNode);
                                                            //   controller
                                                            //       .lastFocus =
                                                            //   "whereToDeliver";
                                                            // }

                                                            // if (controller
                                                            //         .lastFocus ==
                                                            //     "whereToBuildingAddress") {
                                                            //   FocusScope.of(
                                                            //           context)
                                                            //       .requestFocus(
                                                            //           controller.wheretoDeliverFocusNode);
                                                            //   controller
                                                            //           .lastFocus =
                                                            //       "whereToDeliver";
                                                            // } else if (controller
                                                            //         .lastFocus ==
                                                            //     "whereToDeliver") {
                                                            //   FocusScope.of(
                                                            //           context)
                                                            //       .requestFocus(
                                                            //           controller
                                                            //               .wheretoDeliverFocusNode);//NEED CHANGE
                                                            //
                                                            //   // controller
                                                            //   //         .lastFocus =
                                                            //   //     "whereToBuildingAddress";
                                                            //
                                                            //   controller
                                                            //           .lastFocus =
                                                            //       "whereToDeliver";
                                                            // }
                                                            controller.saveButtonStatusChange(true);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AssetsPath
                                                                    .homeAddressWhite,
                                                                height: 2.2.h,
                                                              ),
                                                              SizedBox(
                                                                width: 3.5,
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          9.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          language
                                                                              .home,
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 10.sp,
                                                                              color: AppThemes.colorWhite)),
                                                                      Text(
                                                                          "${controller.databaseService.getFromDisk(DatabaseKeys.userHomeAddress) ?? ""}",
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 8.sp,
                                                                              color: AppThemes.colorSearchViewTextLight))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                              controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userHomeAddress) ==
                                                          "" ||
                                                      controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userHomeAddress) ==
                                                          null
                                                  ? SizedBox()
                                                  : ((isHomeAddressScreen ==
                                                                  false ||
                                                              isWorkAddressScreen ==
                                                                  false) &&
                                                          ((controller.isHomeSuggestion &&
                                                                  controller
                                                                          .suggestions
                                                                          .length >
                                                                      0) ||
                                                              controller
                                                                      .suggestions
                                                                      .length ==
                                                                  0))
                                                      ? controller
                                                          .divider(context)
                                                      : SizedBox(),
                                            ],
                                          ),
                                        );
                                      }

                                      if (index == (controller.suggestions.length + 2)) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            // color: Colors.yellowAccent
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userWorkAddress) ==
                                                          "" ||
                                                      controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userWorkAddress) ==
                                                          null
                                                  ? SizedBox()
                                                  : ((isHomeAddressScreen ==
                                                                  false ||
                                                              isWorkAddressScreen ==
                                                                  false) &&
                                                          ((controller.isWorkSuggestion &&
                                                                  controller
                                                                          .suggestions
                                                                          .length >
                                                                      0) ||
                                                              controller
                                                                      .suggestions
                                                                      .length ==
                                                                  0))
                                                      ? GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: () {
                                                            print(
                                                                'here work tap expand');
                                                            SuggestionItem item = SuggestionItem(
                                                                lon: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .workAddressLongitude),
                                                                lat: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .workAddressLatitude),
                                                                name: controller
                                                                    .databaseService
                                                                    .getFromDisk(
                                                                        DatabaseKeys
                                                                            .userWorkAddress));

                                                            controller
                                                                .onSuggestionTap(
                                                                    item,
                                                                    isOtherAddressScreen);
                                                            if (controller
                                                                .lastFocus ==
                                                                "whereToDeliver") {
                                                              FocusScope.of(
                                                                  context)
                                                                  .requestFocus(
                                                                  controller
                                                                      .wheretoDeliverFocusNode);
                                                              controller
                                                                  .lastFocus =
                                                              "whereToDeliver";
                                                            }
                                                            // if (controller
                                                            //     .lastFocus ==
                                                            //     "whereToBuildingAddress") {
                                                            //   FocusScope.of(
                                                            //       context)
                                                            //       .requestFocus(
                                                            //       controller
                                                            //           .wheretoDeliverFocusNode);
                                                            //   controller
                                                            //       .lastFocus =
                                                            //   "whereToDeliver";
                                                            // }

                                                            // if (controller
                                                            //         .lastFocus ==
                                                            //     "whereToBuildingAddress") {
                                                            //   FocusScope.of(
                                                            //           context)
                                                            //       .requestFocus(
                                                            //           controller
                                                            //               .wheretoDeliverFocusNode);
                                                            //   controller
                                                            //           .lastFocus =
                                                            //       "whereToDeliver";
                                                            // } else if (controller
                                                            //         .lastFocus ==
                                                            //     "whereToDeliver") {
                                                            //   FocusScope.of(
                                                            //           context)
                                                            //       .requestFocus(
                                                            //           controller.wheretoDeliverFocusNode);//NEED CHANGE
                                                            //
                                                            //   // controller
                                                            //   //         .lastFocus =
                                                            //   //     "whereToBuildingAddress";
                                                            //
                                                            //   controller
                                                            //           .lastFocus =
                                                            //       "whereToDeliver";
                                                            // }

                                                            controller.saveButtonStatusChange(true);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AssetsPath
                                                                    .workAddressWhite,
                                                                height: 2.2.h,
                                                              ),
                                                              SizedBox(
                                                                width: 3.5,
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          language
                                                                              .work,
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 10.sp,
                                                                              color: AppThemes.colorWhite)),
                                                                      Text(
                                                                          controller.databaseService.getFromDisk(DatabaseKeys.userWorkAddress) ??
                                                                              "",
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 8.sp,
                                                                              color: AppThemes.colorSearchViewTextLight))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox(),
                                              controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userWorkAddress) ==
                                                          "" ||
                                                      controller.databaseService
                                                              .getFromDisk(
                                                                  DatabaseKeys
                                                                      .userWorkAddress) ==
                                                          null
                                                  ? SizedBox()
                                                  : ((isHomeAddressScreen ==
                                                                  false ||
                                                              isWorkAddressScreen ==
                                                                  false) &&
                                                          ((controller.isWorkSuggestion &&
                                                                  controller
                                                                          .suggestions
                                                                          .length >
                                                                      0) ||
                                                              controller
                                                                      .suggestions
                                                                      .length ==
                                                                  0))
                                                      ? controller
                                                          .divider(context)
                                                      : SizedBox(),
                                              // const SizedBox(
                                              //   height: 20,
                                              // ),
                                              //required remove box
                                            ],
                                          ),
                                        );
                                      }

                                      if (index >= 2 && index < (controller.suggestions.length + 2)) {
                                        return GestureDetector(
                                          onTap: () {
                                            // FocusScope.of(context).unfocus();
                                            controller.onSuggestionTap(
                                                controller
                                                    .suggestions[index - 2],
                                                isOtherAddressScreen);

                                            if (controller
                                                .lastFocus ==
                                                "whereToDeliver") {
                                              FocusScope.of(
                                                  context)
                                                  .requestFocus(
                                                  controller
                                                      .wheretoDeliverFocusNode);
                                              controller
                                                  .lastFocus =
                                              "whereToDeliver";
                                            }

                                            // if (controller
                                            //     .lastFocus ==
                                            //     "whereToBuildingAddress") {
                                            //   FocusScope.of(
                                            //       context)
                                            //       .requestFocus(
                                            //       controller
                                            //           .wheretoDeliverFocusNode);
                                            //   controller
                                            //       .lastFocus =
                                            //   "whereToDeliver";
                                            // }

                                            // if (controller.lastFocus ==
                                            //     "whereToBuildingAddress") {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(controller
                                            //           .wheretoDeliverFocusNode);
                                            //   controller.lastFocus =
                                            //       "whereToDeliver";
                                            // } else if (controller.lastFocus ==
                                            //     "whereToDeliver") {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(controller
                                            //           .wheretoDeliverFocusNode);//NEED CHANGE
                                            //
                                            //   controller.lastFocus =
                                            //       "whereToBuildingAddress";
                                            // }
                                            controller.saveButtonStatusChange(true);
                                            controller.suggestions = [];
                                            controller.update();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey[400]!,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      AssetsPath.location,
                                                      height: 2.5.h,
                                                      color:
                                                          AppThemes.colorWhite,
                                                      // color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 11,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Text(
                                                        // suggestions[index - 1].displayName,
                                                        "${controller.filterSuggesstionName(controller.suggestions[index - 2])}",
                                                        style: textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontSize: 10.sp,
                                                                color: AppThemes
                                                                    .colorWhite),

                                                        // overflow: TextOverflow.,
                                                        maxLines: 2,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      print('here suggestion');
                                      return SizedBox(height: 0,);
                                    },
                                  ),
                                ),
                                onNotification: (notification) {
                                  if (notification is ScrollStartNotification) {
                                    FocusScope.of(context).unfocus();

                                    /// your code
                                  }

                                  FocusScope.of(context).unfocus();
                                  log("postion");

                                  //How many pixels scrolled from pervious frame
                                  print(notification.scrollDelta);

                                  //List scroll position
                                  print(notification.metrics.pixels);
                                  return true;
                                },
                              ),
                            ),
                          ),
                          ///recently search list
                          if(controller.recentlyAddedList.isNotEmpty)...[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              // height: MediaQuery.of(context).size.height,
                              padding: EdgeInsets.only(bottom: 20),
                              color: Colors.transparent,
                              child: NotificationListener<ScrollUpdateNotification>(
                                child: Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.recentlyAddedList.length,
                                      itemBuilder: (BuildContext context, int index){
                                        return GestureDetector(
                                          onTap: () {
                                            // FocusScope.of(context).unfocus();
                                            controller.onSuggestionTap(
                                                controller
                                                    .recentlyAddedList[index],
                                                isOtherAddressScreen);

                                            if (controller
                                                .lastFocus ==
                                                "whereToDeliver") {
                                              FocusScope.of(
                                                  context)
                                                  .requestFocus(
                                                  controller
                                                      .wheretoDeliverFocusNode);
                                              controller
                                                  .lastFocus =
                                              "whereToDeliver";
                                            }

                                            // if (controller
                                            //     .lastFocus ==
                                            //     "whereToBuildingAddress") {
                                            //   FocusScope.of(
                                            //       context)
                                            //       .requestFocus(
                                            //       controller
                                            //           .wheretoDeliverFocusNode);
                                            //   controller
                                            //       .lastFocus =
                                            //   "whereToDeliver";
                                            // }

                                            // if (controller.lastFocus ==
                                            //     "whereToBuildingAddress") {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(controller
                                            //       .wheretoDeliverFocusNode);
                                            //   controller.lastFocus =
                                            //   "whereToDeliver";
                                            // } else if (controller.lastFocus ==
                                            //     "whereToDeliver") {
                                            //   FocusScope.of(context)
                                            //       .requestFocus(controller
                                            //       .wheretoDeliverFocusNode);//NEED CHANGE
                                            //
                                            //   controller.lastFocus =
                                            //   "whereToBuildingAddress";
                                            // }
                                            controller.saveButtonStatusChange(true);
                                            controller.update();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              bottom: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey[400]!,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AssetsPath
                                                          .recentlySearchWhite,
                                                      height: 2.2.h,
                                                    ),
                                                    SizedBox(
                                                      width: 11,
                                                    ),
                                                    Container(
                                                      width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.7,
                                                      child: Text(
                                                        // suggestions[index - 1].displayName,
                                                        "${controller.filterSuggesstionName(controller.recentlyAddedList[index])}",
                                                        style: textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                            fontSize: 10.sp,
                                                            color: AppThemes
                                                                .colorWhite),

                                                        // overflow: TextOverflow.,
                                                        maxLines: 2,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            )
                          ]
                        ]),
                  ),
                );
              }
            }));

  }

}
