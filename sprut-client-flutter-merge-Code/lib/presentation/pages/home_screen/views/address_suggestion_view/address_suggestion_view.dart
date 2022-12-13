import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../no_internet/no_internet.dart';

class AddressSuggestionView extends GetView<HomeViewController> {
  final bool isHomeAddressScreen, isWorkAddressScreen, isOtherAddressScreen;
  AddressSuggestionView(
      {this.isHomeAddressScreen = false,
      this.isWorkAddressScreen = false,
      this.isOtherAddressScreen = false});

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ConnectedBloc, ConnectedState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, connectionState) {
    if (connectionState is ConnectedFailureState) {

      return NoInternetScreen(onPressed: () async {});
    }

    if (connectionState is ConnectedSucessState) {}

    return GetBuilder<HomeViewController>(
        builder: (_) => FutureBuilder(
            future: controller.osmSuggestionsFuture,
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
                    // keyboardDismissBehavior:
                    //     ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // color: Colors.blue,
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.only(bottom: 20),
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
                                    itemCount: controller.suggestions.length +
                                        3 +
                                        controller.lastThreeAddresses.length,
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
                                          decoration: BoxDecoration(),
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
                                                                "whereToGo") {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      controller
                                                                          .whereToAriveFocusNode);
                                                              controller
                                                                      .lastFocus =
                                                                  "whereToArrive";
                                                            } else if (controller
                                                                    .lastFocus ==
                                                                "whereToArrive") {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      controller
                                                                          .wheretoGoFocusNode);

                                                              controller
                                                                      .lastFocus =
                                                                  "whereToGo";
                                                            }

                                                            if (controller
                                                                        .wheretoGoController
                                                                        .text ==
                                                                    controller
                                                                            .cache[
                                                                        'whereToGoControllerText'] &&
                                                                controller
                                                                        .arrivalAddress
                                                                        .name !=
                                                                    null &&
                                                                controller
                                                                    .wheretoGoController
                                                                    .text
                                                                    .isNotEmpty) {
                                                              controller
                                                                  .moveToTariff();
                                                              return;
                                                            }

                                                            log(controller
                                                                .lastFocus);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AssetsPath
                                                                    .homeIconBlack,
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
                                                                              color: AppThemes.dark)),
                                                                      Text(
                                                                          "${controller.databaseService.getFromDisk(DatabaseKeys.userHomeAddress) ?? ""}",
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 8.sp,
                                                                              color: colorScheme.secondaryContainer))
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

                                      if (index == 1) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(),
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
                                                            log(controller
                                                                .lastFocus);

                                                            if (controller
                                                                    .lastFocus ==
                                                                "whereToGo") {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      controller
                                                                          .whereToAriveFocusNode);
                                                              controller
                                                                      .lastFocus =
                                                                  "whereToArrive";
                                                            } else if (controller
                                                                    .lastFocus ==
                                                                "whereToArrive") {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      controller
                                                                          .wheretoGoFocusNode);

                                                              controller
                                                                      .lastFocus =
                                                                  "whereToGo";
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AssetsPath
                                                                    .workIconBlack,
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
                                                                              color: AppThemes.dark)),
                                                                      Text(
                                                                          controller.databaseService.getFromDisk(DatabaseKeys.userWorkAddress) ??
                                                                              "",
                                                                          style: textTheme.bodyText1!.copyWith(
                                                                              fontSize: 8.sp,
                                                                              color: colorScheme.secondaryContainer))
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
                                            ],
                                          ),
                                        );
                                      }

                                      if (index ==
                                          (controller.suggestions.length + 2)) {
                                        return Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 0,
                                          ),
                                          decoration: BoxDecoration(),
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
                                                        controller
                                                            .onMyLocationTap(
                                                                context);

                                                        // Future.delayed(
                                                        //     const Duration(
                                                        //         milliseconds:
                                                        //             1000), () {
                                                        // if (controller
                                                        //         .lastFocus ==
                                                        //     "whereToGo") {
                                                        //   FocusScope.of(
                                                        //           context)
                                                        //       .requestFocus(
                                                        //           controller
                                                        //               .whereToAriveFocusNode);
                                                        //   controller
                                                        //           .lastFocus =
                                                        //       "whereToArrive";
                                                        // } else if (controller
                                                        //         .lastFocus ==
                                                        //     "whereToArrive") {
                                                        //   FocusScope.of(
                                                        //           context)
                                                        //       .requestFocus(
                                                        //           controller
                                                        //               .wheretoGoFocusNode);

                                                        //   controller
                                                        //           .lastFocus =
                                                        //       "whereToGo";
                                                        // }
                                                        // });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                              AssetsPath
                                                                  .locator,
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
                                                                Text(
                                                                    " ${language.myLocation}",
                                                                    style: textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                10.sp,
                                                                            color: AppThemes.dark)),
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
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      if (index >= 2 &&
                                          index <
                                              (controller.suggestions.length +
                                                  2)) {
                                        return GestureDetector(
                                          onTap: () {
                                            // FocusScope.of(context).unfocus();
                                            controller.onSuggestionTap(
                                                controller
                                                    .suggestions[index - 2],
                                                isOtherAddressScreen);

                                            if (controller.lastFocus ==
                                                "whereToGo") {
                                              FocusScope.of(context)
                                                  .requestFocus(controller
                                                      .whereToAriveFocusNode);
                                              controller.lastFocus =
                                                  "whereToArrive";
                                            } else if (controller.lastFocus ==
                                                "whereToArrive") {
                                              FocusScope.of(context)
                                                  .requestFocus(controller
                                                      .wheretoGoFocusNode);

                                              controller.lastFocus =
                                                  "whereToGo";
                                            }
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
                                                      height: 3.h,
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
                                                                    .dark),

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
                                      return Container();
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
                        ]),
                  ),
                );
              }
            }));
  },
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
