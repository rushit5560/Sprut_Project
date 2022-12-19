import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/presentation/pages/no_internet/no_internet.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';

import '../../../data/models/available_cities_model/available_cities_model.dart';
import '../../../data/provider/authentication/auth_provider.dart';
import '../../../resources/app_constants/app_constants.dart';
import '../../../resources/configs/service_locator/service_locator.dart';
import '../../../resources/services/database/database.dart';
import '../../../resources/services/database/database_keys.dart';
import '../../../../data/models/tariff_screen_model/order_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = true;
  bool isStopped = false;
  bool apiCall = false;

  AvailableCitiesModel? selectedCity;

  @override
  void initState() {
    print("Splash : initState()");
    // apiCall = true;
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    isConnected = await Helpers.checkInternetConnectivity();
    await Timer.periodic(Duration(seconds: 1), (timer) async {
      isConnected = await Helpers.checkInternetConnectivity();
      if (isConnected == false) {
        timer.cancel();
        // Helpers.internetDialog(context);
      } else if (isConnected == true) {
        timer.cancel();
        routeStart();
      }
      if (mounted) {
        setState(() {
          isConnected;
        });
      }
      print("currentRoute Start Call}");
    });
  }

  // routeStart() async {
  //   UserAuthProvider userAuthProvider = UserAuthProvider();
  //   if (isConnected) {
  //     Future.delayed(const Duration(seconds: 2), () async {
  //       try {
  //         if (Helpers.isLoggedIn()) {
  //           DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  //           //call api for counts
  //           if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
  //             selectedCity = AvailableCitiesModel.fromJson(jsonDecode(databaseService.getFromDisk(DatabaseKeys.selectedCity)));
  //             if (selectedCity != null) {
  //               var cityCode = selectedCity!.code;
  //               var response = await userAuthProvider.getActiveCounts(cityCode.toString());
  //
  //               if (response != null) {
  //                 Map<String, dynamic> mapData =jsonDecode(response.toString());
  //                 var counts = mapData['count'];
  //                 if (counts > 0) {
  //                   databaseService.saveToDisk(DatabaseKeys.activeOrderCounts, counts.toString());
  //                   databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
  //
  //                   Get.offNamed(Routes.foodHomeScreen);
  //                 } else {
  //                   openActivity(databaseService);
  //                 }
  //               } else {
  //                 openActivity(databaseService);
  //               }
  //             } else {
  //               openActivity(databaseService);
  //             }
  //           } else {
  //             openActivity(databaseService);
  //           }
  //         } else {
  //           if (mounted) {
  //             setState(() {
  //               apiCall = false;
  //             });
  //           }
  //           Get.offNamed(Routes.loginScreen);
  //         }
  //       } catch (e) {
  //
  //         if (mounted) {
  //           setState(() {
  //             apiCall = false;
  //           });
  //         }
  //         Get.offNamed(Routes.loginScreen);
  //       }
  //     });
  //   } else {}
  // }
  routeStart() async {
    UserAuthProvider userAuthProvider = UserAuthProvider();
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        if (Helpers.isLoggedIn()) {
          log("if user logged in :: ${Helpers.isLoggedIn()}");
          DatabaseService databaseService =
              serviceLocator.get<DatabaseService>();

          log("if user accepted policy :: ${databaseService.getFromDisk(DatabaseKeys.privacyPolicyAccepted)}");
          if ((databaseService
                      .getFromDisk(DatabaseKeys.privacyPolicyAccepted) ??
                  false) ==
              false) {
            Get.offNamed(Routes.privacyPolicy);
          } else if (Helpers.isLoggedIn()) {
            log("going login screen :: else if case 0");
            //call api for counts
            selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
                databaseService.getFromDisk(DatabaseKeys.selectedCity)));

            String selectedType =
                databaseService.getFromDisk(DatabaseKeys.isLoginTypeSelected) ??
                    AppConstants.TAXI_APP;
            if (selectedType == AppConstants.TAXI_APP) {
              databaseService.saveToDisk(
                  DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
              Get.offNamed(Routes.homeScreen);
            } else if (selectedType == AppConstants.FOOD_APP) {
//  databaseService.saveToDisk(
//                             DatabaseKeys.activeOrderCounts, counts.toString());
              databaseService.saveToDisk(
                  DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
              Get.offNamed(Routes.foodHomeScreen);
            } else if (databaseService.getFromDisk(DatabaseKeys.selectedCity) !=
                null) {
              selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
                  databaseService.getFromDisk(DatabaseKeys.selectedCity)));
              if (selectedCity != null) {
                var cityCode = selectedCity!.code;
                var response =
                    await userAuthProvider.getActiveCounts(cityCode.toString());

                if (response != null) {
                  Map<String, dynamic> mapData =
                      jsonDecode(response.toString());
                  var counts = mapData['count'];
                  String order = "";
                  try {
                    order = databaseService.getFromDisk(DatabaseKeys.order);
                  } catch (e) {}

                  String selectedType = databaseService
                          .getFromDisk(DatabaseKeys.isLoginTypeSelected) ??
                      AppConstants.TAXI_APP;
                  //check selected type
                  if (selectedType == AppConstants.TAXI_APP) {
                    if (order != "") {
                      OrderModel orderModel =
                          OrderModel.fromJson(jsonDecode(order));
                      if (orderModel != null) {
                        databaseService.saveToDisk(
                            DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
                        Get.offNamed(Routes.homeScreen);
                      } else if (counts > 0) {
                        databaseService.saveToDisk(
                            DatabaseKeys.activeOrderCounts, counts.toString());
                        databaseService.saveToDisk(
                            DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
                        Get.offNamed(Routes.foodHomeScreen);
                      } else {
                        openActivity(databaseService);
                      }
                    } else {
                      if (counts > 0) {
                        databaseService.saveToDisk(
                            DatabaseKeys.activeOrderCounts, counts.toString());
                        databaseService.saveToDisk(
                            DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
                        Get.offNamed(Routes.foodHomeScreen);
                      } else {
                        openActivity(databaseService);
                      }
                    }
                  } else {
                    if (counts > 0) {
                      databaseService.saveToDisk(
                          DatabaseKeys.activeOrderCounts, counts.toString());
                      databaseService.saveToDisk(
                          DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
                      Get.offNamed(Routes.foodHomeScreen);
                    } else if (order != "") {
                      OrderModel orderModel =
                          OrderModel.fromJson(jsonDecode(order));
                      if (orderModel != null) {
                        databaseService.saveToDisk(
                            DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
                        Get.offNamed(Routes.homeScreen);
                      } else {
                        openActivity(databaseService);
                      }
                    } else {
                      openActivity(databaseService);
                    }
                  }
                } else {
                  log("going login screen :: else 1");
                  databaseService.saveToDisk(DatabaseKeys.isLoggedIn, false);

                  if (mounted) {
                    setState(() {
                      apiCall = false;
                    });
                  }
                  Get.offNamed(Routes.loginScreen);
                }
              } else {
                log("going login screen :: else 2");
                databaseService.saveToDisk(DatabaseKeys.isLoggedIn, false);

                if (mounted) {
                  setState(() {
                    apiCall = false;
                  });
                }
                Get.offNamed(Routes.loginScreen);
              }
            } else {
              log("going login screen :: else 3");
              databaseService.saveToDisk(DatabaseKeys.isLoggedIn, false);

              if (mounted) {
                setState(() {
                  apiCall = false;
                });
              }
              Get.offNamed(Routes.loginScreen);
            }
          }
        } else {
          log("going login screen :: else 4");
          if (mounted) {
            setState(() {
              apiCall = false;
            });
          }
          Get.offNamed(Routes.loginScreen);
        }
      } catch (e) {
        log("going login screen :: else 5");
        if (mounted) {
          setState(() {
            apiCall = false;
          });
        }
        Get.offNamed(Routes.loginScreen);
      }
    });
  }

  openActivity(DatabaseService databaseService) {
    if (mounted) {
      setState(() {
        apiCall = false;
      });
    }
    //set default
    databaseService.saveToDisk(DatabaseKeys.activeOrderCounts, "0");
    String selectedType =
        databaseService.getFromDisk(DatabaseKeys.isLoginTypeSelected) ??
            AppConstants.TAXI_APP;
    //check selected type
    if (selectedType == AppConstants.TAXI_APP) {
      databaseService.saveToDisk(
          DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
      Get.offNamed(Routes.homeScreen);
    } else {
      databaseService.saveToDisk(
          DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
      Get.offNamed(Routes.foodHomeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Connection failed Listener11');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // Note RED here
    ));
    var colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, connectionState) {
        // TODO: implement listener
        if (connectionState is ConnectedFailureState) {
          print('Connection failed Listener');
        } else if (connectionState is ConnectedSucessState) {
          print('Connection Listener');
          apiCall = true;
          routeStart();
        }
      },
      builder: (context, connectionState) {
        if (connectionState is ConnectedFailureState) {
          print('Connection failed Listener');
        }
        return connectionState is ConnectedFailureState || !isConnected
            ? NoInternetScreen(onPressed: () async {})
            : Scaffold(
                body: SafeArea(
                  top: false,
                  bottom: false,
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetsPath.logoWithName,
                            height: 23.h,
                          ),
                          if (apiCall) ...[
                            CircularProgressIndicator(),
                          ]
                        ],
                      ),
                      color: colorScheme.background,
                    ),
                  ),
                ),
                backgroundColor: colorScheme.background,
              );
      },
    );
  }
}

/* bool isConnected = false;
  bool isStopped = false;
  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    isConnected = await Helpers.checkInternetConnectivity();

    Timer.periodic(Duration(seconds: 1), (timer) async {
      isConnected = await Helpers.checkInternetConnectivity();
      if (isConnected == false) {
        Navigator.pop(context);
        timer.cancel();
      } else if (isConnected == true) {
        Navigator.pop(context);
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // Note RED here
    ));

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child:Center(
        child: Center(
            child: Image.asset(
          AssetsPath.logoWithName,
          height: 23.h,
        )),
      ),
      ),
      backgroundColor: colorScheme.background,
    );
  }*/
