import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../resources/configs/routes/routes.dart';
import '../../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../../widgets/custom_dialog/custom_dialog.dart';
import '../../../../widgets/primary_container/primary_container.dart';
import '../../../no_internet/no_internet.dart';
import '../../controller/establishment_controller.dart';

class EstablishmentSearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EstablishmentSearchStateView();
}

class EstablishmentSearchStateView extends State<EstablishmentSearchView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EstablishmentController controller =
      Get.put(EstablishmentController(), permanent: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return GetBuilder<EstablishmentController>(
        init: EstablishmentController(),
        initState: (_) {
          controller.isNoDataFound = false;
          controller.isSearchView = false;
        },
        builder: (context) {
          return BlocConsumer<ConnectedBloc, ConnectedState>(
            listener: (context, state) {
              if (state is ConnectedInitialState) {
                debugPrint("ConnectedInitialState:::");
              }
            },
            builder: (context, connectionState) {
              if (connectionState is ConnectedFailureState) {
                print("BlocConsumer 2");
                return NoInternetScreen(onPressed: () async {});
              }
              if (connectionState is ConnectedSucessState) {}

              return WillPopScope(
                onWillPop: () {
                  controller.emptySearchData();
                    return Future.value(true);
                },
                child: SafeArea(
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    onDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      titleSpacing: 0.0,
                      toolbarHeight: 56,
                      title: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                            color: AppThemes.foodBgColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border:
                                Border.all(color: Color(0xffA4A4A4), width: 1.5)),
                        constraints: BoxConstraints(
                          maxHeight: 5.5.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 40,
                              child: SvgPicture.asset(
                                AssetsPath.searchIcon,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // color: Colors.yellow,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0,
                                      top: 6.0,
                                      right: 4.0,
                                      bottom: 6.0),
                                  child: TextField(
                                    style: textTheme.bodyText2!.copyWith(
                                        fontSize: 12.sp,
                                        color: AppThemes.colorWhite,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.none),
                                    readOnly: false,
                                    controller: controller
                                        .searchEstablishmentEditingController,
                                    onTap: () {},
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        controller.isSearchView = true;
                                      } else {
                                        controller.isSearchView = false;
                                        controller.searchEstablishmentEditingController.clear();
                                        controller.onSearchTextChanged("");
                                        controller.isNoDataFound = false;
                                        controller.update();
                                      }
                                      controller.update();
                                    },
                                    decoration: InputDecoration(
                                        hintText: language.search,
                                        hintStyle: textTheme.bodyText2!.copyWith(
                                            fontSize: 12.sp,
                                            color: AppThemes.lightGrey,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none),
                                        labelStyle: textTheme.bodyText2!.copyWith(
                                            fontSize: 12.sp,
                                            color: AppThemes.colorWhite,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 12.0),
                                        suffixIcon: controller.isSearchView
                                            ? IconButton(
                                                onPressed: () {
                                                  controller.searchEstablishmentEditingController.clear();
                                                  controller.onSearchTextChanged("");
                                                  controller.isNoDataFound = false;
                                                  controller.update();
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),padding: EdgeInsets.only(bottom: 0.0),)
                                            : null),
                                    textAlignVertical: TextAlignVertical.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryContainer(
                          child: IconButton(
                            onPressed: () {
                             controller.emptySearchData();
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onEndDrawerChanged: (isOpened) {
                      setState(() {});
                    },
                    key: _scaffoldKey,
                    body: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (controller.searchEstablishmentEditingController.text.isNotEmpty) {
                                    controller.onSearchTextChanged(controller.searchEstablishmentEditingController.text.toString());
                                    // controller.isNoDataFound = true;
                                    // controller.update();
                                  }
                                },
                                child: Text(
                                  language.simple_search,
                                  style: TextStyle(
                                      color: AppThemes.colorWhite,
                                      fontSize: 12.sp,
                                      fontFamily: AppConstants.fontFamily,
                                      fontWeight: FontWeight.w400),
                                ),
                                style: ButtonStyle(
                                  minimumSize:
                                  MaterialStateProperty.all(Size(107.0, 6.h)),
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      colorScheme.primary),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: AppThemes.darkGrey
                                              .withOpacity(0.3)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              child: Text(
                                language.placeholder_message_of_search,
                                style: textTheme.bodyText1!.copyWith(
                                    fontSize: 10.sp,
                                    color: Helpers.secondaryTextColor(),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          // if (!controller.isNoDataFound) ...[
                          //
                          // ],
                          if (controller.searchListData.isNotEmpty) ...[
                            Container(
                              padding:
                              EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  itemCount:
                                  controller
                                      .searchListData
                                      .length,
                                  itemBuilder:
                                      (BuildContext ctx,
                                      index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        debugPrint("Click Of Items::");
                                        Navigator.pushNamed(
                                            context,
                                            Routes
                                                .foodDeliveryEstablishmentDetailsView,
                                            arguments: controller
                                                .searchListData[index]);
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
                                                          (appLocale == Locale('en'))
                                                              ? '${controller.searchListData[index].name}'
                                                              : (appLocale == Locale('uk'))
                                                              ? '${controller.searchListData[index].nameUk}'
                                                              : (appLocale == Locale('ru'))
                                                              ? '${controller.searchListData[index].nameRu}'
                                                              : '${controller.searchListData[index].name}',
                                                          style: textTheme.bodyText1!.copyWith(fontSize: 13.sp, color: Colors.white),
                                                          textAlign: TextAlign.start,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    if (controller.searchListData[index].cashbackPercent! >
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
                                                                  " ${language.cashback} ${controller.searchListData[index].cashbackPercent}% ",
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
                                                //     controller
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
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 16.0),
                                                  child:
                                                  ClipRRect(
                                                    child:
                                                    Image.network(
                                                      '${controller.searchListData[index].imgUrl}',
                                                      width: double.infinity,
                                                      height: 159,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                  ),
                                                ),
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
                                                        Text("${controller.searchListData[index].getDistance()} ${language.symbol_km}",
                                                            // Helpers
                                                            //     .distance(
                                                            //     controller
                                                            //         .deliverAddress.lat !=
                                                            //         null
                                                            //         ? controller
                                                            //         .deliverAddress
                                                            //         .lat!
                                                            //         .toDouble()
                                                            //         : controller
                                                            //         .databaseService
                                                            //         .getFromDisk(
                                                            //         DatabaseKeys
                                                            //             .defaultLatitude),
                                                            //     controller
                                                            //         .deliverAddress.lon !=
                                                            //         null
                                                            //         ? controller
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
                                                            //         controller
                                                            //             .searchListData[index]
                                                            //             .place!
                                                            //             .latitude
                                                            //             .toString()),
                                                            //     double
                                                            //         .parse(
                                                            //         controller
                                                            //             .searchListData[index]
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
                                                  //               "${controller.searchListData[index].distance.toString()} ${language.symbol_km}",
                                                  //               // Helpers
                                                  //               //     .distance(
                                                  //               //     controller
                                                  //               //         .deliverAddress.lat !=
                                                  //               //         null
                                                  //               //         ? controller
                                                  //               //         .deliverAddress
                                                  //               //         .lat!
                                                  //               //         .toDouble()
                                                  //               //         : controller
                                                  //               //         .databaseService
                                                  //               //         .getFromDisk(
                                                  //               //         DatabaseKeys
                                                  //               //             .defaultLatitude),
                                                  //               //     controller
                                                  //               //         .deliverAddress.lon !=
                                                  //               //         null
                                                  //               //         ? controller
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
                                                  //               //         controller
                                                  //               //             .searchListData[index]
                                                  //               //             .place!
                                                  //               //             .latitude
                                                  //               //             .toString()),
                                                  //               //     double
                                                  //               //         .parse(
                                                  //               //         controller
                                                  //               //             .searchListData[index]
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
                                                        Text(" ${controller.searchListData[index].calculatedPrice.toString()} ${language.currency_symbol}", style: textTheme.bodyText1!.copyWith(color: AppThemes.colorWhite, fontSize: 11.sp)),
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
                                                          " ${controller.searchListData[index].deliveryTime?.roundToDouble().toPrecision(0).round()} ${language.symbol_min}",
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
                          ]else...[
                            if(controller.isNoDataFound)...[
                              Container(
                                height: MediaQuery.of(context).size.height - 22.h,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        child: SvgPicture.asset(
                                          AssetsPath.saidSmileFaceWhite,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 24.0,
                                            right: 24.0),
                                        child: controller.textMaker(
                                            context,
                                            language
                                                .empty_find_establishment_search,
                                            " ${controller.searchEstablishmentEditingController.text} ", "", "primary"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ],
                      ),
                    ),
                    backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
                  ),
                ),
              );
            },
          );
        });
  }
}

/*

Sorry, we didn't find any orders or products that match "vbjgvhjgvtvh".
You can change the value and try again.

* */
