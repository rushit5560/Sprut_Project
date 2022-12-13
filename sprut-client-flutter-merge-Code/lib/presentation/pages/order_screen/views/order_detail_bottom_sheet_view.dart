import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';

import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../widgets/custom_dialog/widget_dialog.dart';
import '../controllers/order_controller.dart';

class OrderDetailBottomSheetView extends GetView<OrderController> {
  final sc;

  OrderDetailBottomSheetView(this.sc);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();
    debugPrint("OrderDetailBottomSheetView ${Helpers.isLoginTypeIn()}");
    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Obx(() {
            return SizedBox(height: controller.isExpanded.value ? 30 : 8);
          }),
          SizedBox(
            height: 5,
            width: 50,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colorScheme.primary),
            ),
          ),
          SizedBox(height: 8),
          if (controller.orderInfoDetails.value != null) ...[
            Text(
              ('${controller.orderInfoDetails.value?.establishment?.name}' ==
                  language.all)
                  ? '${language.all}'
                  : (appLocale == Locale('en'))
                  ? '${controller.orderInfoDetails.value?.establishment?.nameEn}'
                  : (appLocale == Locale('uk'))
                  ? '${controller.orderInfoDetails.value?.establishment?.nameUk}'
                  : (appLocale == Locale('ru'))
                  ? '${controller.orderInfoDetails.value?.establishment?.nameRu}'
                  : '${controller.orderInfoDetails.value?.establishment?.name}',
              // '${controller.orderInfoDetails.value?.establishment?.name.toString()}',
              style: textTheme.bodyText1!.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
          if (controller.isMapView == false &&
              controller.orderInfoDetails.value != null) ...[
            SizedBox(height: 8),
            Text(
              controller.orderInfoDetails.value?.createdAt == null
                  ? ""
                  : "${language.order_date} ${Helpers.orderCreatedDate(context, controller.orderInfoDetails.value?.createdAt, language.today_at)}",
              style: textTheme.bodySmall!
                  .copyWith(fontSize: 9.sp, color: Color(0xff838383)),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Expanded(
              child: SingleChildScrollView(
            controller: sc,
            child: Column(
              children: [
                if (controller.orderInfoDetails.value != null) ...[
                  Container(
                    margin: EdgeInsets.all(8),
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        controller.isMapView
                            ? Text(
                                "${language.txt_order_courier_on_the_way}",
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              )
                            : Text(
                                controller.orderInfoDetails.value?.car !=
                                            null &&
                                        controller.orderInfoDetails.value
                                                    ?.status !=
                                                "cancelled" &&
                                            controller.orderInfoDetails.value
                                                    ?.status !=
                                                "searching"
                                    ? '${Helpers.getOrderStatusByDeliveryStatus(context, '${controller.orderInfoDetails.value?.status}', language)}'
                                    : '${Helpers.getOrderStatusByDeliveryStatus(context, '${controller.orderInfoDetails.value?.deliveryStatus}', language)}',
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                        // Text(controller.orderInfoDetails.value?.status != "cancelled" && controller.orderInfoDetails.value?.status  != "searching"
                        //       ? '${Helpers.getOrderStatusByDeliveryStatus(
                        //       context, '${controller.orderInfoDetails.value?.status}', language)}'
                        //       : "${language.txt_order_courier_on_the_way}",
                        //   style: textTheme.bodyText1!.copyWith(
                        //     fontSize: 16.sp,
                        //     color: Colors.white,
                        //   ),
                        //   textAlign: TextAlign.start,
                        // ),
                        SizedBox(height: 4),
                        Text(
                          "${Helpers.getTimeDelivery(context, controller.orderInfoDetails.value?.createdAt, controller.orderInfoDetails.value?.establishment?.deliveryTime)}",
                          //here time show${language.min}
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 16.sp,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${language.estimated_delivery_time}",
                          style: textTheme.bodySmall!.copyWith(
                              fontSize: 9.sp, color: Color(0xffAAAAAA)),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppThemes.colorBorderLine)),
                  ),
                ],
                if (controller.isMapView &&
                    controller.orderInfoDetails.value != null) ...[
                  //Map View
                  Container(
                    margin: EdgeInsets.all(8),
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 0, bottom: 8, top: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          child: Image.network(
                            '${controller.orderInfoDetails.value?.establishment?.imgUrl}'
                                        .isNotEmpty ==
                                    true
                                ? '${controller.orderInfoDetails.value?.establishment?.imgUrl}'
                                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwsCcItkbcOT4I3iQ40pAytBCecmH7Zw2NvZ-jHf_fRSr_G6NafXdXzBHoSF0saXKmDps&amp;usqp=CAU',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                        ),
                        SizedBox(width: 20),
                        if (controller.orderInfoDetails.value?.car != null) ...[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.orderInfoDetails.value?.car?.driverName}',
                                  style: textTheme.bodyText1!.copyWith(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${controller.orderInfoDetails.value?.car?.driverPhoneNumber}',
                                  style: textTheme.bodySmall!.copyWith(
                                      fontSize: 9.sp, color: Color(0xffAAAAAA)),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              //open alert dialog of call allowed
                              Helpers.launchUrl(
                                  "tel:${controller.orderInfoDetails.value?.car?.driverPhoneNumber}");
                              // onViewAlertDialog(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, top: 8.0, bottom: 8.0, right: 4.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsPath.callIconsWhite,
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "${language.call}",
                                      style: textTheme.bodyText1!.copyWith(
                                        fontSize: 8.sp,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                      // maxLines: 1,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(5)),
                                constraints: BoxConstraints(
                                  minWidth: 55, minHeight: 55
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.tempCarData?.driverName}',
                                  style: textTheme.bodyText1!.copyWith(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${controller.tempCarData?.driverPhoneNumber}',
                                  style: textTheme.bodySmall!.copyWith(
                                      fontSize: 9.sp, color: Color(0xffAAAAAA)),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              //open alert dialog of call allowed
                              Helpers.launchUrl(
                                  "tel:${controller.tempCarData?.driverPhoneNumber}");
                              // onViewAlertDialog(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, top: 8.0, bottom: 8.0, right: 4.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsPath.callIconsWhite,
                                      height: 15,
                                      width: 15,
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "${language.call}",
                                      style: textTheme.bodyText1!.copyWith(
                                        fontSize: 8.sp,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.start,
                                      // maxLines: 1,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(3.0),
                                constraints: BoxConstraints(
                                    minWidth: 55, minHeight: 55
                                ),
                                decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                        ],
                        GestureDetector(
                          onTap: () async {
                            controller.shareDriverInfo(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, bottom: 8.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetsPath.chatIconsWhite,
                                    height: 15,
                                    width: 15,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "${language.chat}",
                                    style: textTheme.bodyText1!.copyWith(
                                      fontSize: 8.sp,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(3.0),
                              constraints: BoxConstraints(
                                  minWidth: 55, minHeight: 55
                              ),
                              decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ] else ...[
                  //Order details
                  Container(
                    margin: EdgeInsets.all(8),
                    width: double.infinity,
                    padding:
                        EdgeInsets.only(left: 16, right: 0, bottom: 8, top: 8),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              AssetsPath.home,
                              height: 4.h,
                              width: 4.w,
                            ),
                            Container(
                                width: 1,
                                height: 3.h,
                                color: Color(0xffEADB57)),
                            SizedBox(height: 3),
                            Image.asset(
                              AssetsPath.location,
                              height: 4.h,
                              width: 4.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${language.delivery_from}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 9.sp, color: Color(0xffAAAAAA)),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                controller.getEstablishmentAddress(),
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: AppThemes.colorBorderLine),
                              SizedBox(height: 8),
                              Text(
                                "${language.where_to_deliver}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 9.sp, color: Color(0xffAAAAAA)),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                controller.getDeliveryAddress().length > 60
                                    ? '${controller.getDeliveryAddress().substring(0, 60)}...'
                                    : controller.getDeliveryAddress(),
                                softWrap: true,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppThemes.colorBorderLine)),
                  ),
                ],
                if (controller.isMapView &&
                    controller.orderInfoDetails.value != null) ...[
                  //Map View
                  Obx(() {
                    if (controller.isExpanded.value) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                left: 16, right: 0, bottom: 8, top: 8),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      AssetsPath.home,
                                      height: 4.h,
                                      width: 4.w,
                                    ),
                                    Container(
                                        width: 1,
                                        height: 3.h,
                                        color: Color(0xffEADB57)),
                                    SizedBox(height: 3),
                                    Image.asset(
                                      AssetsPath.location,
                                      height: 4.h,
                                      width: 4.w,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${language.delivery_from}",
                                        style: textTheme.bodySmall!.copyWith(
                                            fontSize: 8.sp,
                                            color: Color(0xffAAAAAA)),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        controller
                                                    .getEstablishmentAddress()
                                                    .length >
                                                60
                                            ? '${controller.getEstablishmentAddress().substring(0, 60)}...'
                                            : controller
                                                .getEstablishmentAddress(),
                                        style: textTheme.bodyText1!.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                          width: double.infinity,
                                          height: 1,
                                          color: AppThemes.colorBorderLine),
                                      SizedBox(height: 8),
                                      Text(
                                        "${language.where_to_deliver}",
                                        style: textTheme.bodySmall!.copyWith(
                                            fontSize: 8.sp,
                                            color: Color(0xffAAAAAA)),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        controller.getDeliveryAddress().length >
                                                60
                                            ? '${controller.getDeliveryAddress().substring(0, 60)}...'
                                            : controller.getDeliveryAddress(),
                                        style: textTheme.bodyText1!.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppThemes.colorBorderLine)),
                          ),
                          _buildOrder(context),
                          _buildInformation(context)
                        ],
                      );
                    }
                    return SizedBox(height: 0);
                  }),
                ] else ...[
                  //Order details
                  Obx(() {
                    if (controller.isExpanded.value) {
                      return Column(
                        children: [
                          _buildOrder(context),
                          _buildInformation(context)
                        ],
                      );
                    }
                    return SizedBox(height: 0);
                  }),
                ],
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  onPressed: () async {
                    await Get.toNamed(Routes.orderCancelDetailsView,
                        arguments: jsonEncode({
                          "from": "orderListing",
                          "order_id":
                              "${controller.orderInfoDetails.value?.orderId}"
                        }));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => OrderCancellationView()));
                  },
                  child: Text(
                    "${language.cancel}",
                    style: textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: colorScheme.primary),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInformation(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("${language.order_information}",
                  style: textTheme.bodyText1!
                      .copyWith(fontSize: 11.sp, color: Colors.white)),
            ),
            Spacer()
          ],
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: AppThemes.colorBorderLine),
              borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.products}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.products?.length} ${language.items}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.prices}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if ((controller.orderInfoDetails.value!.establishment!
                                    .cashbackPercent ??
                                0) >
                            0) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                //open cashback alert dialog
                                showDialog(
                                    context: context,
                                    builder: (context) => CashBackDialog(
                                          message: "",
                                        ));
                              },
                              child: Row(
                                children: [
                                  Row(
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
                                        "${language.cashback} ${controller.orderInfoDetails.value!.establishment!.cashbackPercent!.toString()}%:",
                                        style: textTheme.bodySmall!.copyWith(
                                            fontSize: 12.sp,
                                            color: colorScheme.primary),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    "${controller.getCashback(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                    style: textTheme.bodySmall!.copyWith(
                                        fontSize: 12.sp, color: Colors.white),
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.shipping}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.establishment?.calculatedPrice} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 12.sp, color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if (double.parse(controller.freeShippingAmount()) >
                            0) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    "${language.free_shipping}",
                                    style: textTheme.bodySmall!.copyWith(
                                        fontSize: 12.sp,
                                        color: Color(0xff838383)),
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Spacer(),
                                Text(
                                  "${controller.freeShippingAmount()} ${language.currency_symbol}",
                                  style: textTheme.bodySmall!.copyWith(
                                      fontSize: 13.sp, color: Colors.white),
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          ),
                        ],
                        Divider(color: AppThemes.colorBorderLine),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.total}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(controller.orderInfoDetails.value?.products)} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrder(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Align(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "${language.your_orders}",
                style: textTheme.bodyText1!
                    .copyWith(fontSize: 11.sp, color: Colors.white),
              ),
            ),
            alignment: Alignment.centerLeft),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppThemes.colorBorderLine)),
          child: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ('${controller.orderInfoDetails.value?.products![index].productData?.name}' ==
                                    language.all)
                                    ? '${controller.orderInfoDetails.value?.products![index].quantity}x ${language.all}'
                                    : (appLocale == Locale('en'))
                                    ? '${controller.orderInfoDetails.value?.products![index].quantity}x ${controller.orderInfoDetails.value?.products![index].productData?.nameEn}'
                                    : (appLocale == Locale('uk'))
                                    ? '${controller.orderInfoDetails.value?.products![index].quantity}x ${controller.orderInfoDetails.value?.products![index].productData?.nameUk}'
                                    : (appLocale == Locale('ru'))
                                    ? '${controller.orderInfoDetails.value?.products![index].quantity}x ${controller.orderInfoDetails.value?.products![index].productData?.nameRu}'
                                    : '${controller.orderInfoDetails.value?.products![index].quantity}x ${controller.orderInfoDetails.value?.products![index].productData?.name}',
                                // "${controller.orderInfoDetails.value?.products![index].quantity}x "
                                //     "${controller.orderInfoDetails.value?.products![index].productData?.name}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 10.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "${controller.getItemPriceWith2Digit("${controller.orderInfoDetails.value?.products![index].price}")} ${language.currency_symbol}",
                              style: textTheme.bodySmall!.copyWith(
                                  fontSize: 10.sp, color: Colors.white),
                              textAlign: TextAlign.end,
                              softWrap: true,
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: controller.orderInfoDetails.value?.products?.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  /*
  *  SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.products}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.orderInfoDetails.value?.products?.length} ${language.items}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${language.prices}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14.sp, color: Color(0xff838383)),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "0 ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.white),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
  * */

  //call allowed or not alert dialog
  onViewAlertDialog(BuildContext context) async {
    BuildContext moContext;
    moContext = context;

    var textTheme = Theme.of(moContext).textTheme;
    var language = AppLocalizations.of(moContext)!;

    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: language.call_window_title_message,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
    showDialog(
        context: moContext,
        builder: (moContext) => WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.callBigIconsWhite,
              okButtonText: language.call_allow,
              closeButtonText: language.call_deny,
              isSingleButton: false,
              isBothButtonHide: false,
              isCloseDialog: true,
              onPositivePressed: () {
                //close screen
                Navigator.of(moContext).pop();
                Helpers.launchUrl("tel:+9900");
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                Navigator.of(moContext).pop();
              },
            ));
  }
}
