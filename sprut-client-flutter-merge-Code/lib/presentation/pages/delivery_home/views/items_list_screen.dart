import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_controller.dart';
import 'package:sprut/presentation/pages/delivery_home/views/type_item/item_filter_type_list.dart';
import 'package:sprut/presentation/widgets/cash_back_dialog/cash_back_dialog.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/configs/routes/routes.dart';

import '../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../data/models/food_category_models/food_category_list_models.dart';
import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../../../widgets/my_drawer/my_drawer.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../../no_internet/no_internet.dart';

class ItemsListScreenView extends StatefulWidget {
  FoodCategoryData _foodCategoryData = FoodCategoryData();

  @override
  State<ItemsListScreenView> createState() => _ItemsListScreenViewState();
}

class _ItemsListScreenViewState extends State<ItemsListScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeViewController controller =
      Get.put(HomeViewController(), permanent: true);

  EstablishmentController establishmentController =
      Get.put(EstablishmentController(), permanent: true);

  bool isdNoData = false;

  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration.zero, () async {
    //   setState(() {
    //     widget._foodCategoryData =
    //         ModalRoute.of(context)!.settings.arguments as FoodCategoryData;
    //
    //     // establishmentController.fetchingSaveAddress();
    //     // establishmentController.clearData();
    //     print("Cat--------->ID--------${widget._foodCategoryData.id.toString()}")
    //     establishmentController.fetchingItemList(context, widget._foodCategoryData.id.toString());
    //     establishmentController.update();
    //
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final args = ModalRoute.of(context)!.settings.arguments as FoodCategoryData;

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<EstablishmentController>(
        init: EstablishmentController(),
        initState: (_) {
            establishmentController.establishmentsData.clear();
            establishmentController.lsEstablishmentsData.clear();
        },
        builder: (context) {
          return BlocConsumer<ConnectedBloc, ConnectedState>(
            listener: (context, state) {
              // if (state is ConnectedFailureState) {
              //   showDialog(
              //       context: context,
              //       builder: (context) => MyCustomDialog(
              //             message: language.networkError,
              //           ));
              // }

              if (state is ConnectedInitialState) {
                debugPrint("ConnectedInitialState:::");
              }

              if (state is ConnectedSucessState) {
                print(
                    "--------------Delivery establishment screen ConnectedSucessState--------------");
                // Helpers.showCircularProgressDialog(context: context);
                // establishmentController.fetchingItemList(context, widget._foodCategoryData.id.toString());
              }
            },
            builder: (context, connectionState) {
              if (connectionState is ConnectedFailureState) {
                print(
                    "--------------Delivery establishment screen ConnectedFailureState--------------");
                return NoInternetScreen(onPressed: () async {
                  // establishmentController.fetchingItemList(context, widget._foodCategoryData.id.toString());
                });
              }

              return BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, authState) {
                if (authState is FetchingEstablishmentsListProgress) {
                  isdNoData = false;
                  debugPrint(
                      "FetchingEstablishmentsListProgress Loading Progress!");
                  // Helpers.showCircularProgressDialog(context: context);
                }

                if (authState is FetchingEstablishmentsListSucceed) {
                  // Navigator.pop(context);
                  debugPrint(
                      "FetchingEstablishmentsListSucceed Response Success!");

                  if (authState.availableEstablishmentsList!.isNotEmpty ==
                      true) {
                    isdNoData = false;
                    debugPrint("List Data Load!");
                    //add data
                    establishmentController.establishmentsData = authState.availableEstablishmentsList!;

                    debugPrint("Length ::" +
                        establishmentController.establishmentsData.length
                            .toString());

                    establishmentController.lsEstablishmentsData =
                        establishmentController.establishmentsData
                            .where((element) => element.enabled == true)
                            .toList();

                    debugPrint("After Filter Length ::" +
                        establishmentController.lsEstablishmentsData.length
                            .toString());

                    establishmentController.update();
                    // setState(() {});
                  } else {
                    isdNoData = true;
                    establishmentController.update();
                    // setState(() {});
                  }
                }

                if (authState is FetchingEstablishmentsListFailed) {
                  debugPrint("FetchingEstablishmentsListFailed!");
                  // Navigator.pop(context);
                  //check is session expired
                  if (authState.message.toString() == "Session expired") {
                    Helpers.clearUser();

                    dynamic workAddress = controller.databaseService
                        .getFromDisk(DatabaseKeys.userWorkAddress);
                    dynamic homeAddress = controller.databaseService
                        .getFromDisk(DatabaseKeys.userHomeAddress);
                    controller.cacheAddress["homeAddress"] = homeAddress;
                    controller.cacheAddress["workAddress"] = workAddress;
                    Navigator.pushNamedAndRemoveUntil(context,
                        Routes.foodHomeScreen, ModalRoute.withName('/'));
                  } else {
                    isdNoData = true;
                    establishmentController.update();
                  }
                }
              }, builder: (context, authState) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: GetBuilder<HomeViewController>(
                      initState: (_) {
                        if (establishmentController
                            .establishmentsData.isNotEmpty) {
                          establishmentController.establishmentsData.clear();
                          establishmentController.lsEstablishmentsData.clear();
                        }
                      },
                      builder: (_) => Scaffold(
                          resizeToAvoidBottomInset: false,
                          onDrawerChanged: (isOpened) {
                            print("drag left");
                            setState(() {});
                          },
                          onEndDrawerChanged: (isOpened) {
                            print("drag right");
                            setState(() {});
                          },
                          drawer: MyDrawer(
                            isEnable: true,
                          ),
                          key: _scaffoldKey,
                          body: GetBuilder<EstablishmentController>(
                              initState: (_) {
                                print(
                                    "Cat------------------->${args.id.toString()}");
                                establishmentController.fetchingItemList(
                                    context, args.id.toString());
                              },
                              builder:
                                  (_) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: GetPlatform.isAndroid
                                                          ? 11.h
                                                          : 12.h,
                                                      left: 8.0,
                                                      right: 8.0),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4.0, top: 8.0),
                                                    child: Text(
                                                      '${args.name}',
                                                      style: textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AppThemes
                                                                  .colorWhite),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    //open establishment search view
                                                    Navigator.of(context)
                                                        .pushNamed(Routes
                                                            .foodEstablishmentSearchView);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 8.0,
                                                        right: 8.0),
                                                    decoration: BoxDecoration(
                                                        color: AppThemes
                                                            .foodBgColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffA4A4A4),
                                                            width: 1.5)),
                                                    constraints: BoxConstraints(
                                                        maxHeight: 56),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 40,
                                                          child:
                                                              SvgPicture.asset(
                                                            AssetsPath
                                                                .searchIcon,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            // color: Colors.yellow,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      top: 6.0,
                                                                      right:
                                                                          4.0,
                                                                      bottom:
                                                                          6.0),
                                                              child: TextField(
                                                                style: textTheme.bodyText2!.copyWith(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: AppThemes
                                                                        .colorWhite,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none),
                                                                readOnly: true,
                                                                onTap: () {
                                                                  print(
                                                                      "Click Search text");
                                                                  //open establishment search view
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          Routes
                                                                              .foodEstablishmentSearchView);
                                                                },
                                                                decoration: new InputDecoration.collapsed(
                                                                    hintText:
                                                                        language
                                                                            .search,
                                                                    hintStyle: textTheme.bodyText2!.copyWith(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        color: AppThemes
                                                                            .lightGrey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        decoration:
                                                                            TextDecoration.none)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // if(establishmentController.lsFoodTypeData.isNotEmpty)...[
                                                  //filter view
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 8.0),
                                                    child: SizedBox(
                                                        height: establishmentController.lsFoodTypeData.isNotEmpty ? 95 : 0,
                                                        child:
                                                        ItemFilterTypeList()),
                                                  ),
                                                // ],
                                                if (establishmentController
                                                    .lsEstablishmentsData
                                                    .isNotEmpty) ...[
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          itemCount:
                                                              establishmentController
                                                                  .lsEstablishmentsData
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext ctx,
                                                                  index) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                debugPrint(
                                                                    "Click Of Items::");
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    Routes
                                                                        .foodDeliveryEstablishmentDetailsView,
                                                                    arguments: establishmentController
                                                                            .lsEstablishmentsData[
                                                                        index]);
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: AppThemes
                                                                            .foodBgColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15)),
                                                                    constraints:
                                                                        BoxConstraints(
                                                                            maxHeight:
                                                                                275),
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            24.0,
                                                                        top:
                                                                            16.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 16.0),
                                                                                child: Text(
                                                                                  '${establishmentController.lsEstablishmentsData[index].name}',
                                                                                  style: textTheme.bodyText1!.copyWith(fontSize: 13.sp, color: Colors.white),
                                                                                  textAlign: TextAlign.start,
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            if (establishmentController.lsEstablishmentsData[index].cashbackPercent! >
                                                                                0) ...[
                                                                              Expanded(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: AppThemes.cashBackCardBgColor, borderRadius: BorderRadius.circular(18)),
                                                                                  child: GestureDetector(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Container(
                                                                                            height: 15,
                                                                                            width: 15,
                                                                                            child: SvgPicture.asset(
                                                                                              AssetsPath.icAlertFull,
                                                                                            )),
                                                                                        Text(
                                                                                          " ${language.cashback} ${establishmentController.lsEstablishmentsData[index].cashbackPercent}% ",
                                                                                          style: textTheme.bodyText2!.copyWith(color: AppThemes.primary, fontSize: 11.sp),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    onTap: () {
                                                                                      debugPrint("click caseback");
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (context) => CashBackDialog(
                                                                                                message: language.networkError,
                                                                                              ));
                                                                                    },
                                                                                  ),
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                                                                                ),
                                                                              ),
                                                                            ]
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                        ),
                                                                        // Padding(
                                                                        //   padding: const EdgeInsets
                                                                        //       .only(
                                                                        //       top: 4.0,
                                                                        //       left: 16.0),
                                                                        //   child:
                                                                        //   Text(
                                                                        //     establishmentController
                                                                        //         .filterTypes(
                                                                        //         index),
                                                                        //     style:
                                                                        //     textTheme
                                                                        //         .bodySmall!
                                                                        //         .copyWith(
                                                                        //         fontSize: 11
                                                                        //             .sp,
                                                                        //         color: Color(
                                                                        //             0xff838383)),
                                                                        //     textAlign:
                                                                        //     TextAlign
                                                                        //         .start,
                                                                        //   ),
                                                                        // ),
                                                                        Stack(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 16.0),
                                                                              child: ClipRRect(
                                                                                child: Image.network(
                                                                                  '${establishmentController.lsEstablishmentsData[index].imgUrl}',
                                                                                  width: double.infinity,
                                                                                  height: 159,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(15.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            if (!establishmentController.isClosedStore(establishmentController.lsEstablishmentsData[index].openTime.toString(),
                                                                                establishmentController.lsEstablishmentsData[index].closeTime.toString())) ...[
                                                                              Positioned(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(color: AppThemes.cashBackCardBgColor, borderRadius: BorderRadius.circular(18)),
                                                                                  child: GestureDetector(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          " ${language.closed} ",
                                                                                          style: textTheme.bodyText2!.copyWith(color: AppThemes.primary, fontSize: 11.sp),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    onTap: () {},
                                                                                  ),
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                                                                                ),
                                                                                top: 10,
                                                                                left: 10,
                                                                              ),
                                                                            ]
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          color: AppThemes
                                                                              .foodBgColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(15)),
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              11,
                                                                          right:
                                                                              11),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              16.0,
                                                                          horizontal:
                                                                              8.0),
                                                                      constraints:
                                                                          BoxConstraints(
                                                                              minHeight: 45),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.transparent,
                                                                                border: Border.all(color: AppThemes.colorBorderLine, width: 0.5),
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            padding: EdgeInsets.only(
                                                                                top: 12.0,
                                                                                bottom: 12.0,
                                                                                left: 6.0,
                                                                                right: 6.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  height: 15,
                                                                                  width: 15,
                                                                                  child: SvgPicture.asset(
                                                                                    AssetsPath.storeLocation,
                                                                                  ),
                                                                                  margin: EdgeInsets.only(right: 3.0),
                                                                                ),
                                                                                Text("${establishmentController.lsEstablishmentsData[index].getDistance()} ${language.symbol_km}",
                                                                                    // Helpers
                                                                                    //     .distance(
                                                                                    //     establishmentController
                                                                                    //         .deliverAddress.lat !=
                                                                                    //         null
                                                                                    //         ? establishmentController
                                                                                    //         .deliverAddress
                                                                                    //         .lat!
                                                                                    //         .toDouble()
                                                                                    //         : controller
                                                                                    //         .databaseService
                                                                                    //         .getFromDisk(
                                                                                    //         DatabaseKeys
                                                                                    //             .defaultLatitude),
                                                                                    //     establishmentController
                                                                                    //         .deliverAddress.lon !=
                                                                                    //         null
                                                                                    //         ? establishmentController
                                                                                    //         .deliverAddress
                                                                                    //         .lon!
                                                                                    //         .toDouble()
                                                                                    //         : controller
                                                                                    //         .databaseService
                                                                                    //         .getFromDisk(
                                                                                    //         DatabaseKeys
                                                                                    //             .defaultLongitude),
                                                                                    //     double
                                                                                    //         .parse(
                                                                                    //         establishmentController
                                                                                    //             .lsEstablishmentsData[index]
                                                                                    //             .place!
                                                                                    //             .latitude
                                                                                    //             .toString()),
                                                                                    //     double
                                                                                    //         .parse(
                                                                                    //         establishmentController
                                                                                    //             .lsEstablishmentsData[index]
                                                                                    //             .place!
                                                                                    //             .longitude
                                                                                    //             .toString()),
                                                                                    //     'K') +
                                                                                    //     "km",
                                                                                    style: textTheme.bodyText1!.copyWith(color: AppThemes.colorWhite, fontSize: 11.sp)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          // if (controller
                                                                          //     .getLocationState() ==
                                                                          //     locationState
                                                                          //         .NoPermission_NoService ||
                                                                          //     controller
                                                                          //         .getLocationState() ==
                                                                          //         locationState
                                                                          //             .NoPermission_Service ||
                                                                          //     controller
                                                                          //         .getLocationState() ==
                                                                          //         locationState
                                                                          //             .Permission_NoService) ...[
                                                                          //   SizedBox()
                                                                          // ] else
                                                                          //   ...[
                                                                          //     Container(
                                                                          //       decoration: BoxDecoration(
                                                                          //           color: Colors
                                                                          //               .transparent,
                                                                          //           border: Border
                                                                          //               .all(
                                                                          //               color: AppThemes
                                                                          //                   .colorBorderLine,
                                                                          //               width: 0.5),
                                                                          //           borderRadius: BorderRadius
                                                                          //               .circular(
                                                                          //               10)),
                                                                          //       padding: EdgeInsets
                                                                          //           .only(
                                                                          //           top: 12.0,
                                                                          //           bottom: 12.0,
                                                                          //           left: 6.0,
                                                                          //           right: 6.0),
                                                                          //       child: Row(
                                                                          //         children: [
                                                                          //           Container(
                                                                          //             height: 15,
                                                                          //             width: 15,
                                                                          //             child: SvgPicture
                                                                          //                 .asset(
                                                                          //               AssetsPath
                                                                          //                   .storeLocation,
                                                                          //             ),
                                                                          //             margin: EdgeInsets
                                                                          //                 .only(
                                                                          //                 right: 3.0),
                                                                          //           ),
                                                                          //           Text(
                                                                          //               "${establishmentController.lsEstablishmentsData[index].distance.toString()} ${language.symbol_km}",
                                                                          //               // Helpers
                                                                          //               //     .distance(
                                                                          //               //     establishmentController
                                                                          //               //         .deliverAddress.lat !=
                                                                          //               //         null
                                                                          //               //         ? establishmentController
                                                                          //               //         .deliverAddress
                                                                          //               //         .lat!
                                                                          //               //         .toDouble()
                                                                          //               //         : controller
                                                                          //               //         .databaseService
                                                                          //               //         .getFromDisk(
                                                                          //               //         DatabaseKeys
                                                                          //               //             .defaultLatitude),
                                                                          //               //     establishmentController
                                                                          //               //         .deliverAddress.lon !=
                                                                          //               //         null
                                                                          //               //         ? establishmentController
                                                                          //               //         .deliverAddress
                                                                          //               //         .lon!
                                                                          //               //         .toDouble()
                                                                          //               //         : controller
                                                                          //               //         .databaseService
                                                                          //               //         .getFromDisk(
                                                                          //               //         DatabaseKeys
                                                                          //               //             .defaultLongitude),
                                                                          //               //     double
                                                                          //               //         .parse(
                                                                          //               //         establishmentController
                                                                          //               //             .lsEstablishmentsData[index]
                                                                          //               //             .place!
                                                                          //               //             .latitude
                                                                          //               //             .toString()),
                                                                          //               //     double
                                                                          //               //         .parse(
                                                                          //               //         establishmentController
                                                                          //               //             .lsEstablishmentsData[index]
                                                                          //               //             .place!
                                                                          //               //             .longitude
                                                                          //               //             .toString()),
                                                                          //               //     'K') +
                                                                          //               //     "km",
                                                                          //               style: textTheme
                                                                          //                   .bodyText1!
                                                                          //                   .copyWith(
                                                                          //                   color: AppThemes
                                                                          //                       .colorWhite,
                                                                          //                   fontSize: 11
                                                                          //                       .sp)),
                                                                          //         ],
                                                                          //       ),
                                                                          //     ),
                                                                          //   ],
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.transparent,
                                                                                border: Border.all(color: AppThemes.colorBorderLine, width: 0.5),
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            margin:
                                                                                EdgeInsets.only(left: 8.0, right: 8.0),
                                                                            padding: EdgeInsets.only(
                                                                                top: 12.0,
                                                                                bottom: 12.0,
                                                                                left: 6.0,
                                                                                right: 6.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                    child: SvgPicture.asset(
                                                                                      AssetsPath.storeCar,
                                                                                    )),
                                                                                Text(" ${establishmentController.lsEstablishmentsData[index].calculatedPrice.toString()} ${language.currency_symbol}", style: textTheme.bodyText1!.copyWith(color: AppThemes.colorWhite, fontSize: 11.sp)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.transparent,
                                                                                border: Border.all(color: AppThemes.colorBorderLine, width: 0.5),
                                                                                borderRadius: BorderRadius.circular(10)),
                                                                            padding: EdgeInsets.only(
                                                                                top: 12.0,
                                                                                bottom: 12.0,
                                                                                left: 6.0,
                                                                                right: 6.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                    height: 15,
                                                                                    width: 15,
                                                                                    child: SvgPicture.asset(
                                                                                      AssetsPath.storeTimer,
                                                                                    )),
                                                                                Text(
                                                                                  " ${establishmentController.lsEstablishmentsData[index].deliveryTime?.roundToDouble().toPrecision(0).round()} ${language.symbol_min}",
                                                                                  //?.toPrecision(0)
                                                                                  style: textTheme.bodyText1!.copyWith(color: AppThemes.colorWhite, fontSize: 11.sp),
                                                                                  softWrap: true,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                      ),
                                                                    ),
                                                                    bottom: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                  ),
                                                                  // Positioned(
                                                                  //   child:
                                                                  //   Container(
                                                                  //     decoration: BoxDecoration(
                                                                  //         color: AppThemes
                                                                  //             .cashBackCardBgColor,
                                                                  //         borderRadius:
                                                                  //         BorderRadius
                                                                  //             .circular(
                                                                  //             18)),
                                                                  //     child:
                                                                  //     GestureDetector(
                                                                  //       child:
                                                                  //       Row(
                                                                  //         mainAxisAlignment:
                                                                  //         MainAxisAlignment
                                                                  //             .start,
                                                                  //         children: [
                                                                  //           Container(
                                                                  //               height: 15,
                                                                  //               width: 15,
                                                                  //               child: SvgPicture
                                                                  //                   .asset(
                                                                  //                 AssetsPath
                                                                  //                     .icAlertFull,
                                                                  //               )),
                                                                  //           Text(
                                                                  //             " Cashback 30%",
                                                                  //             style: textTheme
                                                                  //                 .bodyText2!
                                                                  //                 .copyWith(
                                                                  //                 color: AppThemes
                                                                  //                     .primary,
                                                                  //                 fontSize: 11
                                                                  //                     .sp),
                                                                  //           ),
                                                                  //         ],
                                                                  //       ),
                                                                  //       onTap:
                                                                  //           () {
                                                                  //         debugPrint(
                                                                  //             "click caseback");
                                                                  //         showDialog(
                                                                  //             context: context,
                                                                  //             builder: (
                                                                  //                 context) =>
                                                                  //                 CashBackDialog(
                                                                  //                   message: language
                                                                  //                       .networkError,
                                                                  //                 ));
                                                                  //       },
                                                                  //     ),
                                                                  //     padding:
                                                                  //     EdgeInsets
                                                                  //         .all(
                                                                  //         8.0),
                                                                  //   ),
                                                                  //   right: 10,
                                                                  //   top: 35,
                                                                  // )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ] else ...[
                                                  if (isdNoData) ...[
                                                    Expanded(
                                                        child: Center(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            child: SvgPicture
                                                                .asset(
                                                              AssetsPath
                                                                  .saidSmileFaceWhite,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    bottom: 8.0,
                                                                    left: 24.0,
                                                                    right:
                                                                        24.0),
                                                            child: Text(language.error_of_no_found_establishment,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textTheme.bodyText1!.copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontFamily:
                                                                        AppConstants
                                                                            .fontFamily,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppThemes
                                                                        .colorWhite)),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ],
                                                ],
                                                //Listing View
                                              ],
                                            )),
                                            Positioned(
                                              top: 10,
                                              right: 6,
                                              child: SafeArea(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _scaffoldKey.currentState!
                                                        .openDrawer();
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
                                                        color:
                                                            colorScheme.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 6,
                                              child: SafeArea(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    //close screen
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
                                                        color:
                                                            colorScheme.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (authState
                                            is FetchingEstablishmentsListProgress) ...[
                                              Center(
                                                child: SizedBox(
                                                    height: 150,
                                                    width: 150,
                                                    child:
                                                    Lottie.asset('assets/images/loading1.json')),
                                              )
                                            ],//back button
                                          ])),
                          backgroundColor: Colors.black)),
                );
              });
            },
          );
        });
  }
}
