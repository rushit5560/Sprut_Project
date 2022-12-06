import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';
import 'package:sprut/presentation/pages/delivery_home/views/establishment_details_view/product_item_ui.dart';

import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../../resources/configs/routes/routes.dart';
import '../../../../widgets/cash_back_dialog/cash_back_dialog.dart';

class StoreItemDetailsUi extends GetView<EstablishmentDetailsController> {




  @override
  Widget build(BuildContext context) {
    // _homeViewController.checkLocationIfNeeded();
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return SafeArea(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 54.h,
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        controller.isShowData
                            ? "${controller.storeDetailsData.imgUrl.toString()}"
                            : "",
                        height: 325,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                (MediaQuery.of(context).size.height <= 1334) ?
                Padding(
                  padding: const EdgeInsets.only(top: 172.0),
                  child: Container(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppThemes.foodBgColor,
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 11, right: 11),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      constraints: BoxConstraints(maxHeight: 250),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppThemes.foodBgColor,
                                borderRadius: BorderRadius.circular(15)),
                            constraints: BoxConstraints(minHeight: 75),
                            margin: EdgeInsets.only(
                                bottom: 8.0, top: 8.0, left: 12.0, right: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppThemes.cashBackCardBgColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            " ${language.minimum_delivery_order_placeholder_message} ${controller.storeDetailsData.minimalPrice} ${language.currency_symbol}",
                                            style: textTheme.bodyText2!.copyWith(
                                                color: AppThemes.offWhiteColor,
                                                fontSize: 10.sp),
                                            softWrap: true,
                                            maxLines: 2,
                                          ),
                                          Container(
                                              height: 15,
                                              width: 15,
                                              margin: EdgeInsets.only(left: 4.0),
                                              child: SvgPicture.asset(
                                                AssetsPath.icAlertFull,
                                              )),
                                        ],
                                      ),
                                      onTap: () async{
                                        print("Minimum Amount open dialog....");
                                        await controller.onViewCart(context);
                                      },
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16.0,
                                    ),
                                    child: Text(
                                      '${controller.storeDetailsData.name}',
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 13.sp, color: Colors.white),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ],
                            ),
                          ),
                          if (controller.storeDetailsData.cashbackPercent! >
                              0) ...[
                            GestureDetector(
                              child: Container(

                                margin: EdgeInsets.only(
                                    bottom: 8.0, left: 12.0, right: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 15,
                                        width: 15,
                                        child: SvgPicture.asset(
                                          AssetsPath.icAlertFull,
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Text(
                                      "${language.cashback} ${controller.storeDetailsData.cashbackPercent}%",
                                      style: textTheme.bodyText2!.copyWith(
                                          color: AppThemes.primary,
                                          fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                debugPrint("click cashback");
                                showDialog(
                                    context: context,
                                    builder: (context) => CashBackDialog(
                                          message: language.networkError,
                                        ));
                              },
                            )
                          ],
                          Divider(
                            thickness: 1,
                            indent: 16.0,
                            endIndent: 16.0,
                            color: AppThemes.cashBackCardBgColor,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 12.0,
                                      left: 6.0,
                                      right: 6.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        child: SvgPicture.asset(
                                          AssetsPath.storeLocation,
                                        ),
                                        margin: EdgeInsets.only(right: 3.0),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      controller.isShowData
                                          ? Text(
                                              '${controller.storeDetailsData.getDistance()} ${language.symbol_km}',
                                              style: textTheme.bodyText1!
                                                  .copyWith(
                                                      color: AppThemes.colorWhite,
                                                      fontSize: 11.sp),
                                            )
                                          : Text("0.00"),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: AppThemes.colorBorderLine,
                                  thickness: 1,
                                  endIndent: 16.0,
                                  indent: 16.0,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                                  padding: EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 12.0,
                                      left: 6.0,
                                      right: 6.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 15,
                                          width: 15,
                                          child: SvgPicture.asset(
                                            AssetsPath.storeCar,
                                          )),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                          " ${controller.storeDetailsData.calculatedPrice} ${language.currency_symbol}",
                                          style: textTheme.bodyText1!.copyWith(
                                              color: AppThemes.colorWhite,
                                              fontSize: 11.sp)),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: AppThemes.colorBorderLine,
                                  thickness: 1,
                                  endIndent: 16.0,
                                  indent: 16.0,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 12.0,
                                      bottom: 12.0,
                                      left: 6.0,
                                      right: 6.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 15,
                                          width: 15,
                                          child: SvgPicture.asset(
                                            AssetsPath.storeTimer,
                                          )),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        " ${controller.storeDetailsData.deliveryTime?.roundToDouble().toPrecision(0).round()} ${language.symbol_min}",
                                        style: textTheme.bodyText1!.copyWith(
                                            color: AppThemes.colorWhite,
                                            fontSize: 11.sp),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                controller.isShowData
                                    ? Text(
                                  '${language.working_hours} ${controller.storeDetailsData.openTime} - ${controller.storeDetailsData.closeTime}',
                                  style: textTheme.bodyText1!
                                      .copyWith(
                                      color: AppThemes.colorWhite,
                                      fontSize: 11.sp),
                                )
                                    : Text("0.00"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // top: 31.h,
                    // left: 0,
                    // right: 0,
                  ),
                ):
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppThemes.foodBgColor,
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.only(left: 11, right: 11),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    constraints: BoxConstraints(maxHeight: 250),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppThemes.foodBgColor,
                              borderRadius: BorderRadius.circular(15)),
                          constraints: BoxConstraints(minHeight: 75),
                          margin: EdgeInsets.only(
                              bottom: 8.0, top: 8.0, left: 12.0, right: 12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppThemes.cashBackCardBgColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          " ${language.minimum_delivery_order_placeholder_message} ${controller.storeDetailsData.minimalPrice} ${language.currency_symbol}",
                                          style: textTheme.bodyText2!.copyWith(
                                              color: AppThemes.offWhiteColor,
                                              fontSize: 10.sp),
                                          softWrap: true,
                                          maxLines: 2,
                                        ),
                                        Container(
                                            height: 15,
                                            width: 15,
                                            margin: EdgeInsets.only(left: 4.0),
                                            child: SvgPicture.asset(
                                              AssetsPath.icAlertFull,
                                            )),
                                      ],
                                    ),
                                    onTap: () async{
                                      print("Minimum Amount open dialog....");
                                      await controller.onViewCart(context);
                                    },
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                ),
                                alignment: Alignment.center,
                              ),
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                  ),
                                  child: Text(
                                    '${controller.storeDetailsData.name}',
                                    style: textTheme.bodyText1!.copyWith(
                                        fontSize: 13.sp, color: Colors.white),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                        if (controller.storeDetailsData.cashbackPercent! >
                            0) ...[
                          GestureDetector(
                            child: Container(

                              margin: EdgeInsets.only(
                                  bottom: 8.0, left: 12.0, right: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                        AssetsPath.icAlertFull,
                                      )),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    "${language.cashback} ${controller.storeDetailsData.cashbackPercent}%",
                                    style: textTheme.bodyText2!.copyWith(
                                        color: AppThemes.primary,
                                        fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              debugPrint("click cashback");
                              showDialog(
                                  context: context,
                                  builder: (context) => CashBackDialog(
                                        message: language.networkError,
                                      ));
                            },
                          )
                        ],
                        Divider(
                          thickness: 1,
                          indent: 16.0,
                          endIndent: 16.0,
                          color: AppThemes.cashBackCardBgColor,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                    left: 6.0,
                                    right: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 15,
                                      child: SvgPicture.asset(
                                        AssetsPath.storeLocation,
                                      ),
                                      margin: EdgeInsets.only(right: 3.0),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    controller.isShowData
                                        ? Text(
                                            '${controller.storeDetailsData.getDistance()} ${language.symbol_km}',
                                            style: textTheme.bodyText1!
                                                .copyWith(
                                                    color: AppThemes.colorWhite,
                                                    fontSize: 11.sp),
                                          )
                                        : Text("0.00"),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: AppThemes.colorBorderLine,
                                thickness: 1,
                                endIndent: 16.0,
                                indent: 16.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                                padding: EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                    left: 6.0,
                                    right: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                        height: 15,
                                        width: 15,
                                        child: SvgPicture.asset(
                                          AssetsPath.storeCar,
                                        )),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                        " ${controller.storeDetailsData.calculatedPrice} ${language.currency_symbol}",
                                        style: textTheme.bodyText1!.copyWith(
                                            color: AppThemes.colorWhite,
                                            fontSize: 11.sp)),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: AppThemes.colorBorderLine,
                                thickness: 1,
                                endIndent: 16.0,
                                indent: 16.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                    left: 6.0,
                                    right: 6.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 15,
                                        width: 15,
                                        child: SvgPicture.asset(
                                          AssetsPath.storeTimer,
                                        )),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      " ${controller.storeDetailsData.deliveryTime?.roundToDouble().toPrecision(0).round()} ${language.symbol_min}",
                                      style: textTheme.bodyText1!.copyWith(
                                          color: AppThemes.colorWhite,
                                          fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              controller.isShowData
                                  ? Text(
                                '${language.working_hours} ${controller.storeDetailsData.openTime} - ${controller.storeDetailsData.closeTime}',
                                style: textTheme.bodyText1!
                                    .copyWith(
                                    color: AppThemes.colorWhite,
                                    fontSize: 11.sp),
                              )
                                  : Text("0.00"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  top: 31.h,
                  left: 0,
                  right: 0,
                ),
                GestureDetector(
                  onTap: () {
                    //open establishment search view
                    Navigator.of(
                        context)
                        .pushNamed(
                        Routes
                            .foodProductsSearchView);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 7.5.h,
                        left: 8.0,
                        right: 8.0),
                    decoration: BoxDecoration(
                        color:
                        AppThemes.foodBgColor,
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(
                                8)),
                        border: Border.all(
                            color:
                            Color(0xffA4A4A4),
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
                          child: SvgPicture.asset(
                            AssetsPath.searchIcon,
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
                                  right: 4.0,
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
                                  Navigator.of(
                                      context)
                                      .pushNamed(
                                      Routes
                                          .foodProductsSearchView);
                                },
                                decoration: new InputDecoration.collapsed(
                                    hintText:
                                    language
                                        .enter_your_product_name,
                                    hintStyle: textTheme.bodyText2!.copyWith(
                                        fontSize:
                                        12.sp,
                                        color: AppThemes
                                            .lightGrey,
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        decoration:
                                        TextDecoration
                                            .none)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!controller.isClosedStore(controller.storeDetailsData.openTime.toString(),
                    controller.storeDetailsData.closeTime.toString())) ...[
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
                    top: 15.h,
                    left: 10,
                  ),
                ]
              ],
            ),
          ),
          GroupedListView<ProductItems, String>(
            shrinkWrap: true,
            key: Key("List"),
            elements: controller.productList ?? [],
            groupBy: (element) => (element.section?.id ?? 0).toString(),
            groupHeaderBuilder: (item) {
              var count = controller.productList
                      ?.where(
                          (element) => element.section?.id == item.section?.id)
                      .length ??
                  0;
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                  child: Text(
                    (item.section?.name ?? "") + " ($count)",
                    style: textTheme.bodyText2!.copyWith(
                        color: AppThemes.colorWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                    softWrap: true,
                    maxLines: 2,
                  ),
                ),
              );
            },
            itemBuilder: (context, dynamic element) => Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
              child: GestureDetector(
                child: ProductItemUi(element, false),
                onTap: () async {
                  print("Go To Details");
                  controller.tempItems = element;
                  Navigator.pushNamed(
                      context, Routes.foodDeliveryProductItemDetailsView,
                      arguments: element);

                },
              ),
            ),
            floatingHeader: true,
          ),
          if (controller.cartItemList?.isNotEmpty == true) ...[
            SizedBox(
              height: 56,
            )
          ]
        ],
      ),
    ));
  }


}
