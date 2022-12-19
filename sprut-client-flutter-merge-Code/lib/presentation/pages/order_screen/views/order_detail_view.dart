import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';
import 'package:sprut/presentation/pages/order_screen/views/order_detail_bottom_sheet_view.dart';

import '../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../widgets/custom_dialog/widget_dialog.dart';
import '../../../widgets/primary_container/primary_container.dart';
import '../../no_internet/no_internet.dart';

class OrderDetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrderDetailViewState();
}

class OrderDetailViewState extends State<OrderDetailView> {

  OrderController controller = Get.put(OrderController(), permanent: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();
    dynamic object = ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic> mapData = jsonDecode(object);
    // String orderId = ModalRoute.of(context)!.settings.arguments as String;
    var colorScheme = Theme.of(context).colorScheme;
    var language = AppLocalizations.of(context)!;

    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        if (state is ConnectedInitialState) {}
        if (state is ConnectedSucessState) {}
      },
      builder: (context, connectionState) {
        return connectionState is ConnectedFailureState ? NoInternetScreen(
            onPressed: () {}) : WillPopScope(
          onWillPop: () async {
            controller.isExpanded.value = false;
            controller.timer?.cancel();
            FocusScope.of(context).unfocus();
            if (mapData['from'].toString() == "orderListing") {
              Get.back();
            } else {
              // Navigator.pushNamedAndRemoveUntil(
              //     context, Routes.foodHomeScreen, (route) => true);
              Navigator.pushNamedAndRemoveUntil(context,
                  Routes.foodHomeScreen, ModalRoute.withName('/'));
            }
            return Future.value(true);
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Obx(() {
                if (controller.isExpanded.value) {
                  return SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryContainer(
                    child: IconButton(
                      onPressed: () async {
                        controller.timer?.cancel();
                        FocusScope.of(context).unfocus();
                        if (mapData['from'].toString() =="orderListing") {
                          Get.back();
                        } else {
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, Routes.foodHomeScreen, (route) => true);
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.foodHomeScreen,
                              ModalRoute.withName('/'));
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.background,
                      ),
                    ),
                  ),
                );
              }),
            ),
            body: GetBuilder<OrderController>(
              initState: (_) {
                controller.isMapView = false;
                controller.getOrderInfoInitCall(context, mapData['order_id']);
                controller.timer?.cancel();
                controller.timer = Timer.periodic(Duration(seconds: 5), (timer) {
                      // print("Call Order Info Api2");
                      controller.getOrderInfo(context, mapData['order_id'],0);
                      print("deliveryStatus Status-----------> ${controller
                          .orderInfoDetails.value?.deliveryStatus}");
                      print("Status-----------> ${controller.orderInfoDetails
                          .value?.status}");
                    });
                controller.timer1?.cancel();
                controller.timer1 = Timer.periodic(Duration(seconds: 1), (timer) {
                        if (controller.orderInfoDetails.value?.car != null && controller.orderInfoDetails.value?.status != "cancelled") {
                          controller.timer?.cancel();
                          controller.timer1?.cancel();
                          controller.orderCurrentStatus = Helpers
                              .getOrderStatusByDeliveryStatusDefault(context,
                              "${controller.orderInfoDetails.value?.status}", language)
                              .toString();

                          if(controller.orderInfoDetails.value?.status == 'completed') {
                            //complete order
                            controller.orderCurrentStatus = 'Order delivered';
                            Get.offNamed(Routes.orderCompletedScreen,
                                arguments: jsonEncode({
                                  "from": "orderCompleted",
                                  "order_id": "${controller.orderInfoDetails.value?.orderId}"
                                }));
                          }else {
                            //accept delivered
                            Get.offNamed(Routes.orderMapView,
                                arguments: jsonEncode({
                                  "from": "orderListing",
                                  "order_id": "${controller.orderInfoDetails.value?.orderId}"
                                }));
                          }
                        }
                      // }

                      if (controller.isShowCancelDialog) {
                        controller.timer?.cancel();
                        controller.timer1?.cancel();
                        //show cancel dialog
                        onCancelAlertDialog(context, mapData);
                      }
                    });
              },
              builder: (_) {
                if (controller.isLoading == true) {
                  return Center(
                    child: SizedBox(
                      child: Lottie.asset('assets/images/loading1.json'),
                      height: 100,
                      width: 95,
                    ),
                  );
                } else {
                  return SafeArea(
                    top: false,
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
                      child: SlidingUpPanel(
                        onPanelSlide: (value) {
                          // if (controller.isExpanded.value) {
                          //   controller.isExpanded.value = false;
                          //   controller.update();
                          // }
                          controller.isExpanded.value = true;
                        },
                        onPanelOpened: () {
                          controller.isExpanded.value = true;
                          controller.update();
                        },
                        controller: controller.scrollController,
                        onPanelClosed: () {
                          // if (controller.isExpanded.value) {
                          //   controller.isExpanded.value = false;
                          //   controller.update();
                          // }
                          controller.isExpanded.value = false;
                          controller.update();
                        },
                        // minHeight: 375,
                        // maxHeight: MediaQuery.of(context).size.height -
                        //     AppBar().preferredSize.height,
                        minHeight: 375,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .height,
                        panelBuilder: (ScrollController sc) =>
                            OrderDetailBottomSheetView(sc),
                        // panel: OrderDetailBottomSheetView(),
                        body: Obx(() {
                          return Column(
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  '${controller.orderInfoDetails.value?.establishment?.imgUrl}'.isNotEmpty ==true
                                      ? '${controller.orderInfoDetails.value
                                      ?.establishment?.imgUrl}'
                                      : 'https://t3.ftcdn.net/jpg/03/24/73/92/360_F_324739203_keeq8udvv0P2h1MLYJ0GLSlTBagoXS48.jpg',
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height*0.55,
                                  fit: BoxFit.cover,
                                ),
                              )
                              // if (controller.isExpanded.isTrue) Container(
                              //         color:
                              //             Helpers.primaryBackgroundColor(
                              //                 colorScheme),
                              //       ) else ClipRRect(
                              //         child: Image.network(
                              //           '${controller.orderInfoDetails.value?.establishment?.imgUrl}'
                              //                       .isNotEmpty ==
                              //                   true
                              //               ? '${controller.orderInfoDetails.value?.establishment?.imgUrl}'
                              //               : 'https://t3.ftcdn.net/jpg/03/24/73/92/360_F_324739203_keeq8udvv0P2h1MLYJ0GLSlTBagoXS48.jpg',
                              //           width: double.infinity,
                              //           height: 500,
                              //           fit: BoxFit.cover,
                              //         ),
                              //       )
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                }
              },
            ),
            backgroundColor: Colors.black,
            ///trasfternt color
          ),
        );
      },
    );
  }

  Widget textMaker(BuildContext context, String text1, String text2,
      String text3, String secondTextColor) {
    var colorScheme = Theme
        .of(context)
        .colorScheme;
    var textTheme = Theme
        .of(context)
        .textTheme;

    Color secondryColor = secondTextColor == "Gray"
        ? AppThemes.offWhiteColor
        : colorScheme.primary;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
          TextSpan(
            text: "\n" + text2 + "\n",
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: secondryColor),
          ),
          TextSpan(
            text: text3,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.secondaryTextColor()),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  //order cancel alert dialog
  onCancelAlertDialog(BuildContext context,
      Map<String, dynamic> mapData) async {
    BuildContext moContext;
    moContext = context;

    var language = AppLocalizations.of(context)!;

    var titleWidget = textMaker(
        moContext,
        language.order_cancel_message,
        language.order_cancel_title_message,
        "\n${controller.orderInfoDetails.value?.deliveryCancelReason
            .toString()}\n",
        "Gray");

    showDialog(
        context: moContext,
        builder: (moContext) =>
            WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.orderCancelCartIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () async {
                //close screen
                Get.back();
                if (mapData['from'].toString() == "orderListing") {
                  Get.back();
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.foodHomeScreen, ModalRoute.withName('/'));
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, Routes.foodHomeScreen, (route) => false);
                }
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                Navigator.of(moContext).pop();
              },
            ));
  }

  // @protected
  // @mustCallSuper
  // void dispose() {
  //   // controller.timer?.cancel();
  //   // controller.timer1?.cancel();
  //   super.dispose();
  // }
}
