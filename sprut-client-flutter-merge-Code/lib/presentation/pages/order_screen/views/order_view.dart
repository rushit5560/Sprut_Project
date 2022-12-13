import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../widgets/primary_container/primary_container.dart';
import '../../no_internet/no_internet.dart';

class OrderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrderViewState();
}

class OrderViewState extends State<OrderView> {
  OrderController controller = Get.put(OrderController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        if (state is ConnectedInitialState) {}
        if (state is ConnectedSucessState) {
          controller.getOrders(context);
        }
      },
      builder: (context, connectionState) {
        return connectionState is ConnectedFailureState
            ? NoInternetScreen(onPressed: () async {})
            : WillPopScope(
                onWillPop: () {
                  // controller.timer?.cancel();
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                  return Future.value(true);
                },
                child: Scaffold(
                  appBar: AppBar(
                      elevation: 0,
                      backgroundColor:
                          Helpers.primaryBackgroundColor(colorScheme),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryContainer(
                            child: IconButton(
                                onPressed: () {
                                  // controller.timer?.cancel();
                                  Navigator.pop(context);
                                  FocusScope.of(context).unfocus();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: colorScheme.background,
                                ))),
                      )),
                  body: GetBuilder<OrderController>(
                    initState: (_) {
                      controller.data.value?.clear();
                      controller.getOrders(context);
                      controller.listController.addListener(() {
                        controller.loadMore();
                      });
                      updateOrderStart(context);
                    },
                    builder: (_) {
                      return BlocConsumer<ConnectedBloc, ConnectedState>(
                        listener: (context, state) {
                          if (state is ConnectedSucessState) {
                            controller.getOrders(context);
                          }
                          if (state is ConnectedInitialState) {}

                          // if (state is ConnectedFailureState) {
                          //   showDialog(
                          //       context: context,
                          //       builder: (context) => MyCustomDialog(
                          //         message: language.networkError,
                          //       ));
                          // }
                        },
                        builder: (context, connectionState) {
                          return connectionState is ConnectedFailureState
                              ? NoInternetScreen(onPressed: () async {})
                              : SafeArea(
                                  top: false,
                                  bottom: false,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(language.your_orders,
                                              style: textTheme.headline1!
                                                  .copyWith(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Helpers
                                                          .primaryTextColor())),
                                          SizedBox(height: 10),
                                          if (controller.isLoading ==
                                              false) ...[
                                            if (controller
                                                    .data.value?.isNotEmpty ==
                                                true) ...[
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: controller
                                                      .data.value?.length,
                                                  controller:
                                                      controller.listController,
                                                  shrinkWrap: true,
                                                  itemBuilder: (ctx, index) {
                                                    return _buildItem(
                                                        ctx, index, appLocale);
                                                  },
                                                ),
                                              ),
                                            ] else ...[
                                              Expanded(
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      language.no_order_message,
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                          ] else ...[
                                            Expanded(
                                              child: Container(
                                                child: Center(
                                                  child: SizedBox(
                                                    child: Lottie.asset(
                                                        'assets/images/loading1.json'),
                                                    height: 100,
                                                    width: 95,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                          if (controller.isLoadMoreRunning) ...[
                                            Center(
                                              child: SizedBox(
                                                child: Lottie.asset(
                                                    'assets/images/loading1.json'),
                                                height: 100,
                                                width: 95,
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                          ;
                        },
                      );
                    },
                  ),
                  backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
                ),
              );
      },
    );
  }

  updateOrderStart(BuildContext context) {
    controller.getOrders(context);
    // controller.timer?.cancel();
    // controller.timer = Timer.periodic(Duration(seconds: 7), (timer) {
    //   controller.getOrders(context);
    // });
  }

  Widget _buildItem(BuildContext context, int index, Locale appLocale) {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String? orderStatus;
    String? orderStatus1;

    if (controller.data.value![index].car != null) {
      orderStatus = Helpers.getOrderStatusByDeliveryStatusDefault(
          context, controller.data.value![index].status, language);
    } else {
      orderStatus = Helpers.getOrderStatusByDeliveryStatusDefault(
          context, controller.data.value![index].deliveryStatus, language);
    }

    //print("Delivery Status ---> ${controller.data.value![index].deliveryStatus}");
    // var driverStatus = controller.data.value![index].status;
    //print("driverStatus Status ---> ${controller.data.value![index].status}");

    return Card(
      color: Helpers.secondaryBackground(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () async {
          print("orderCurrentStatus :: ${orderStatus.toString()}");
          controller.orderCurrentStatus = orderStatus.toString();

          // controller.timer?.cancel();
          switch (orderStatus.toString()) {
            case "Order preparing":
              print("Order preparing");
              // controller.isMapView = false;
              await Get.toNamed(Routes.orderDetailsView,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // controller.data.value?.clear();
              // print("3nit Order Listing call");
              controller.getOrders(context);
              updateOrderStart(context);
              break;
            case "Order is packing":
              print("Order is packing");
              // controller.isMapView = false;
              await Get.toNamed(Routes.orderDetailsView,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // controller.data.value?.clear();
              // print("3nit Order Listing call");
              controller.getOrders(context);
              updateOrderStart(context);
              break;
            case "Waiting for delivery partner":
              print("Waiting for delivery partner");
              // controller.isMapView = false;
              await Get.toNamed(Routes.orderDetailsView,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // controller.data.value?.clear();
              // print("3nit Order Listing call");
              controller.getOrders(context);
              updateOrderStart(context);
              break;
            case "Order cancelled":
              print("Order cancelled");
              // controller.isMapView = false;
              await Get.toNamed(Routes.orderCompletedScreen,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // controller.data.value?.clear();
              controller.getOrders(context);
              updateOrderStart(context);
              break;
            case "Courier on the way":
              print("Courier on the way");
              // controller.isMapView = true;
              await Get.toNamed(Routes.orderMapView,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // controller.data.value?.clear();
              controller.getOrders(context);
              updateOrderStart(context);
              break;
            case "Order delivered":
              Get.offNamed(Routes.orderCompletedScreen,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              // await Get.toNamed(Routes.orderMapView,
              //     arguments: jsonEncode({
              //       "from": "orderListing",
              //       "order_id": "${controller.data.value![index].orderId}"
              //     }));
              break;
            default:
              print("Order default::");
              // controller.isMapView = false;
              await Get.toNamed(Routes.orderDetailsView,
                  arguments: jsonEncode({
                    "from": "orderListing",
                    "order_id": "${controller.data.value![index].orderId}"
                  }));
              controller.getOrders(context);
              updateOrderStart(context);
              break;
          }
        },
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Row(
            children: [
              ClipRRect(
                child: Image.network(
                  controller.data.value![index].establishment?.imgUrl
                              ?.isNotEmpty ==
                          true
                      ? "${controller.data.value![index].establishment?.imgUrl}"
                      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwsCcItkbcOT4I3iQ40pAytBCecmH7Zw2NvZ-jHf_fRSr_G6NafXdXzBHoSF0saXKmDps&amp;usqp=CAU',
                  width: 85,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*
                      ('${establishmentController.lsFoodTypeData[index].name}' == language.all)?'${language.all}' :
                                (appLocale==Locale('en'))? '${establishmentController.lsFoodTypeData[index].nameEn}':
                                (appLocale==Locale('uk'))?'${establishmentController.lsFoodTypeData[index].nameUk}':
                                (appLocale==Locale('ru'))?'${establishmentController.lsFoodTypeData[index].nameRu}':'${establishmentController.lsFoodTypeData[index].name}',
                      * */
                      Text(
                        ('${controller.data.value![index].establishment?.name}' ==
                                language.all)
                            ? '${language.all}'
                            : (appLocale == Locale('en'))
                                ? '${controller.data.value![index].establishment?.nameEn}'
                                : (appLocale == Locale('uk'))
                                    ? '${controller.data.value![index].establishment?.nameUk}'
                                    : (appLocale == Locale('ru'))
                                        ? '${controller.data.value![index].establishment?.nameRu}'
                                        : '${controller.data.value![index].establishment?.name}',
                        style: textTheme.bodyText1!
                            .copyWith(fontSize: 13.sp, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                      if (controller.data.value![index].createdAt != null) ...[
                        Text(
                          "${language.order_date} ${Helpers.orderStringCreatedDate(context, "${controller.data.value![index].createdAt}", language.today_at)}",
                          style: textTheme.bodySmall!.copyWith(
                              fontSize: 8.sp, color: Color(0xff838383)),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(color: Colors.white),
                      ],
                      if (controller.data.value![index].products != null &&
                          controller.data.value![index].products?.length !=
                              0) ...[
                        Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                              itemBuilder: (context, position) {
                                return productList(
                                    context,
                                    ('${controller.data.value![index].products![position].productData?.name}' ==
                                            language.all)
                                        ? '${language.all}'
                                        : (appLocale == Locale('en'))
                                            ? '${controller.data.value![index].products![position].productData?.nameEn}'
                                            : (appLocale == Locale('uk'))
                                                ? '${controller.data.value![index].products![position].productData?.nameUk}'
                                                : (appLocale == Locale('ru'))
                                                    ? '${controller.data.value![index].products![position].productData?.nameRu}'
                                                    : '${controller.data.value![index].products![position].productData?.name}',
                                    '${controller.data.value![index].products![position].quantity}',
                                    (controller.data.value![index].products![position].productData?.quantityType == 'g')
                                        ? '(${controller.data.value![index].products![position].productData?.weight}${language.gram})'
                                        : (controller.data.value![index].products![position].productData?.quantityType == 'ml')
                                        ? '(${controller.data.value![index].products![position].productData?.weight}${language.mili})'
                                        : (controller.data.value![index].products![position].productData?.quantityType == 'pc')
                                        ? '(${controller.data.value![index].products![position].productData?.weight}${language.pieces})'
                                        : (controller.data.value![index].products![position].productData?.quantityType == 'kg')
                                        ? '(${controller.data.value![index].products![position].productData?.weight}${language.kilogram})'
                                        : '');
                                //'${controller.data.value![index].products![position].productData?.weight}'
                              },
                              itemCount: controller
                                          .data.value![index].products!.length >
                                      1
                                  ? 2
                                  : 1,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (controller.data.value![index].products!.length >
                            1) ...[
                          Text(
                            "...",
                            style: textTheme.bodySmall!.copyWith(
                                fontSize: 11.sp, color: Color(0xff838383)),
                            textAlign: TextAlign.start,
                          ),
                        ] else ...[
                          SizedBox.shrink(),
                        ],
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${controller.getTotalAmount(controller.data.value![index].products)} ${language.currency_symbol}",
                            style: textTheme.bodyText1!
                                .copyWith(fontSize: 13.sp, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetsPath.dotIcon,
                                color: orderStatus == "Order cancelled"
                                    ? Colors.yellow
                                    : Colors.green,
                                height: 8.sp,
                                width: 8.sp,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${Helpers.getListingOrderStatus(context, orderStatus.toString(), language)}",
                                style: textTheme.bodyText1!.copyWith(
                                    fontSize: 8.sp,
                                    color: orderStatus == "Order cancelled"
                                        ? Colors.yellow
                                        : Colors.green),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productList(
      BuildContext context, String? name, String? qty, String weight) {
    var textTheme = Theme.of(context).textTheme;
    return Text(
      "${qty}x ${name} ${weight} ",
      style: textTheme.bodySmall!
          .copyWith(fontSize: 11.sp, color: Color(0xff838383)),
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
    );
  }
}
