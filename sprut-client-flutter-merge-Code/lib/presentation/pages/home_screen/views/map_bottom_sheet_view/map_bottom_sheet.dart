import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/home_screen/views/address_suggestion_view/address_suggestion_view.dart';
import 'package:sprut/presentation/pages/home_screen/views/bottom_sheet_options/bottom_sheet_options.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapBottomSheetView extends GetView<HomeViewController> {
  const MapBottomSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return GetBuilder<HomeViewController>(builder: (controller) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: Container(
        //   margin: controller.whereToAriveFocusNode.hasFocus ||
        //           controller.wheretoGoFocusNode.hasFocus
        //       ? EdgeInsets.only(bottom: Platform.isIOS ? 35 : 17.5, left: 30)
        //       : EdgeInsets.only(bottom: Platform.isIOS ? 75 : 45, left: 30),
        //   child: PrimaryElevatedBtn(
        //       widget: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Image.asset(AssetsPath.locatorWhite, height: 2.h),
        //           SizedBox(
        //             width: 5,
        //           ),
        //           Text("Choose on map",
        //               style: textTheme.bodyText2!.copyWith(
        //                   color: colorScheme.background, fontSize: 11.sp)),
        //         ],
        //       ),
        //       isHomeScreen: true,
        //       fontSize: 12.sp,
        //       buttonText: "",
        //       onPressed: () {
        //         ChooseOnMapController chooseOnMapController =
        //             Get.put(ChooseOnMapController());

        //         if (controller.isWhereToAriveFieldTapped == true) {
        //           chooseOnMapController.whereToAriveEdtingController.text =
        //               controller.whereToAriveEdtingController.text;
        //         } else if (controller.isWhereToGoFieldTapped == true) {
        //           chooseOnMapController.wheretoGoController.text =
        //               controller.wheretoGoController.text;
        //         }
        //         chooseOnMapController.isWorkAddressScreen = false;
        //         chooseOnMapController.isHomeAddressScreen = false;

        //         chooseOnMapController.mapLoading = false;
        //         chooseOnMapController.isMainMapScreen = true;
        //         chooseOnMapController.update();

        //         Get.toNamed(Routes.chooseOnMap);

        //         // Future.delayed(Duration(microseconds: 500), () {
        //         //   chooseOnMapController.onInit();
        //         // });
        //         // collapseWithoutUnfocus();
        //       }),
        // ),
        body: Material(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      child: Stack(
                        children: [
                          controller.isBottomSheetTapped
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SafeArea(
                                      bottom: false,
                                      child: Container(
                                        child: InkWell(
                                          onTap: () {
                                            controller
                                                    .isWhereToAriveSelectedFromPromt =
                                                false;
                                            controller
                                                    .isWhereToGoSelectedFromPromt =
                                                false;
                                            if (controller.whereToAriveFocusNode
                                                    .hasFocus ||
                                                controller.wheretoGoFocusNode
                                                    .hasFocus) {
                                              controller.whereToAriveFocusNode
                                                  .unfocus();
                                              controller.wheretoGoFocusNode
                                                  .unfocus();
                                            }

                                            controller.whereToAriveFocusNode
                                                .requestFocus();

                                            controller.cache[
                                                'whereToGoControllerText'] = "";

                                            // controller.updateWhereToArrive();
                                            controller.update();

                                            controller.scrollController.close();
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 7.w,
                                            ),
                                            height: 5.h,
                                            width: 5.h,
                                            decoration: BoxDecoration(
                                                color: colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      )),
                                )
                              : Container(),
                          Center(
                            child: SafeArea(
                              top: controller.isBottomSheetExpanded
                                  ? true
                                  : false,
                              bottom: false,
                              child: Container(
                                width: 14.w,
                                height: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: controller.isBottomSheetExpanded
                                      ? colorScheme.primary
                                      : Color(0xffC4C4C4),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    controller.isBottomSheetTapped
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(),

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
                    // Stack(
                    //   children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      padding: EdgeInsets.only(left: 15, top: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Image.asset(
                                    AssetsPath.location,
                                    height: 4.h,
                                    width: 4.w,
                                  ),
                                  Container(
                                      width: 1,
                                      height: 3.h,
                                      color: Color(0xffEADB57)),
                                  SizedBox(height: 3),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 3, right: 3, top: 7),
                                      child: TextField(
                                        cursorHeight: 23,
                                        cursorColor: colorScheme.primary,
                                        // key: UniqueKey(),
                                        // onTap: () {
                                        //   value.expandSheet();
                                        // },

                                        onTap: () {
                                          if (controller.isStartLoading) return;

                                          controller.isWhereToAriveFieldTapped =
                                              true;
                                          controller.isWhereToGoFieldTapped =
                                              false;

                                          log("where to go ${controller.isWhereToGoSelectedFromPromt.toString()}");
                                          log(controller.lastFocus);

                                          if (controller
                                                  .isWhereToGoSelectedFromPromt ==
                                              false) {
                                            // controller.wheretoGoController
                                            //     .clear();
                                            controller
                                                    .wheretoGoController.text =
                                                controller.cache[
                                                    "whereToGoControllerText"];
                                          }
                                          if (controller.isWhereToGoChanged ==
                                              true) {
                                            if (controller
                                                    .isWhereToGoSelectedFromPromt ==
                                                false) {
                                              controller.wheretoGoController
                                                  .text = controller
                                                      .cache[
                                                  "whereToGoControllerText"];
                                            } else {
                                              controller.wheretoGoController
                                                      .text =
                                                  controller
                                                      .tappedDestinationAddress;
                                            }
                                          }
                                          controller.scrollController.open();
                                          controller.isBottomSheetExpanded ==
                                                  false
                                              ? 1
                                              : controller.whereToGoTapCount +=
                                                  1;
                                          log("count");
                                          log(controller.whereToGoTapCount
                                              .toString());

                                          controller.lastFocus =
                                              "whereToArrive";

                                          controller.update();
                                          controller.updateSearchTerm("");
                                          controller.updateSuggestions();
                                          if (controller.whereToGoTapCount >
                                              1) {
                                            // lastFocus = "whereToArrive";
                                            // updateSuggestions();
                                            if (controller.wheretoGoController
                                                .text.isNotEmpty) {
                                              if (controller
                                                      .whereToAriveEdtingController
                                                      .text !=
                                                  controller.cache[
                                                      "whereToGoControllerText"]) {
                                                controller
                                                    .showWhereToGoSaveAlert(
                                                        context);
                                              }
                                            }
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

                                          controller.update();
                                        },

                                        // suggestions: [
                                        //   "ABC",
                                        //   "XYas d asd fasd fa sdf asdf Z"
                                        // ],
                                        controller: controller
                                            .whereToAriveEdtingController,
                                        readOnly:
                                            !controller.isBottomSheetExpanded,
                                        onSubmitted: (v) {
                                          controller
                                              .whereToAriveEdtingController
                                              .text = controller
                                                  .cache[
                                              'whereToArriveControllerText'];

                                          controller.isWhereToAriveFieldTapped =
                                              false;
                                          controller.isWhereToGoFieldTapped =
                                              true;

                                          controller.whereToAriveFocusNode
                                              .unfocus();

                                          controller.lastFocus = "whereToGo";

                                          controller.wheretoGoFocusNode
                                              .requestFocus();

                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            controller.updateSearchTerm("");
                                            controller.updateSuggestions();
                                          });
                                          if (controller
                                                  .whereToAriveEdtingController
                                                  .text
                                                  .isNotEmpty &&
                                              controller
                                                      .whereToAriveEdtingController
                                                      .text !=
                                                  controller.cache[
                                                      'whereToArriveControllerText']) {
                                            controller
                                                .showWhereToArriveSaveAlert(
                                                    context);
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
                                            // controller.collapseSheet();
                                            controller.moveToTariff();
                                            return;
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF-Pro Display"),
                                        focusNode:
                                            controller.whereToAriveFocusNode,
                                        onChanged: (text) {
                                          controller.isWhereToGoChanged = false;
                                          controller.isWhereToAriveChanged =
                                              true;

                                          if (text.isEmpty) {
                                            controller.suggestions = [];
                                            controller.update();

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              controller.suggestions = [];
                                              controller.update();

                                              controller.updateSearchTerm("");

                                              controller.updateSuggestions();
                                            });
                                            return;
                                          }
                                          // updateControllerCache();

                                          controller.updateSearchTerm(text);

                                          controller.updateSuggestions();
                                        },
                                        textInputAction: controller
                                                .wheretoGoController
                                                .text
                                                .isEmpty
                                            ? TextInputAction.next
                                            : TextInputAction.done,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 8.0),
                                          suffixIconConstraints: BoxConstraints(
                                            maxWidth: 30,
                                            maxHeight: 30,
                                          ),
                                          suffixIcon: controller
                                                      .isBottomSheetExpanded &&
                                                  controller
                                                      .whereToAriveFocusNode
                                                      .hasFocus
                                              ? GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .whereToAriveEdtingController
                                                        .clear();
                                                    // controller
                                                    //     .updateControllerCache();
                                                    controller
                                                        .updateSearchTerm("");
                                                    controller
                                                        .updateSuggestions();
                                                    controller.suggestions = [];
                                                    // controller
                                                    //         .arrivalAddress =
                                                    //     MyAddress();
                                                    controller.update();
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    width: 30,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: 3.h,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                          labelStyle: TextStyle(
                                              color: colorScheme
                                                  .secondaryContainer,
                                              fontSize: 12,
                                              fontFamily: "SF-Pro Display"),
                                          isDense: true,
                                          border: InputBorder.none,
                                          labelText: language.whereToArrive,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left:
                                              !controller.isBottomSheetExpanded
                                                  ? 0
                                                  : 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 0.5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 3, right: 3),
                                      child: TextField(
                                        cursorHeight: 23,
                                        // key: UniqueKey(),
                                        onSubmitted: (v) {
                                          if (controller.wheretoGoController
                                                  .text.isNotEmpty &&
                                              controller.wheretoGoController
                                                      .text !=
                                                  controller.cache[
                                                      'whereToGoControllerText']) {
                                            controller.showWhereToGoSaveAlert(
                                                context);
                                            return;
                                          }
                                          if (controller.wheretoGoController
                                                      .text ==
                                                  controller.cache[
                                                      'whereToGoControllerText'] &&
                                              controller.arrivalAddress.name !=
                                                  null &&
                                              controller.wheretoGoController
                                                  .text.isNotEmpty) {
                                            // controller.collapseSheet();
                                            // controller.moveToTariff();
                                            return;
                                          } else {
                                            // controller.collapseSheet();
                                          }
                                        },
                                        // autofocus: true,
                                        // onTap: () {
                                        //   value.expandSheet();
                                        // },
                                        onTap: () {
                                          if (controller.isStartLoading) return;

                                          controller.isWhereToAriveFieldTapped =
                                              false;
                                          controller.isWhereToGoFieldTapped =
                                              true;

                                          log("where to arive ${controller.isWhereToAriveSelectedFromPromt.toString()}");
                                          controller
                                              .whereToAriveEdtingController
                                              .text = controller
                                                  .cache[
                                              'whereToArriveControllerText'];

                                          if (controller
                                                  .isWhereToAriveSelectedFromPromt ==
                                              false) {
                                            // controller
                                            //     .whereToAriveEdtingController
                                            //     .clear();
                                            // controller
                                            //     .whereToAriveEdtingController
                                            //     .text = controller
                                            //         .cache[
                                            //     "whereToArriveControllerText"];
                                          }
                                          if (controller
                                                  .isWhereToAriveChanged ==
                                              true) {
                                            if (controller
                                                    .isWhereToAriveSelectedFromPromt ==
                                                false) {
                                              controller
                                                  .whereToAriveEdtingController
                                                  .text = controller
                                                      .cache[
                                                  "whereToArriveControllerText"];
                                            } else {
                                              controller
                                                      .whereToAriveEdtingController
                                                      .text =
                                                  controller.tappedAriveAddress;
                                            }
                                          }

                                          controller.scrollController.open();
                                          controller.isBottomSheetExpanded ==
                                                  false
                                              ? 1
                                              : controller
                                                  .whereToArriveTapCount += 1;

                                          log("count");
                                          log(controller.whereToArriveTapCount
                                              .toString());

                                          controller.lastFocus = "whereToGo";

                                          if (controller.whereToArriveTapCount >
                                              1) {
                                            // updateSuggestions();

                                            if (controller
                                                .whereToAriveEdtingController
                                                .text
                                                .isNotEmpty) {
                                              if (controller
                                                      .whereToAriveEdtingController
                                                      .text !=
                                                  controller.cache[
                                                      "whereToArriveControllerText"]) {
                                                controller
                                                    .showWhereToArriveSaveAlert(
                                                        context);
                                              }
                                            }
                                          }
                                          controller.lastFocus = "whereToGo";

                                          controller.wheretoGoFocusNode
                                              .requestFocus();

                                          print("hereontap");
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            controller.updateSearchTerm("");
                                            controller.updateSuggestions();
                                          });
                                        },

                                        // suggestions: [
                                        //   "ABC",
                                        //   "XYas d asd fasd fa sdf asdf Z"
                                        // ],
                                        onChanged: (text) {
                                          controller.isWhereToGoChanged = true;
                                          controller.isWhereToAriveChanged =
                                              false;
                                          print(
                                              'herechange $text ${text.isEmpty}');
                                          if (text.isEmpty) {
                                            controller.suggestions = [];
                                            controller.update();

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              controller.suggestions = [];
                                              controller.update();

                                              controller.updateSearchTerm("");

                                              controller.updateSuggestions();
                                            });
                                            return;
                                          }
                                          controller.updateSearchTerm(text);

                                          controller.updateSuggestions();
                                        },
                                        readOnly:
                                            !controller.isBottomSheetExpanded,
                                        controller:
                                            controller.wheretoGoController,
                                        focusNode:
                                            controller.wheretoGoFocusNode,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "SF-Pro Display"),
                                        textInputAction: controller
                                                .whereToAriveEdtingController
                                                .text
                                                .isEmpty
                                            ? TextInputAction.next
                                            : TextInputAction.done,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 12.0),
                                          suffixIconConstraints: BoxConstraints(
                                            maxWidth: 30,
                                            maxHeight: 30,
                                          ),
                                          suffixIcon: controller
                                                      .isBottomSheetExpanded &&
                                                  controller.wheretoGoFocusNode
                                                      .hasFocus
                                              ? GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .wheretoGoController
                                                        .clear();
                                                    // controller
                                                    //     .updateControllerCache();
                                                    controller
                                                        .updateSearchTerm("");
                                                    controller.suggestions = [];
                                                    // controller
                                                    //         .destinationAddress =
                                                    //     MyAddress();
                                                    controller.update();
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    width: 30,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 1.0),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 3.h,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              : null,

                                          // suffixIcon: Icon(Icons.close),
                                          border: InputBorder.none,
                                          labelText: language.whereToGo,
                                          labelStyle: TextStyle(
                                              color: colorScheme
                                                  .secondaryContainer,
                                              fontSize: 12,
                                              fontFamily: "SF-Pro Display"),
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // isBottomSheetExpanded
                    //     ? Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Container(
                    //           color: Colors.blue,
                    //           height: ,
                    //           child: VerticalDivider(
                    //             color: Colors.yellow,
                    //             thickness: 2,
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                    //   ],
                    // ),

                    // isBottomSheetExpanded
                    //     ? Positioned(
                    //         top: MediaQuery.of(context).size.height * 0.067,
                    //         left: 30,
                    //         child: Container(
                    //           height: 20,
                    //           child: VerticalDivider(
                    //             color: Colors.yellow,
                    //             thickness: 2,
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),

                    controller.isBottomSheetExpanded == true
                        ? Expanded(child: AddressSuggestionView())
                        : BottomSheetOptions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
