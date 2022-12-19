import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import '../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../data/models/establishments_all_screen_models/establishment_product_list/items_cart_models.dart';
import '../../../data/models/food_category_models/food_category_list_models.dart';
import '../../../data/models/map_screen_models/my_address_model/my_address_model.dart';
import '../../../data/models/tariff_screen_model/order_model.dart';
import '../../../resources/app_constants/app_constants.dart';
import '../../../resources/app_themes/app_themes.dart';
import '../../../resources/assets_path/assets_path.dart';
import '../../../resources/configs/routes/routes.dart';
import '../../../resources/services/database/database_keys.dart';
import '../../widgets/my_drawer/my_drawer.dart';
import '../home_screen/controllers/home_controller.dart';

import '../no_internet/no_internet.dart';
import 'controller/establishment_details_controller.dart';

class DeliveryHomeView extends StatefulWidget {
  @override
  State<DeliveryHomeView> createState() => _DeliveryHomeViewState();
}

class _DeliveryHomeViewState extends State<DeliveryHomeView> {
  final GlobalKey<ScaffoldState> _scaffoldDeliveryKey =
      GlobalKey<ScaffoldState>();

  HomeViewController controller =
      Get.put(HomeViewController(), permanent: true);

  List<FoodCategoryData> availableCategoryData = [];
  List<FoodCategoryData> lsCategoryData = [];
  bool isDrawerOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appLocale = Localizations.localeOf(context);
    context.read<AuthBloc>().add(AuthFoodDeliveryCategoryListEvent());
    controller.checkLocationIfNeeded();
    if (mounted) {
      Future.delayed(Duration(seconds: 2), () {
        controller.fetchUserLocation();
        controller.activeCounts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.databaseService
        .saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
    Locale appLocale = Localizations.localeOf(context);

    Helpers.systemStatusBar1();
    //print("Delivery cat Screen3--> ${controller.databaseService.getFromDisk(DatabaseKeys.isLoginTypeIn)}");
    //print("Delivery cat Screen4--> ${Helpers.isLoginTypeIn()}");

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        if (state is ConnectedFailureState) {
          // showDialog(
          //     context: context,
          //     builder: (context) => MyCustomDialog(message: language.networkError,));
        }
      },
      builder: (context, connectionState) {
        if (connectionState is ConnectedFailureState) {
          print(
              "--------------Delivery Screen ConnectedFailureState1--------------");
          // if (controller.deliveryOrderId.isNotEmpty) {
          //   controller.lastSaveStatus = "";
          //   Navigator.pop(context);
          // }
          return NoInternetScreen(onPressed: () async {});
        }

        if (connectionState is ConnectedSucessState) {}
        return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, authState) {
          if (authState is FetchingFoodDeliveryCategoryProgress) {
            debugPrint("FetchingFoodDeliveryCategoryProgress!");
          }

          if (authState is FetchingFoodDeliveryCategorySucceed) {
            debugPrint("FetchingFoodDeliveryCategorySucceed!");
            //future delay
            Future.delayed(Duration(milliseconds: 500), () async {
              //set data
              if (authState.availableCategory!.isNotEmpty == true) {
                // debugPrint("CategorySucceed!");
                if (availableCategoryData.isNotEmpty) {
                  availableCategoryData.clear();
                  lsCategoryData.clear();
                }
                availableCategoryData = authState.availableCategory!;
                // debugPrint(
                //     "Length ::" + availableCategoryData.length.toString());
                lsCategoryData = availableCategoryData
                    .where((element) => element.enabled == true)
                    .toList();
                //add static cab item
                FoodCategoryData extraCabItem = FoodCategoryData();
                extraCabItem.name = language.call_a_cab;
                extraCabItem.nameEn = language.call_a_cab;
                extraCabItem.nameUk = language.call_a_cab;
                extraCabItem.nameRu = language.call_a_cab;
                extraCabItem.imgUrl = "gps_system_smart_car.png";
                lsCategoryData.insert(0, extraCabItem);
                if (mounted) {
                  setState(() {});
                }
              }
            });
            //check already have order or not
            Future.delayed(Duration(seconds: 0), () async {
              if (controller.databaseService
                          .getFromDisk(DatabaseKeys.deliveryOrder) !=
                      null &&
                  controller.databaseService
                          .getFromDisk(DatabaseKeys.deliveryOrder) !=
                      "") {
                OrderModel data =
                    await controller.reCallOrderStatusFetch(context);
                Get.put(EstablishmentDetailsController()).storeDetailsData =
                    Establishments.fromJson(jsonDecode(controller
                        .databaseService
                        .getFromDisk(DatabaseKeys.establishmentObject)));

                final List<dynamic> jsonData = jsonDecode(controller
                        .databaseService
                        .getFromDisk(DatabaseKeys.cartObject) ??
                    '[]');
                List<ItemsCartModels>? cartItemList =
                    jsonData.map<ItemsCartModels>((jsonItem) {
                  return ItemsCartModels.fromJson(jsonItem);
                }).toList();

                // cartItemList[0].status==
                Get.put(EstablishmentDetailsController())
                    .cartItemList
                    ?.addAll(cartItemList);
                // print("data :: ${data.orderId}");
                // print("data :: ${data.deliveryStatus}");
                if (data.deliveryStatus == "new" ||
                    data.deliveryStatus == "accepted" ||
                    data.deliveryStatus == "paymentWait" ||
                    data.deliveryStatus == "notAccepted" ||
                    data.deliveryStatus == "canceledKitchen" ||
                    data.deliveryStatus == "cancelled" ||
                    data.deliveryStatus == "paid") {
                  Navigator.of(context)
                      .pushNamed(Routes.foodDeliveryShoppingCartView);
                } else {
                  controller.databaseService
                      .saveToDisk(DatabaseKeys.deliveryOrder, "");
                }
              }
              // controller.foodDeliveryOrder(context);
            });
          }

          if (authState is FetchingFoodDeliveryCategoryFailed) {
            if (authState.message.toString() == "Session expired") {
              Helpers.clearUser();

              dynamic workAddress = controller.databaseService
                  .getFromDisk(DatabaseKeys.userWorkAddress);
              dynamic homeAddress = controller.databaseService
                  .getFromDisk(DatabaseKeys.userHomeAddress);
              controller.cacheAddress["homeAddress"] = homeAddress;
              controller.cacheAddress["workAddress"] = workAddress;
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.foodHomeScreen, ModalRoute.withName('/'));
            } else {
              //check already have order or not
              Future.delayed(Duration(seconds: 0), () {
                if (controller.databaseService
                            .getFromDisk(DatabaseKeys.deliveryOrder) !=
                        null &&
                    controller.databaseService
                            .getFromDisk(DatabaseKeys.deliveryOrder) !=
                        '') {
                  Get.put(EstablishmentDetailsController()).storeDetailsData =
                      Establishments.fromJson(jsonDecode(controller
                          .databaseService
                          .getFromDisk(DatabaseKeys.establishmentObject)));

                  final List<dynamic> jsonData = jsonDecode(controller
                          .databaseService
                          .getFromDisk(DatabaseKeys.cartObject) ??
                      '[]');
                  List<ItemsCartModels>? cartItemList =
                      jsonData.map<ItemsCartModels>((jsonItem) {
                    return ItemsCartModels.fromJson(jsonItem);
                  }).toList();

                  Get.put(EstablishmentDetailsController()).cartItemList =
                      cartItemList;
                  // print("Cart Array 1 --> ${cartItemList}");

                  Navigator.of(context)
                      .pushNamed(Routes.foodDeliveryShoppingCartView);
                }
                // controller.foodDeliveryOrder(context);
              });
            }
          }
        }, builder: (context, authState) {
          return SafeArea(
            top: false,
            bottom: false,
            child: GetBuilder<HomeViewController>(
                builder: (_) => Scaffold(
                    resizeToAvoidBottomInset: false,
                    onDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    onEndDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    drawer: MyDrawer(
                      isEnable: true,
                    ),
                    key: _scaffoldDeliveryKey,
                    body: Stack(alignment: Alignment.center, children: [
                      Positioned(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 13.h, left: 8.0, right: 8.0),
                              decoration: BoxDecoration(
                                  color: AppThemes.foodBgColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: Color(0xffA4A4A4), width: 1.5)),
                              constraints: BoxConstraints(maxHeight: 76),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 40,
                                    child: Image.asset(
                                      AssetsPath.location,
                                      color: colorScheme.primary,
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
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 8.0),
                                            child: Text(
                                              language.where_to_deliver,
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      fontSize: 9.sp,
                                                      color: colorScheme
                                                          .secondary),
                                              maxLines: 3,
                                              softWrap: true,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0,
                                                top: 6.0,
                                                right: 4.0,
                                                bottom: 6.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              keyboardDismissBehavior:
                                                  ScrollViewKeyboardDismissBehavior
                                                      .onDrag,
                                              child: Text(
                                                controller
                                                    .displayDefaultAddress(
                                                        language),
                                                style: textTheme.bodyText1!
                                                    .copyWith(
                                                  fontSize: 12.sp,
                                                  color: colorScheme.background,
                                                ),
                                                softWrap: true,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Icon(Icons.arrow_forward_ios,
                                        size: 22, color: colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              await Get.toNamed(Routes.foodDeliveryAddressView);
                              //debugPrint("Result:::");
                              controller.update();
                            },
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 275,
                                          childAspectRatio: 3 / 2.8,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  shrinkWrap: true,
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  itemCount: lsCategoryData.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppThemes.foodBgColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        constraints:
                                            BoxConstraints(maxHeight: 275),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (lsCategoryData[index].imgUrl ==
                                                "gps_system_smart_car.png") ...[
                                              ClipRRect(
                                                child: Image.asset(
                                                  AssetsPath.callACabIcon,
                                                  width: double.infinity,
                                                  height: 95,
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0)),
                                              ),
                                            ] else ...[
                                              ClipRRect(
                                                child: Image.network(
                                                  '${lsCategoryData[index].imgUrl}',
                                                  width: double.infinity,
                                                  height: 95,
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0)),
                                              ),
                                            ],
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0,
                                                          right: 8.0,
                                                          left: 8.0),
                                                  child: Text(
                                                    (appLocale != null)
                                                        ? (appLocale ==
                                                                Locale('en'))
                                                            ? '${lsCategoryData[index].nameEn}'
                                                            : (appLocale ==
                                                                    Locale(
                                                                        'uk'))
                                                                ? '${lsCategoryData[index].nameUk}'
                                                                : (appLocale ==
                                                                        Locale(
                                                                            'ru'))
                                                                    ? '${lsCategoryData[index].nameRu}'
                                                                    : '${lsCategoryData[index].name}'
                                                        : "${lsCategoryData[index].name}",
                                                    style: textTheme.bodyText1!
                                                        .copyWith(
                                                            fontSize: 13.sp,
                                                            color:
                                                                Colors.white),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        _onTapped(index);
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      )),
                      Positioned(
                        top: 10,
                        left: 6,
                        child: SafeArea(
                          child: GestureDetector(
                            onTap: () {
                              if (authState
                                  is FetchingFoodDeliveryCategoryProgress) {
                                return;
                              }
                              //call api
                              controller.activeCounts();
                              _scaffoldDeliveryKey.currentState!.openDrawer();
                            },
                            child: Container(
                              child: Icon(
                                Icons.menu,
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
                        ),
                      ),
                      if (authState
                          is FetchingFoodDeliveryCategoryProgress) ...[
                        Center(
                          child: SizedBox(
                              height: 150,
                              width: 150,
                              child:
                                  Lottie.asset('assets/images/loading1.json')),
                        )
                      ],
                      if (controller.databaseService.getFromDisk(
                                  DatabaseKeys.activeOrderCounts) !=
                              null &&
                          controller.databaseService.getFromDisk(
                                  DatabaseKeys.activeOrderCounts) !=
                              "0") ...[
                        Positioned(
                          top: 0,
                          left: 26,
                          child: SafeArea(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              child: Container(
                                  height: 2.5.h,
                                  width: 2.5.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "${controller.databaseService.getFromDisk(DatabaseKeys.activeOrderCounts)}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 8.sp,
                                        fontFamily: AppConstants.fontFamily),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ]),
                    backgroundColor: Colors.black)),
          );
        });
      },
    );
  }

  void _onTapped(int index) async {
    if (index == 0) {
      controller.databaseService
          .saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.homeScreen, ModalRoute.withName('/'));
    } else {
      if (controller.databaseService
                  .getFromDisk(DatabaseKeys.saveDeliverAddress)
                  .toString() !=
              "null" &&
          controller.databaseService
              .getFromDisk(DatabaseKeys.saveDeliverAddress)
              .toString()
              .isNotEmpty) {
        var data = controller.databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress);
        var deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));
        if (deliverAddress.lat != null && deliverAddress.lon != null) {
          Navigator.pushNamed(context, Routes.foodDeliveryItemsScreen,
              arguments: lsCategoryData[index]);
          return;
        }
      }
      if (controller.isLocationEnable()) {
        await controller.checkLocationIfNeeded();
        await Get.toNamed(Routes.foodDeliveryAddressView);
        return;
      }
      if (controller.databaseService
                  .getFromDisk(DatabaseKeys.saveCurrentLat)
                  .toString() !=
              "null" &&
          controller.databaseService
              .getFromDisk(DatabaseKeys.saveCurrentLat)
              .toString()
              .isNotEmpty) {
        Navigator.pushNamed(context, Routes.foodDeliveryItemsScreen,
            arguments: lsCategoryData[index]);
        return;
      }
      await Get.toNamed(Routes.foodDeliveryAddressView);
      controller.update();
    }
  }

  @override
  void dispose() {
    controller.databaseService
        .saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
    Helpers.systemStatusBar();
    debugPrint("dispose()");
    super.dispose();
  }
}
