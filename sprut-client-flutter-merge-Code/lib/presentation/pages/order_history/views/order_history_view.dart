import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';
import 'package:sprut/presentation/pages/order_history/views/order_history_detail_view.dart';

import '../../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_back_btn.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  OrderHistoryView({Key? key}) : super(key: key);

  HomeViewController homeViewController = Get.put(HomeViewController());

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
            child: Container(
              color: colorScheme.onBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
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
                      controller.lastOrder
                          ? language.lastTrip
                          : language.your_trips,
                      style: textTheme.bodyText1!.copyWith(
                          fontSize: 14.sp,
                          color: AppThemes.dark,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.axis == Axis.vertical &&
                            notification.metrics.pixels ==
                                notification.metrics.maxScrollExtent &&
                            notification.metrics.atEdge) {
                          controller.getOrderHistory();
                        }
                        return true;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: controller.lastOrder &&
                                controller.ordersHistory.length > 0
                            ? 1
                            : controller.ordersHistory.length,
                        itemBuilder: (context, index) {
                          OrderModel orderModel =
                              controller.ordersHistory[index];

                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderHistoryDetailView(
                                    orderModel: orderModel,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    top: 4.0,
                                    bottom: 4.0,
                                    right: 12.0,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.formattedDateTime(
                                              context, orderModel.createdAt!),
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 9.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        orderModel.status == "completed"
                                            ? language.completed_trip
                                            : language.cancelled_trip,
                                        style: textTheme.bodyText1!.copyWith(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8.0, right: 8.0, bottom: 20),
                                  padding: const EdgeInsets.only(
                                    left: 12.0,
                                    bottom: 4.0,
                                    right: 12.0,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            padding: EdgeInsets.only(left: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
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
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 3,
                                                          right: 3,
                                                        ),
                                                        child: Text(
                                                          language.route,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  "SF-Pro Display"),
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
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 3,
                                                          right: 3,
                                                        ),
                                                        child: Text(
                                                          controller
                                                              .filterDecodedAddress(
                                                                  orderModel
                                                                      .addresses![0]),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "SF-Pro Display"),
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
                                                      margin:
                                                          const EdgeInsets.only(
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
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 3,
                                                          right: 3,
                                                        ),
                                                        child: Text(
                                                          controller
                                                              .filterDecodedAddress(
                                                                  orderModel
                                                                      .addresses![1]),
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "SF-Pro Display"),
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
                                                //           width: 1,
                                                //           height: 12.0,
                                                //           color: Colors.grey,
                                                //         ),
                                                //         Icon(
                                                //           Icons.arrow_forward,
                                                //           size: 20,
                                                //           color: Colors.grey,
                                                //         ),
                                                //       ],
                                                //     ),
                                                //     SizedBox(width: 7),
                                                //     Expanded(
                                                //       child: Column(
                                                //         mainAxisAlignment:
                                                //             MainAxisAlignment
                                                //                 .start,
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment
                                                //                 .start,
                                                //         children: [
                                                //           Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //               left: 3,
                                                //               right: 3,
                                                //             ),
                                                //             child: Text(
                                                //               language.route,
                                                //               style: TextStyle(
                                                //                   fontSize: 10,
                                                //                   color: Colors
                                                //                       .grey,
                                                //                   fontFamily:
                                                //                       "SF-Pro Display"),
                                                //             ),
                                                //           ),
                                                //           Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //                     left: 3,
                                                //                     right: 3,
                                                //                     top: 2,
                                                //                     bottom: 4),
                                                //             child: Text(
                                                //               controller
                                                //                   .filterDecodedAddress(
                                                //                       orderModel
                                                //                           .addresses![0]),
                                                //               style: TextStyle(
                                                //                   fontSize: 12,
                                                //                   color: Colors
                                                //                       .black,
                                                //                   fontFamily:
                                                //                       "SF-Pro Display"),
                                                //             ),
                                                //           ),
                                                //           SizedBox(
                                                //             height: 12,
                                                //           ),
                                                //           Padding(
                                                //             padding:
                                                //                 EdgeInsets.only(
                                                //                     left: 3,
                                                //                     right: 3,
                                                //                     top: 4,
                                                //                     bottom: 4),
                                                //             child: Text(
                                                //               controller
                                                //                   .filterDecodedAddress(
                                                //                       orderModel
                                                //                           .addresses![1]),
                                                //               style: TextStyle(
                                                //                   fontSize: 12,
                                                //                   color: Colors
                                                //                       .black,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 0.5,
                                        margin: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 4,
                                            bottom: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEAEAEA),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 24,
                                            right: 24,
                                            top: 8,
                                            bottom: 4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    language.payment_type,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            "SF-Pro Display"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    orderModel.isCardPay!
                                                        ? (orderModel
                                                                    .paymentType !=
                                                                null
                                                            ? (orderModel
                                                                        .paymentType ==
                                                                    "balance"
                                                                ? language
                                                                    .balance
                                                                : (orderModel
                                                                            .paymentType ==
                                                                        "card"
                                                                    ? language
                                                                        .card
                                                                    : (orderModel.paymentType ==
                                                                            "cash"
                                                                        ? language
                                                                            .cash
                                                                        : "")))
                                                            : "")
                                                        : language.cash,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            colorScheme.primary,
                                                        fontFamily:
                                                            "SF-Pro Display"),
                                                  ),
                                                ),
                                                Text(
                                                  '${((orderModel.summary?.tripCost)! / 100).toStringAsFixed(2)}\₴',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "SF-Pro Display"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index == 0)
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 0.5,
                                          margin: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFEAEAEA),
                                          ),
                                        ),
                                      if (index == 0)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 24,
                                              right: 24,
                                              top: 4,
                                              bottom: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 44.0,
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  alignment: Alignment.center,
                                                  child: PrimaryElevatedBackBtn(
                                                      fontSize: 8.sp,
                                                      height: 36.0,
                                                      buttonText: language.back,
                                                      color: Colors.grey,
                                                      onPressed: () {
                                                        homeViewController
                                                            .repeatLastTripBack(
                                                                context,
                                                                orderModel);
                                                      }),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 44.0,
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: PrimaryElevatedBtn(
                                                      fontSize: 8.sp,
                                                      height: 36.0,
                                                      buttonText:
                                                          language.repeat,
                                                      color:
                                                          colorScheme.primary,
                                                      onPressed: () {
                                                        homeViewController
                                                            .repeatLastTrip(
                                                                context,
                                                                orderModel);
                                                      }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
