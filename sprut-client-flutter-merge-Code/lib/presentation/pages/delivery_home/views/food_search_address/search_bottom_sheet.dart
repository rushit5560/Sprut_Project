import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/address_food_suggestion_controller.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../no_internet/no_internet.dart';
import '../address_food_suggestion_view/address_food_suggestion_view.dart';

class SearchBottomSheetView extends StatefulWidget {
  const SearchBottomSheetView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBottomSheetViewState();
}

class _SearchBottomSheetViewState extends State<SearchBottomSheetView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AddressFoodSuggestionController controller =
      Get.put(AddressFoodSuggestionController(), permanent: true);

  @override
  void initState() {
    super.initState();
    controller.lastFocus = "whereToDeliver";
    controller.checkSaveDeliveryAddress();
    controller.getDeliveryAddress();
    Future.delayed(Duration(seconds: 1), () async {
      controller.fetchUserLocation(context);
      controller.getListOfRecentlySearchList();
      controller.update();
    });

  }

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

    return GetBuilder<AddressFoodSuggestionController>(
      builder: (_) => Scaffold(
          key: _scaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          backgroundColor: AppThemes.foodBgColor,
          body: Material(
            color: AppThemes.foodBgColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      IntrinsicHeight(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SafeArea(
                                  child: Container(
                                child: InkWell(
                                  onTap: () {
                                    controller.lastSelectedAddress = "";
                                    Navigator.pop(context);
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
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              )),
                            ),
                            // : Container(),
                            Center(
                              child: Container(width: 14.w),
                            ),
                            SafeArea(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GetBuilder<AddressFoodSuggestionController>(
                                  builder: (_) => Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(Size(
                                          10.h,
                                          5.h,
                                        )),
                                        backgroundColor: MaterialStateProperty.all(
                                            !controller.isSaveButtonEnable
                                                ? Colors.grey
                                                : colorScheme.primary),
                                        // elevation: MaterialStateProperty.all(3),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      onPressed: () {
                                        if (!controller.isSaveButtonEnable) {
                                          return;
                                        } else {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          //save address in local db
                                          controller.finalSaveAddressOfDelivery(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                        ),
                                        child: Text(language.save,
                                            style: textTheme.bodyText2!.copyWith(
                                                color: colorScheme.background,
                                                fontSize: 14.sp,
                                                fontFamily: AppConstants.fontFamily)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                padding: EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(color: AppThemes.foodBgColor,borderRadius:BorderRadius.all(Radius.circular(8)),border: Border.all(color: Color(0xffA4A4A4), width: 1.5)),
                                constraints: BoxConstraints(maxHeight: 66),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 40,
                                      child: Image.asset(
                                        AssetsPath.location,
                                        color: AppThemes.colorWhite,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        // color: Colors.yellow,
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(left: 4.0, top: 6.0, right: 4.0, bottom: 6.0),
                                                child: TextField(
                                                  cursorHeight: 23,
                                                  cursorColor: colorScheme.primary,
                                                  onTap: () {
                                                    debugPrint("onTap :: onTap()");
                                                    log(controller.lastFocus);
                                                    print(controller.wheretoDeliverFocusNode.hasFocus);
                                                    //where to deliver
                                                    controller.lastFocus = "whereToDeliver";
                                                    controller.isWhereToDeliveredFieldTapped = true;
                                                    controller.isWhereBuildingAddressTapped = false;
                                                    controller.update();
                                                    // setState((){});
                                                    print(controller.wheretoDeliverFocusNode.hasFocus);
                                                  },
                                                  controller: controller
                                                      .wheretoDeliverGoController,
                                                  readOnly: !controller
                                                      .isFoodBottomSheetExpanded,
                                                  onSubmitted: (v) {},
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "SF-Pro Display",
                                                      color: AppThemes.colorWhite),
                                                  focusNode: controller
                                                      .wheretoDeliverFocusNode,
                                                  onChanged: (text) {
                                                    debugPrint("onChanged :: $text");
                                                    debugPrint("onChanged :: ${controller.lastSelectedAddress}");
                                                    if(text == controller.lastSelectedAddress){
                                                      debugPrint("onChanged :: IF");
                                                      controller.saveButtonStatusChange(true);
                                                      controller.update();
                                                    }else{
                                                      debugPrint("onChanged :: else");
                                                      controller.isSaveButtonEnable = false;
                                                      controller.saveButtonStatusChange(false);
                                                      controller.update();
                                                    }

                                                    // controller.isWhereToGoChanged = false;
                                                    // controller.isWhereToAriveChanged = true;
                                                    if (text.isEmpty) {
                                                      controller.suggestions = [];
                                                      controller.update();

                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds: 2000),
                                                          () {
                                                        controller.suggestions = [];
                                                        controller.update();

                                                        controller
                                                            .updateSearchTerm("");

                                                        controller
                                                            .updateSuggestions();
                                                      });
                                                      return;
                                                    }

                                                    controller.updateSearchTerm(text);
                                                    controller.osmFoodSuggestionsFuture = controller.getSuggestions();

                                                    // controller.update();
                                                    // setState(() {});
                                                  },
                                                  textInputAction: controller
                                                          .whereToAddressEditingController
                                                          .text
                                                          .isEmpty
                                                      ? TextInputAction.next
                                                      : TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(
                                                        bottom: 8.0),
                                                    suffixIconConstraints:
                                                        BoxConstraints(
                                                      maxWidth: 30,
                                                      maxHeight: 30,
                                                    ),
                                                    // suffixIcon: controller
                                                    //             .isFoodBottomSheetExpanded &&
                                                    //         controller
                                                    //             .wheretoDeliverFocusNode
                                                    //             .hasFocus
                                                    suffixIcon: controller
                                                        .wheretoDeliverGoController.text.length > 0
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .wheretoDeliverGoController
                                                                  .clear();
                                                              // controller
                                                              //     .updateControllerCache();
                                                              // controller
                                                              //     .updateSearchTerm(
                                                              //     "");
                                                              // controller
                                                              //     .updateSuggestions();
                                                              controller.suggestions = [];
                                                              // controller
                                                              //         .arrivalAddress =
                                                              //     MyAddress();
                                                              controller.saveButtonStatusChange(true);
                                                              controller.update();
                                                            },
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomRight,
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
                                                        color: AppThemes
                                                            .colorTextLight,
                                                        fontSize: 12.sp,
                                                        fontFamily:
                                                            "SF-Pro Display"),
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    labelText: language.where_to_deliver,
                                                    focusedBorder: InputBorder.none,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ), //search location
                              Container(
                                margin: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                padding: EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                    color: AppThemes.foodBgColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                        color: Color(0xffA4A4A4), width: 1.5)),
                                constraints: BoxConstraints(maxHeight: 66),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        // color: Colors.yellow,
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0,
                                                  top: 6.0,
                                                  right: 4.0,
                                                  bottom: 0.0),
                                              child: TextField(
                                                cursorHeight: 23,
                                                cursorColor: colorScheme.primary,
                                                onTap: () {
                                                  log(controller.lastFocus);
                                                  print(controller.whereToAddressFocusNode.hasFocus);
                                                  controller.lastFocus = "whereToBuildingAddress";
                                                  controller
                                                          .isWhereBuildingAddressTapped =
                                                      true;
                                                  controller
                                                          .isWhereToDeliveredFieldTapped =
                                                      false;
                                                  controller.updateSearchTerm("");
                                                  controller.updateSuggestions();
                                                  controller.suggestions = [];
                                                  controller.update();
                                                  // setState((){});
                                                  print(controller.whereToAddressFocusNode.hasFocus);
                                                },
                                                controller: controller
                                                    .whereToAddressEditingController,
                                                readOnly: !controller
                                                    .isFoodBottomSheetExpanded,
                                                onSubmitted: (v) {},
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "SF-Pro Display",
                                                    color: AppThemes.colorWhite),
                                                focusNode: controller
                                                    .whereToAddressFocusNode,
                                                onChanged: (text) {
                                                  // controller.saveButtonStatusChange();
                                                  controller.update();
                                                  // setState((){});
                                                },
                                                textInputAction: controller
                                                        .whereToAddressEditingController
                                                        .text
                                                        .isEmpty
                                                    ? TextInputAction.next
                                                    : TextInputAction.done,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(bottom: 8.0),
                                                  suffixIconConstraints:
                                                      BoxConstraints(
                                                    maxWidth: 30,
                                                    maxHeight: 30,
                                                  ),
                                                  counterText: "",
                                                  suffixIcon: controller
                                                      .whereToAddressEditingController.text.length > 0
                                                  // controller.isFoodBottomSheetExpanded && controller
                                                  //             .whereToAddressFocusNode
                                                  //             .hasFocus
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                .whereToAddressEditingController.clear();
                                                            controller.update();
                                                            // setState((){});
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .bottomRight,
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
                                                      color:
                                                          AppThemes.colorTextLight,
                                                      fontSize: 12.sp,
                                                      fontFamily: "SF-Pro Display"),
                                                  hintStyle: TextStyle(
                                                      color: AppThemes
                                                          .colorTextLight,
                                                      fontSize: 12.sp,
                                                      fontFamily:
                                                      "SF-Pro Display"),
                                                  alignLabelWithHint: true,
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  labelText: language
                                                      .entrance_number_apartment_number_floor,
                                                  focusedBorder: InputBorder.none,
                                                ),
                                                maxLength: 55,
                                              ),
                                            ),
                                          ],
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
                      if(controller.lastFocus != "whereToBuildingAddress")...[
                        Expanded(child: AddressFoodSuggestionView())
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

    );
  },
);
  }

  @override
  void dispose() {
    debugPrint("dispose Search Screen ${controller.isSaveButtonEnable}");
    debugPrint("dispose Search Screen");
    super.dispose();
  }
}
