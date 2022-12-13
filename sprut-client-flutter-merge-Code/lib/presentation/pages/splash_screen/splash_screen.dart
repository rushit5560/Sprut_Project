import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = false;
  bool isStopped = false;
  bool apiCall = false;

  AvailableCitiesModel? selectedCity;

  @override
  void initState() {
    apiCall = true;
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    isConnected = await Helpers.checkInternetConnectivity();

    await Timer.periodic(Duration(seconds: 1), (timer) async {
      isConnected = await Helpers.checkInternetConnectivity();
      if (isConnected == false) {
        // timer.cancel();
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

  routeStart() async {
    UserAuthProvider userAuthProvider = UserAuthProvider();
    if (isConnected) {
      Future.delayed(const Duration(seconds: 2), () async {
        try {
          if (Helpers.isLoggedIn()) {
            DatabaseService databaseService =
                serviceLocator.get<DatabaseService>();
            //call api for counts
            if (databaseService.getFromDisk(DatabaseKeys.selectedCity) !=
                null) {
              selectedCity = AvailableCitiesModel.fromJson(
                jsonDecode(
                  databaseService.getFromDisk(DatabaseKeys.selectedCity),
                ),
              );
              if (selectedCity != null) {
                var cityCode = selectedCity!.code;
                var response =
                    await userAuthProvider.getActiveCounts(cityCode.toString());

                if (response != null) {
                  Map<String, dynamic> mapData =
                      jsonDecode(response.toString());
                  var counts = mapData['count'];
                  if (counts > 0) {
                    databaseService.saveToDisk(
                        DatabaseKeys.activeOrderCounts, counts.toString());
                    databaseService.saveToDisk(
                        DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);

                    Get.offNamed(Routes.foodHomeScreen);
                  } else {
                    openActivity(databaseService);
                  }
                } else {
                  openActivity(databaseService);
                }
              } else {
                openActivity(databaseService);
              }
            } else {
              openActivity(databaseService);
            }
          } else {
            if (mounted) {
              setState(() {
                apiCall = false;
              });
            }
            Get.offNamed(Routes.loginScreen);
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              apiCall = false;
            });
          }
          Get.offNamed(Routes.loginScreen);
        }
      });
    } else {}
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // Note RED here
    ));
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
}
