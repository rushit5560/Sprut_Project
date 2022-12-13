import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/widgets/circular_progress_bar/circular_progress_bar.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import '../../no_internet/no_internet.dart';

class SelectCities extends StatefulWidget {
  bool isChooseMapScreen;
  bool isSettingScreen;

  SelectCities({this.isChooseMapScreen = false, this.isSettingScreen = false});

  @override
  State<SelectCities> createState() => _SelectCitiesState();
}

class _SelectCitiesState extends State<SelectCities> {
  HomeViewController homeScreenScreenController =
      Get.find<HomeViewController>();
  ChooseOnMapController chooseOnMapController =
      Get.put(ChooseOnMapController());

  AvailableCitiesModel? selectedCity;

  static DatabaseService databaseService =
      serviceLocator.get<DatabaseService>();
  int selectCityRadioValue =
      databaseService.getFromDisk(DatabaseKeys.selectedCityGroupValue) ?? 0;

  bool isDefaultCitySaved = false;
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, connectionState) {
    if (connectionState is ConnectedFailureState) {
      return NoInternetScreen(onPressed: () async {});
    }
    if (connectionState is ConnectedSucessState) {}
    return SafeArea(
      top: widget.isSettingScreen ? false : true,
      bottom: widget.isSettingScreen ? false : true,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
            child: PrimaryElevatedBtn(
                buttonText: language.confirm,
                onPressed: () async {
                  bool isConnected = await Helpers.checkInternetConnectivity();

                  if (!isConnected) {
                    Helpers.internetDialog(context);
                    return;
                  }

                  if (selectedCity != null) {
                    Helpers.submitCity(city: selectedCity!);

                    /// Saving radio button group value into db for  showing the previous selectedCity in UI
                    databaseService.saveToDisk(
                        DatabaseKeys.selectedCityGroupValue,
                        selectCityRadioValue);

                    databaseService.saveToDisk(
                        DatabaseKeys.selectedCityCode, selectedCity!.code);
                    if (widget.isChooseMapScreen == false) {
                      /// It Means it is home screen

                      homeScreenScreenController.selectCityName.value =
                          selectedCity!.name;
                      homeScreenScreenController.currentCity = selectedCity;
                      homeScreenScreenController.selectedCityCode =
                          selectedCity!.code;

                      homeScreenScreenController.googleMapController!
                          .animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: (LatLng(
                                homeScreenScreenController
                                    .locationData!.latitude!,
                                homeScreenScreenController
                                    .locationData!.longitude!)),
                            zoom: 17.0,
                          ),
                        ),
                      );
                      homeScreenScreenController.update();
                      log(homeScreenScreenController.selectCityName.value);
                    } else if (widget.isChooseMapScreen == true) {
                      Helpers.submitCity(city: selectedCity!);
                      databaseService.saveToDisk(
                          DatabaseKeys.selectedCityCode, selectedCity!.code);
                      chooseOnMapController.selectCityName.value =
                          selectedCity!.name;
                      log(chooseOnMapController.selectCityName.value);
                      chooseOnMapController.currentCity = selectedCity;
                      chooseOnMapController.selectedCityCode =
                          selectedCity!.code;

                      chooseOnMapController.googleMapControllerTwo!
                          .animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: (LatLng(
                                chooseOnMapController.locationData!.latitude!,
                                chooseOnMapController
                                    .locationData!.longitude!)),
                            zoom: 17.0,
                          ),
                        ),
                      );
                      log(homeScreenScreenController.selectCityName.value);
                    }

                    Navigator.pop(context);
                  }
                }),
          ),
        ),
        body: SafeArea(
          top: widget.isSettingScreen ? false : true,
          bottom: widget.isSettingScreen ? false : true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget.isSettingScreen ? 10 : 32,
                ),
                if (widget.isSettingScreen)
                  SafeArea(
                    top: true,
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 7.w,
                                ),
                                height: 5.h,
                                width: 5.h,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // _sizedBox(),
                Text(language.city,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 15.sp, color: AppThemes.dark)),
                SizedBox(
                  height: 4.0,
                ),
                Text(language.whereLive,
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 10.sp, color: colorScheme.secondary)),
                SizedBox(
                  height: 8.0,
                ),
                // _sizedBox(),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is FetechedAvailableCities) {
                      if (isDefaultCitySaved == false &&
                          selectCityRadioValue == 0) {
                        selectedCity = state.availableCities[0];
                      } else {
                        selectedCity =
                            state.availableCities[selectCityRadioValue];
                      }

                      if (state.availableCities.isNotEmpty) {
                        setState(() {});
                      }
                    }
                  },
                  builder: (context, state) {
                    if (homeScreenScreenController.allCities != null) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                homeScreenScreenController.allCities!.length,
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              String cityName = "";

                              if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Vinnytsia") {
                                cityName = language.vinnytsia;
                              } else if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Uman") {
                                cityName = language.uman;
                              } else if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Haisyn") {
                                cityName = language.haisyn;
                              }

                              return GestureDetector(
                                onTap: () {
                                  selectCityRadioValue = index;

                                  selectedCity = homeScreenScreenController
                                      .allCities![index];
                                  homeScreenScreenController.getCars();
                                  isDefaultCitySaved = true;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cityName,
                                              style: TextStyle(
                                                  color: selectCityRadioValue !=
                                                          index
                                                      ? Colors.black
                                                      : colorScheme.primary,
                                                  fontFamily:
                                                      AppConstants.fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10.sp),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectCityRadioValue = index;

                                                selectedCity =
                                                    homeScreenScreenController
                                                        .allCities![index];
                                                homeScreenScreenController
                                                    .getCars();

                                                databaseService.saveToDisk(
                                                    DatabaseKeys
                                                        .selectedCityGroupValue,
                                                    index);
                                                setState(() {});
                                              },
                                              child: AbsorbPointer(
                                                absorbing: true,
                                                child: Radio(
                                                  activeColor:
                                                      colorScheme.primary,
                                                  groupValue: index,
                                                  value: selectCityRadioValue,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: BorderRadius.circular(9)),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    if (state is FetechedAvailableCities) {
                      homeScreenScreenController.allCities =
                          state.availableCities;
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                homeScreenScreenController.allCities!.length,
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              String cityName = "";

                              if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Vinnytsia") {
                                cityName = language.vinnytsia;
                              } else if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Uman") {
                                cityName = language.uman;
                              } else if (homeScreenScreenController
                                      .allCities![index]!.name ==
                                  "Haisyn") {
                                cityName = language.haisyn;
                              }

                              return GestureDetector(
                                onTap: () {
                                  selectCityRadioValue = index;

                                  selectedCity = homeScreenScreenController
                                      .allCities![index];
                                  isDefaultCitySaved = true;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 14),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cityName,
                                              style: TextStyle(
                                                  color: selectCityRadioValue !=
                                                          index
                                                      ? Colors.black
                                                      : colorScheme.primary,
                                                  fontFamily:
                                                      AppConstants.fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10.sp),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectCityRadioValue = index;

                                                selectedCity =
                                                    homeScreenScreenController
                                                        .allCities![index];
                                                homeScreenScreenController
                                                    .getCars();

                                                setState(() {});
                                              },
                                              child: AbsorbPointer(
                                                absorbing: true,
                                                child: Radio(
                                                  activeColor:
                                                      colorScheme.primary,
                                                  groupValue: index,
                                                  value: selectCityRadioValue,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: BorderRadius.circular(9)),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Center(child: SprutCircularProgressBar()),
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        backgroundColor: colorScheme.onBackground,
      ),
    );
  },
);
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 1.h,
    );
  }
}
