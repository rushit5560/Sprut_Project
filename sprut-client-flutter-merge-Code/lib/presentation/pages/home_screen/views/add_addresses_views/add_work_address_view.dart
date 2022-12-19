
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
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

import '../../../no_internet/no_internet.dart';

class AddWorkAddress extends StatefulWidget {
  @override
  State<AddWorkAddress> createState() => _AddWorkAddressState();
}

class _AddWorkAddressState extends State<AddWorkAddress> {
  ChooseOnMapController chooseOnMapController = Get.put(ChooseOnMapController());
  HomeViewController homeViewController = Get.find<HomeViewController>();

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    print(
        'herework  ${chooseOnMapController.addWorkAddressEditingController.text.isEmpty}');

    print(
        'herework1  ${homeViewController.cacheAddress["workAddress"].toString().isEmpty}');

    return BlocConsumer<ConnectedBloc, ConnectedState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, connectionState) {

    if (connectionState is ConnectedFailureState) {

      return NoInternetScreen(onPressed: () async {});
    }

    if (connectionState is ConnectedSucessState) {}

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
                Text(language.workAddress,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 12.sp, color: AppThemes.dark)),
                SizedBox(
                  height: 2,
                ),
                Text(language.enterWorkLocation,
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 8.sp, color: colorScheme.secondary)),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  isOther: false,
                  textInputType: TextInputType.name,
                  onChanged: (value) {
                    homeViewController.updateSearchTerm(chooseOnMapController
                        .addWorkAddressEditingController.text);
                    homeViewController.osmSuggestionsFuture =
                        homeViewController.getSuggestions();
                    homeViewController.update();

                    setState(() {});
                  },
                  suffixIcon: chooseOnMapController
                          .addWorkAddressEditingController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            chooseOnMapController
                                .addWorkAddressEditingController
                                .clear();
                            homeViewController.suggestions = [];
                            homeViewController.osmSuggestionsFuture = null;
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
                      chooseOnMapController.addWorkAddressEditingController,
                  hintText: language.work,
                ),
                Expanded(
                  child: AddressSuggestionView(
                      isHomeAddressScreen: true,
                      isWorkAddressScreen: true,
                      isOtherAddressScreen: true),
                )
                // AddressSuggestionView()
              ]),
              // Positioned(
              //     bottom: 0,
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
              //           chooseOnMapController.isWorkAddressScreen = true;
              //           chooseOnMapController.isHomeAddressScreen = false;
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
                                    .addWorkAddressEditingController
                                    .text
                                    .isEmpty ||
                                (chooseOnMapController
                                        .addWorkAddressEditingController
                                        .text
                                        .isNotEmpty &&
                                    homeViewController
                                        .cacheAddress["workAddress"]
                                        .toString()
                                        .isEmpty) ||
                                (chooseOnMapController
                                        .addWorkAddressEditingController
                                        .text
                                        .isNotEmpty &&
                                    homeViewController
                                        .cacheAddress["workAddress"]
                                        .toString()
                                        .isNotEmpty &&
                                    (chooseOnMapController
                                            .addWorkAddressEditingController
                                            .text !=
                                        homeViewController
                                            .cacheAddress["workAddress"]
                                            .toString()))
                            ? Colors.grey
                            : null,
                        onPressed: () {
                          if (chooseOnMapController
                                  .addWorkAddressEditingController.text.isEmpty ||
                              (chooseOnMapController.addWorkAddressEditingController
                                      .text.isNotEmpty &&
                                  homeViewController.cacheAddress["workAddress"]
                                      .toString()
                                      .isEmpty) ||
                              (chooseOnMapController
                                      .addWorkAddressEditingController
                                      .text
                                      .isNotEmpty &&
                                  homeViewController.cacheAddress["workAddress"]
                                      .toString()
                                      .isNotEmpty &&
                                  (chooseOnMapController
                                          .addWorkAddressEditingController
                                          .text !=
                                      homeViewController
                                          .cacheAddress["workAddress"]
                                          .toString()))) {
                            return;
                          }

                          if (chooseOnMapController
                              .addWorkAddressEditingController
                              .text
                              .isNotEmpty) {
                            databaseService.saveToDisk(
                                DatabaseKeys.userWorkAddress,
                                chooseOnMapController
                                    .addWorkAddressEditingController.text);

                            homeViewController.cacheAddress["workAddress"] =
                                chooseOnMapController
                                    .addWorkAddressEditingController.text;
                          }

                          if (chooseOnMapController.workAddressLocationData !=
                              null) {
                            databaseService.saveToDisk(
                                DatabaseKeys.workAddressLatitude,
                                chooseOnMapController
                                    .workAddressLocationData!.latitude);
                            databaseService.saveToDisk(
                                DatabaseKeys.workAddressLongitude,
                                chooseOnMapController
                                    .workAddressLocationData!.longitude);
                          } else {}

                          homeViewController.update();
                          chooseOnMapController
                                  .addWorkAddressEditingController.text =
                              databaseService
                                  .getFromDisk(DatabaseKeys.userWorkAddress);

                          Navigator.pop(context);
                        }),
                  ),
                ),
              )
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
  },
);
  }
}
