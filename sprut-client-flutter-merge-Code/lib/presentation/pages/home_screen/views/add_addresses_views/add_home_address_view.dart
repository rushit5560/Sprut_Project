import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/home_screen/views/address_suggestion_view/address_suggestion_view.dart';
import 'package:sprut/presentation/widgets/custom_text_field/custom_text_field.dart';
import 'package:sprut/presentation/widgets/primary_container/primary_container.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHomeAddress extends StatefulWidget {
  @override
  State<AddHomeAddress> createState() => _AddHomeAddressState();
}

class _AddHomeAddressState extends State<AddHomeAddress> {
  ChooseOnMapController chooseOnMapController =
      Get.put(ChooseOnMapController());
  HomeViewController homeViewController = Get.find<HomeViewController>();
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(language.homeAddress,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 12.sp, color: AppThemes.dark)),
                SizedBox(
                  height: 2,
                ),
                Text(language.enterHomeLocation,
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 8.sp, color: colorScheme.secondary)),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  focusNode: focusNode,
                  isOther: false,
                  textInputType: TextInputType.name,
                  onChanged: (value) {
                    homeViewController.updateSearchTerm(chooseOnMapController
                        .addHomeAddressEditingController.text);
                    homeViewController.osmSuggestionsFuture =
                        homeViewController.getSuggestions();
                    homeViewController.update();
                    setState(() {});
                  },
                  suffixIcon: chooseOnMapController
                          .addHomeAddressEditingController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            chooseOnMapController
                                .addHomeAddressEditingController
                                .clear();
                            homeViewController.suggestions = [];
                            homeViewController.osmSuggestionsFuture = null;
                            homeViewController.update();
                            setState(() {});
                          },
                          icon: Icon(Icons.close))
                      : null,
                  validator: (value) {},
                  prefixIcon: Stack(alignment: Alignment.center, children: [
                    SvgPicture.asset(
                      AssetsPath.homeSvg,
                      height: 2.h,
                      width: 4.w,
                    )
                  ]),
                  controller:
                      chooseOnMapController.addHomeAddressEditingController,
                  hintText: language.home,
                ),
                Expanded(
                    child: AddressSuggestionView(
                        isHomeAddressScreen: true,
                        isWorkAddressScreen: true,
                        isOtherAddressScreen: true)),
              ]),
              // Positioned(
              //     bottom: focusNode.hasFocus == false ? 0 : 10,
              //     left: 7,
              //     right: 7,
              //     child: PrimaryElevatedBtn(
              //         widget: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Image.asset(AssetsPath.locatorWhite, height: 2.h),
              //             SizedBox(
              //               width: 5,
              //             ),
              //             Text("Choose on map",
              //                 style: textTheme.bodyText2!.copyWith(
              //                     color: colorScheme.background,
              //                     fontSize: 11.sp)),
              //           ],
              //         ),
              //         isHomeScreen: true,
              //         fontSize: 12.sp,
              //         buttonText: "",
              //         onPressed: () {
              //           chooseOnMapController.isHomeAddressScreen = true;
              //           chooseOnMapController.isWorkAddressScreen = false;
              //           Get.toNamed(
              //             Routes.chooseOnMap,
              //           );

              //           Future.delayed(Duration(seconds: 1), () {
              //             chooseOnMapController.onInit();
              //           });
              //         }))
            ],
          ),
        ),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: colorScheme.onBackground,
            actions: [
              Spacer(),
              SizedBox(
                width: 30.w,
              ),
              Expanded(
                child: GetBuilder<HomeViewController>(
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: PrimaryElevatedBtn(
                        fontSize: 10.sp,
                        
                        buttonText: language.save,
                        color: chooseOnMapController
                                    .addHomeAddressEditingController
                                    .text
                                    .isEmpty ||
                                (chooseOnMapController
                                        .addHomeAddressEditingController
                                        .text
                                        .isNotEmpty &&
                                    homeViewController
                                        .cacheAddress["homeAddress"]
                                        .toString()
                                        .isEmpty) ||
                                (chooseOnMapController
                                        .addHomeAddressEditingController
                                        .text
                                        .isNotEmpty &&
                                    homeViewController
                                        .cacheAddress["homeAddress"]
                                        .toString()
                                        .isNotEmpty &&
                                    (chooseOnMapController
                                            .addHomeAddressEditingController
                                            .text !=
                                        homeViewController
                                            .cacheAddress["homeAddress"]
                                            .toString()))
                            ? Colors.grey
                            : null,
                        onPressed: () {
                          if (chooseOnMapController
                                  .addHomeAddressEditingController.text.isEmpty ||
                              (chooseOnMapController.addHomeAddressEditingController
                                      .text.isNotEmpty &&
                                  homeViewController.cacheAddress["homeAddress"]
                                      .toString()
                                      .isEmpty) ||
                              (chooseOnMapController
                                      .addHomeAddressEditingController
                                      .text
                                      .isNotEmpty &&
                                  homeViewController.cacheAddress["homeAddress"]
                                      .toString()
                                      .isNotEmpty &&
                                  (chooseOnMapController
                                          .addHomeAddressEditingController
                                          .text !=
                                      homeViewController
                                          .cacheAddress["homeAddress"]
                                          .toString()))) {
                            return;
                          }

                          if (chooseOnMapController
                              .addHomeAddressEditingController
                              .text
                              .isNotEmpty) {
                            databaseService.saveToDisk(
                                DatabaseKeys.userHomeAddress,
                                chooseOnMapController
                                    .addHomeAddressEditingController.text);

                            homeViewController.cacheAddress["homeAddress"] =
                                chooseOnMapController
                                    .addHomeAddressEditingController.text;
                          }

                          homeViewController.update();

                          chooseOnMapController
                                  .addHomeAddressEditingController.text =
                              databaseService
                                  .getFromDisk(DatabaseKeys.userHomeAddress);

                          if (chooseOnMapController.homeAddressLocationData !=
                              null) {
                            log('not null');
                            print(chooseOnMapController
                                .homeAddressLocationData!.latitude);
                            databaseService.saveToDisk(
                                DatabaseKeys.homeAddressLatitude,
                                chooseOnMapController
                                    .homeAddressLocationData!.latitude);
                            print(chooseOnMapController
                                .homeAddressLocationData!.longitude);
                            databaseService.saveToDisk(
                                DatabaseKeys.homeAddressLongitude,
                                chooseOnMapController
                                    .homeAddressLocationData!.longitude);
                          }

                          Navigator.pop(context);
                        }),
                  ),
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryContainer(
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.background,
                      ))),
            )),
        backgroundColor: colorScheme.onBackground,
      ),
    );
  }
}
