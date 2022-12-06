import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';

import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryDetailView extends GetView<OrderHistoryController> {
  final OrderModel orderModel;
  OrderHistoryDetailView({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return GetBuilder<OrderHistoryController>(
      init: OrderHistoryController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          backgroundColor: colorScheme.onBackground,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.formattedDateTime(
                        context, orderModel.createdAt!),
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 14.sp,
                        color: AppThemes.dark,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
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
                                    height: 3.5.h,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${orderModel.car?.driverName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyText1!.copyWith(
                                        fontSize: 13.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 2.0),
                                    padding:
                                        EdgeInsets.only(left: 4.0, right: 4.0),
                                    color: AppThemes.primary,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${orderModel.car?.rating}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 10.sp,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 2.0,
                                        ),
                                        SvgPicture.asset(AssetsPath.star),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${orderModel.car?.licensePlateNumber}",
                                      textAlign: TextAlign.end,
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 13.sp,
                                          color: AppThemes.primary),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "${orderModel.car?.colorRaw} ${orderModel.car?.makeRaw} ${orderModel.car?.modelRaw} • ${orderModel.rate?.name!}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 9.sp,
                                          color: AppThemes.lightGrey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                padding: EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 3.h,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                            ),
                                            child: Text(
                                              language.route,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontFamily: "SF-Pro Display"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 3.h,
                                          child: Image.asset(
                                            AssetsPath.location,
                                            height: 18,
                                            width: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                            ),
                                            child: Text(
                                              controller.filterDecodedAddress(
                                                  orderModel.addresses![0]),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontFamily: "SF-Pro Display"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 3.h,
                                          height: 12,
                                          margin: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: VerticalDivider(
                                            width: 1,
                                            thickness: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 3.h,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                            ),
                                            child: Text(
                                              controller.filterDecodedAddress(
                                                  orderModel.addresses![1]),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontFamily: "SF-Pro Display"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     Column(
                                    //       children: [
                                    //         SizedBox(
                                    //           height: 12,
                                    //         ),
                                    //         Image.asset(
                                    //           AssetsPath.location,
                                    //           height: 3.h,
                                    //           width: 3.w,
                                    //           color: Colors.grey,
                                    //         ),
                                    //         Container(
                                    //             width: 1,
                                    //             height: 1.4.h,
                                    //             color: Colors.grey),
                                    //         Icon(
                                    //           Icons.arrow_forward,
                                    //           color: Colors.grey,
                                    //           size: 20,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     SizedBox(width: 7),
                                    //     Expanded(
                                    //       child: Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.start,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.start,
                                    //         children: [
                                    //           Padding(
                                    //             padding: EdgeInsets.only(
                                    //               left: 3,
                                    //               right: 3,
                                    //             ),
                                    //             child: Text(
                                    //               language.route,
                                    //               style: TextStyle(
                                    //                   fontSize: 10,
                                    //                   color: Colors.grey,
                                    //                   fontFamily:
                                    //                       "SF-Pro Display"),
                                    //             ),
                                    //           ),
                                    //           Padding(
                                    //             padding: EdgeInsets.only(
                                    //                 left: 3,
                                    //                 right: 3,
                                    //                 top: 4,
                                    //                 bottom: 4),
                                    //             child: Text(
                                    //               controller
                                    //                   .filterDecodedAddress(
                                    //                       orderModel
                                    //                           .addresses![0]),
                                    //               style: TextStyle(
                                    //                   fontSize: 12,
                                    //                   color: Colors.black,
                                    //                   fontFamily:
                                    //                       "SF-Pro Display"),
                                    //             ),
                                    //           ),
                                    //           Container(
                                    //             width: MediaQuery.of(context)
                                    //                 .size
                                    //                 .width,
                                    //             height: 0.5,
                                    //             decoration: BoxDecoration(
                                    //               color: Colors.transparent,
                                    //             ),
                                    //           ),
                                    //           SizedBox(
                                    //             height: 8,
                                    //           ),
                                    //           Padding(
                                    //             padding: EdgeInsets.only(
                                    //                 left: 3,
                                    //                 right: 3,
                                    //                 top: 4,
                                    //                 bottom: 4),
                                    //             child: Text(
                                    //               controller
                                    //                   .filterDecodedAddress(
                                    //                       orderModel
                                    //                           .addresses![1]),
                                    //               style: TextStyle(
                                    //                   fontSize: 12,
                                    //                   color: Colors.black,
                                    //                   fontFamily:
                                    //                       "SF-Pro Display"),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFEAEAEA),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 24, right: 24, top: 4, bottom: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        language.payment_type,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: "SF-Pro Display"),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        orderModel.isCardPay!
                                            ? (orderModel.paymentType != null
                                                ? (orderModel.paymentType ==
                                                        "balance"
                                                    ? language.balance
                                                    : (orderModel.paymentType ==
                                                            "card"
                                                        ? language.card
                                                        : (orderModel
                                                                    .paymentType ==
                                                                "cash"
                                                            ? language.cash
                                                            : "")))
                                                : "")
                                            : language.cash,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: colorScheme.primary,
                                            fontFamily: "SF-Pro Display"),
                                      ),
                                    ),
                                    Text(
                                      '${((orderModel.summary?.tripCost)! / 100).toStringAsFixed(2)}\₴',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: "SF-Pro Display"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                language.for_payment,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${((orderModel.summary?.tripCost)! / 100).toStringAsFixed(2)}\₴',
                                  textAlign: TextAlign.right,
                                  style: textTheme.bodyText1!.copyWith(
                                    fontSize: 11.sp,
                                    color: AppThemes.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Divider(),
                          const SizedBox(
                            height: 4.0,
                          ),
                          // Obx(
                          //   () {
                          //     return Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           language.ride_time,
                          //           style: textTheme.bodyText1!.copyWith(
                          //             fontSize: 11.sp,
                          //             color: AppThemes.darkGrey,
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: Text(
                          //             '${controller.orderRideTime}',
                          //             textAlign: TextAlign.right,
                          //             style: textTheme.bodyText1!.copyWith(
                          //               fontSize: 11.sp,
                          //               color: AppThemes.primary,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 4.0,
                          // ),
                          // Divider(),
                          // const SizedBox(
                          //   height: 4.0,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                language.route_length,
                                style: textTheme.bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${((orderModel.summary?.distanceTravelled)! / 1000).toStringAsFixed(2)} ' +
                                      language.route_unit,
                                  textAlign: TextAlign.right,
                                  style: textTheme.bodyText1!.copyWith(
                                    fontSize: 11.sp,
                                    color: AppThemes.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
