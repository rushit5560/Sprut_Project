// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/news/controllers/news_controller.dart';
import 'package:sprut/presentation/pages/order_history/controllers/order_history_controller.dart';
import 'package:sprut/presentation/pages/search_screen/controllers/search_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/oder_delivery/delivery_payment_response.dart';
import '../../../resources/app_constants/app_constants.dart';

class MyDrawer extends StatefulWidget {
  final isEnable;
  MyDrawer({required this.isEnable});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {


  HomeViewController homeViewController = Get.put(HomeViewController());
  final DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  OrderHistoryController orderViewController = Get.put(OrderHistoryController());

  NewsController newsController = Get.put(NewsController());


  @override
  Widget build(BuildContext context) {
    if(Helpers.isLoginTypeIn() == AppConstants.TAXI_APP){
      Helpers.systemStatusBar();
    }else {
      Helpers.systemStatusBar1();
    }

    var language = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.only(left: 30),
                        margin: EdgeInsets.only(top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  AssetsPath.sprut,
                                  height: 3.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "+380${databaseService.getFromDisk(DatabaseKeys.userPhoneNumber) ?? ""}",
                                    style: textTheme.bodyText1!.copyWith(
                                        color: Helpers.isLoginTypeIn() ==
                                                AppConstants.TAXI_APP
                                            ? AppThemes.dark
                                            : Colors.white,
                                        fontSize: 10.sp),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (widget.isEnable) {
                                        Helpers.clearUser();

                                        dynamic workAddress = databaseService.getFromDisk(DatabaseKeys.userWorkAddress);
                                        dynamic homeAddress =databaseService.getFromDisk(DatabaseKeys.userHomeAddress);
                                        homeViewController.cacheAddress["homeAddress"] = homeAddress;
                                        homeViewController.cacheAddress["workAddress"] = workAddress;
                                        Navigator.pushNamedAndRemoveUntil(context,Routes.loginScreen,(route) => false);
                                      }
                                    },
                                    child: Text(
                                      language.logout,
                                      style: textTheme.bodyText1!.copyWith(
                                          color: colorScheme.error,
                                          fontSize: 9.sp),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        // color: Colors.pink,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // DrawerItem(
                            //   title: language.orderHistory,
                            //   icon: AssetsPath.order,
                            //   onPressed: () {
                            //     if (widget.isEnable) {
                            //       Navigator.of(context).pop();
                            //       //open type base History
                            //       if (Helpers.isLoginTypeIn() == AppConstants.FOOD_APP) {
                            //         //delivery History List
                            //         Get.toNamed(Routes.orderView);
                            //       } else {
                            //         orderViewController.lastOrder = false;
                            //         orderViewController.page = 1;
                            //         orderViewController.getOrderHistory();
                            //         Get.toNamed(Routes.orderHistoryView);
                            //       }
                            //     }
                            //   },
                            //   isReadCount: Helpers.isLoginTypeIn() == AppConstants.FOOD_APP && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !=null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                            //       ? true
                            //       : false,
                            //   readCount: databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) != null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                            //       ? int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)) : 0,
                            // ),

                            if (Helpers.isLoginTypeIn() ==AppConstants.FOOD_APP)
                              DrawerItem(
                                title: language.orderHistory,
                                icon: AssetsPath.order,
                                onPressed: () {
                                  if (widget.isEnable) {
                                    Navigator.of(context).pop();
                                    //open type base History
                                    if (Helpers.isLoginTypeIn() == AppConstants.FOOD_APP) {
                                      //delivery History List
                                      Get.toNamed(Routes.orderView);
                                    } else {
                                      orderViewController.lastOrder = false;
                                      orderViewController.page = 1;
                                      orderViewController.getOrderHistory();
                                      Get.toNamed(Routes.orderHistoryView);
                                    }
                                  }
                                },
                                isReadCount: Helpers.isLoginTypeIn() == AppConstants.FOOD_APP && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !=null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                                    ? true
                                    : false,
                                readCount: databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) != null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                                    ? int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)) : 0,
                              ),


                            if (Helpers.isLoginTypeIn() ==AppConstants.TAXI_APP)
                              (databaseService.getFromDisk(DatabaseKeys.order) == null || databaseService.getFromDisk(DatabaseKeys.order) == "")?
                              DrawerItem(
                                title: language.orderHistory,
                                icon: AssetsPath.order,
                                onPressed: () {
                                  if (widget.isEnable) {
                                    Navigator.of(context).pop();
                                    //open type base History
                                    if (Helpers.isLoginTypeIn() == AppConstants.FOOD_APP) {
                                      //delivery History List
                                      Get.toNamed(Routes.orderView);
                                    } else {
                                      orderViewController.lastOrder = false;
                                      orderViewController.page = 1;
                                      orderViewController.getOrderHistory();
                                      Get.toNamed(Routes.orderHistoryView);
                                    }
                                  }
                                },
                                isReadCount: Helpers.isLoginTypeIn() == AppConstants.FOOD_APP && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !=null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                                    ? true
                                    : false,
                                readCount: databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) != null && databaseService.getFromDisk(DatabaseKeys.activeOrderCounts) !="0"
                                    ? int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)) : 0,
                              ):Wrap(),




                            //Food delivery
                          if (Helpers.isLoginTypeIn() ==AppConstants.FOOD_APP)
                            (databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)!= null && int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts))==0)?
                            DrawerItem(
                              title: language.payment,
                              icon: AssetsPath.payment,
                              onPressed: () {
                                if (widget.isEnable) {
                                  Navigator.of(context).pop();
                                  Get.toNamed(Routes.paymentView);
                                }
                              },
                            ):Wrap(),

                            if (Helpers.isLoginTypeIn() ==AppConstants.TAXI_APP)
                              (databaseService.getFromDisk(DatabaseKeys.order) == null || databaseService.getFromDisk(DatabaseKeys.order) == "")?
                              DrawerItem(
                                title: language.payment,
                                icon: AssetsPath.payment,
                                onPressed: () {
                                  if (widget.isEnable) {
                                    Navigator.of(context).pop();
                                    Get.toNamed(Routes.paymentView);
                                  }
                                },
                              ):Wrap(),

                            if (Helpers.isLoginTypeIn() ==AppConstants.FOOD_APP)
                              (databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)!= null && int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts))==0)? DrawerItem(
                              title: language.setting,
                              icon: AssetsPath.settings,
                              onPressed: () {
                                // if (widget.isEnable) {
                                Navigator.of(context).pop();
                                Get.toNamed(Routes.settingsView);

                              },
                            ):Wrap(),

                            if (Helpers.isLoginTypeIn() ==AppConstants.TAXI_APP)
                              (databaseService.getFromDisk(DatabaseKeys.order) == null || databaseService.getFromDisk(DatabaseKeys.order) == "")? DrawerItem(
                                title: language.setting,
                                icon: AssetsPath.settings,
                                onPressed: () {
                                  // if (widget.isEnable) {
                                  Navigator.of(context).pop();
                                  Get.toNamed(Routes.settingsView);

                                },
                              ):Wrap(),

                            if (Helpers.isLoginTypeIn() ==AppConstants.FOOD_APP)
                              (databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)!= null && int.parse(databaseService.getFromDisk(DatabaseKeys.activeOrderCounts))==0)?
                              DrawerItem(
                              title: language.about,
                              icon: AssetsPath.about,
                              onPressed: () {
                                // if (widget.isEnable) {
                                Navigator.of(context).pop();
                                Get.toNamed(Routes.aboutUsView);
                                // }
                              },
                            ):Wrap(),
                            if (Helpers.isLoginTypeIn() ==AppConstants.TAXI_APP)
                              (databaseService.getFromDisk(DatabaseKeys.order) == null || databaseService.getFromDisk(DatabaseKeys.order) == "")?
                              DrawerItem(
                                title: language.about,
                                icon: AssetsPath.about,
                                onPressed: () {
                                  // if (widget.isEnable) {
                                  Navigator.of(context).pop();
                                  Get.toNamed(Routes.aboutUsView);
                                  // }
                                },
                              ):Wrap(),

                            DrawerItem(
                              title: language.news,
                              icon: AssetsPath.news,
                              isReadCount: (databaseService.getFromDisk(DatabaseKeys.readNews) ==null ||(databaseService.getFromDisk(DatabaseKeys.readNews) !=null &&homeViewController.newsCount >databaseService.getFromDisk(DatabaseKeys.readNews))) &&homeViewController.newsCount > 0
                                  ? true
                                  : false,
                              readCount: (databaseService.getFromDisk(DatabaseKeys.readNews) !=null && homeViewController.newsCount >databaseService.getFromDisk(DatabaseKeys.readNews))
                                  ? (homeViewController.newsCount -databaseService.getFromDisk(DatabaseKeys.readNews)).toInt()
                                  : homeViewController.newsCount,
                              onPressed: () {
                                // if (widget.isEnable) {
                                databaseService.saveToDisk(DatabaseKeys.readNews,homeViewController.newsCount);
                                Navigator.of(context).pop();
                                newsController.page = 1;
                                newsController.getNews();
                                Get.toNamed(Routes.newsView);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                      //food delivery
                      if(Get.find<HomeViewController>().selectCityName.value == "Vinnytsia")...[
                        GestureDetector(
                          child: Container(
                            child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                margin:
                                EdgeInsets.only(left: 4, right: 10, top: 8.0),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 50,
                                      child: Helpers.isLoginTypeIn() ==
                                          AppConstants.TAXI_APP
                                          ? SvgPicture.asset(
                                          AssetsPath.deliverySmallLogo)
                                          : SvgPicture.asset(
                                          AssetsPath.taxiSmallLogo),
                                    ),
                                    Expanded(
                                      child: Container(
                                        // color: Colors.yellow,
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Helpers.isLoginTypeIn() ==
                                                  AppConstants.TAXI_APP
                                                  ? language.order_a_delivery
                                                  : language.order_a_taxi,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                  fontSize: 11.sp,
                                                  color:
                                                  colorScheme.background),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Icon(Icons.arrow_forward_ios,
                                          size: 22, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (Helpers.isLoginTypeIn() ==AppConstants.FOOD_APP) {
                              databaseService.saveToDisk(
                                  DatabaseKeys.isLoginTypeIn,
                                  AppConstants.TAXI_APP);
                              String order = databaseService
                                  .getFromDisk(DatabaseKeys.order) ??
                                  "";

                              log("order model stored changed in prefs is :: ${order}");

                              if (order != "") {
                                // Navigator.pushNamedAndRemoveUntil(
                                //   context,
                                //   Routes.homeScreen,
                                //   ModalRoute.withName('/'),
                                // );

                                // await Get.toNamed(Routes.tarrifSelectionView,
                                //     arguments: {
                                //       "currentCity": currentCity,
                                //       "arrivalAddress": arrivalAddress,
                                //       "destinationAddress": destinationAddress,
                                //       "kGooglePlex": kGooglePlex,
                                //       "kLake": kLake,
                                //       "repeatOrder": repeatOrder,
                                //     });

                                await Get.toNamed(Routes.searchView);

                                // .whenComplete(() async {
                                //   await Get.toNamed(Routes.tarrifSelectionView,
                                //           arguments: {
                                //         "currentCity": currentCity,
                                //         "arrivalAddress": arrivalAddress,
                                //         "destinationAddress":
                                //             destinationAddress,
                                //         "kGooglePlex": kGooglePlex,
                                //         "kLake": kLake,
                                //         "repeatOrder": repeatOrder,
                                //       })!
                                //       .whenComplete(() async {
                                //     await Get.toNamed(Routes.searchView);
                                //   });
                                // });

                                // await Get.toNamed(Routes.tarrifSelectionView);
                                // await Get.toNamed(Routes.searchView);
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.homeScreen,
                                  ModalRoute.withName('/'),
                                );
                              }
                              /*Navigator.pushNamedAndRemoveUntil(context,
                                  Routes.homeScreen, ModalRoute.withName('/'));*/
                            } else {
                              //open food screen
                              databaseService.saveToDisk(
                                  DatabaseKeys.isLoginTypeIn,
                                  AppConstants.FOOD_APP);
                              // Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context,Routes.foodHomeScreen,ModalRoute.withName('/'));
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context, Routes.foodHomeScreen, (route) => false);
                            }
                          },
                        ),
                      ]
                      //end
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    // Navigator.of(context).pop();
                    Navigator.of(context).maybePop();
                    String url = "https://sprut.ua/ru/drivers";
                    if (!await launchUrl(Uri.parse(url))) {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(left: 4, right: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.becomeDriver,
                                  style: textTheme.bodyText1!.copyWith(
                                      fontSize: 11.sp,
                                      color: colorScheme.background),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.transparent,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(
                                          language.toMakeMoney,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 9.sp,
                                              color: colorScheme.background),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Icon(Icons.arrow_forward_ios,
                              size: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
    );
  }
}

class DrawerItem extends StatelessWidget {
  String icon;
  String title;
  bool isReadCount;
  int readCount;
  Function onPressed;

  DrawerItem({required this.icon,
      required this.title,
      this.isReadCount = false,
      this.readCount = 0,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 16),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 3.h,
              width: 3.h,
              // width: 20,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: textTheme.bodyText1!.copyWith(
                fontSize: 10.sp,
                color: Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
                    ? AppThemes.dark
                    : Colors.white,
              ),
            ),
            if (isReadCount)
              SizedBox(
                width: 5.0,
              ),
            if (isReadCount)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "$readCount",
                  style: textTheme.caption?.copyWith(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
