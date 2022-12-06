import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';
import 'package:sprut/presentation/pages/order_screen/views/order_detail_bottom_sheet_view.dart';

import '../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../widgets/custom_dialog/widget_dialog.dart';
import '../../../widgets/primary_container/primary_container.dart';
import '../../no_internet/no_internet.dart';

class OrderMapView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => OrderMapViewState();
}

class OrderMapViewState extends State<OrderMapView> {
  OrderController controller = Get.put(OrderController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();
    // String orderId = ModalRoute.of(context)!.settings.arguments as String;
    dynamic object = ModalRoute.of(context)!.settings.arguments;
    Map<String,dynamic> mapData = jsonDecode(object);

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {},
      builder: (context, connectionState) {
        return BlocConsumer<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (connectionState is ConnectedFailureState) {
                controller.isExpanded.value = false;
                print("BlocConsumer 2");
                return NoInternetScreen(onPressed: () async {});
              }
              if (connectionState is ConnectedSucessState) {}
              return WillPopScope(
                onWillPop: () {
                  controller.isExpanded.value = false;
                  controller.timer?.cancel();
                  Navigator.pop(context);
                  FocusScope.of(context).unfocus();
                  return Future.value(true);
                },
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    elevation: 0,
                    toolbarHeight: 15.h,
                    backgroundColor: Colors.transparent,
                    leading: Obx(() {
                      if (controller.isExpanded.isTrue) {
                        return SizedBox();
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PrimaryContainer(
                              child: IconButton(
                                onPressed: () {
                                  controller.timer?.cancel();
                                  Navigator.pop(context);
                                  FocusScope.of(context).unfocus();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // if (locationData == null) {
                                    //   // Helpers.showCircularProgressDialog(context: context);
                                    //   await fetchUserLocation();
                                    //   // Navigator.pop(context);
                                    //
                                    //   // gMapController.animateCamera(cameraUpdate)
                                    //   await updateCurrentLocationMarker();
                                    //   animateToCurrent();
                                    // } else {
                                    //   await updateCurrentLocationMarker();
                                    //   // ProgressLoader().dismiss();
                                    //   animateToCurrent();
                                    // }
                                  },
                                  child: Container(
                                    // margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      child: Image.asset(
                                        AssetsPath.gps,
                                        height: 2.5.h,
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                  body: GetBuilder<OrderController>(
                    init: OrderController(),
                    initState: (_) {
                      controller.isMapView = true;
                      controller.markers.clear();
                      controller.polylineCoordinates.clear();
                      controller.polylines.clear();

                      controller.getOrderInfoInitCall(context, mapData['order_id']);
                      controller.timer?.cancel();
                      controller.timer =
                          Timer.periodic(Duration(seconds: 5), (timer) {
                            // print("Call Order Info Api2");
                            controller.getOrderInfo(context, mapData['order_id'],0);
                            if(controller.orderInfoDetails.value?.status == 'completed') {
                              controller.timer?.cancel();
                              controller.orderCurrentStatus = 'Order delivered';
                              Get.offNamed(Routes.orderCompletedScreen,
                                  arguments: jsonEncode({
                                    "from": "orderCompleted",
                                    "order_id": "${controller.orderInfoDetails.value?.orderId}"
                                  }));
                            } else {
                              //order move to back screen
                              if(controller.orderInfoDetails.value?.car == null){
                                controller.timer?.cancel();
                                controller.orderCurrentStatus = Helpers.getOrderStatusByDeliveryStatusDefault(context, "${controller.orderInfoDetails.value?.status}", language).toString();

                                Get.offNamed(Routes.orderDetailsView,
                                    arguments: jsonEncode({
                                      "from": "orderListing",
                                      "order_id": "${controller.orderInfoDetails.value?.orderId}"
                                    }));
                              }
                            }
                            if (controller.isShowCancelDialog) {
                              controller.timer?.cancel();
                              //show cancel dialog
                              onCancelAlertDialog(context, mapData);
                            }
                          });
                    },
                    builder: (_) {
                      if (controller.isLoading == true) {
                        return Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                            height: 60,
                            width: 60,
                          ),
                        );
                      }else {
                        return SafeArea(
                          top: false,
                          bottom: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SlidingUpPanel(
                                onPanelSlide: (value) {
                                  // if (!controller.isExpanded.value) {
                                  //   if (value > 0.05) {
                                  //     controller.isExpanded.value = true;
                                  //     controller.update();
                                  //   }
                                  // }
                                  controller.isExpanded.value = true;
                                },
                                controller: controller.scrollController,
                                onPanelOpened: () {
                                  controller.isExpanded.value = true;
                                },
                                onPanelClosed: () {
                                  controller.isExpanded.value = false;
                                },
                                minHeight:
                                    controller.isExpanded.isTrue ? 375 : 355,
                                maxHeight: MediaQuery.of(context).size.height,
                                panelBuilder: (ScrollController sc) =>
                                    OrderDetailBottomSheetView(sc),
                                // panel: OrderDetailBottomSheetView(),
                                body: Container(
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                              2.8),
                                  child: GoogleMap(
                                    markers:
                                        Set<Marker>.from(controller.markers),
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            controller
                                                .currentPosition!.latitude,
                                            controller
                                                .currentPosition!.longitude),
                                        zoom: 8.0),
                                    buildingsEnabled: true,
                                    mapType: MapType.normal,
                                    zoomGesturesEnabled: true,
                                    zoomControlsEnabled: false,
                                    polylines: Set<Polyline>.of(
                                        controller.polylines.values),
                                    onMapCreated: controller.onMapsCreated,
                                    onTap: (position) {
                                      // controller.customInfoWindowController.hideInfoWindow!();
                                    },
                                    onCameraMove: (position) {
                                      // controller.customInfoWindowController.onCameraMove!();
                                    },
                                    onCameraIdle: () {
                                      controller.update();
                                    },
                                    // markers: Set.of(Marker),
                                  ),
                                )
                                // Stack(
                                //   alignment: Alignment.center,
                                //   children: [
                                //     GoogleMap(
                                //       markers: Set<Marker>.from(controller.markers),
                                //       initialCameraPosition: CameraPosition(target: LatLng(49.2330653 ,28.4723795)),
                                //       buildingsEnabled: true,
                                //       mapType: MapType.normal,
                                //       zoomGesturesEnabled: true,
                                //       zoomControlsEnabled: false,
                                //       polylines: Set<Polyline>.of(controller.polylines.values),
                                //       onMapCreated: controller.onMapsCreated,
                                //       onTap: (position) {
                                //         controller.customInfoWindowController.hideInfoWindow!();
                                //       },
                                //       onCameraMove: (position) {
                                //         controller.customInfoWindowController.onCameraMove!();
                                //       },
                                //       onCameraIdle: () {
                                //         controller.update();
                                //       },
                                //       // markers: Set.of(Marker),
                                //     ),
                                //     // CustomInfoWindow(
                                //     //   controller: controller.customInfoWindowController,
                                //     //   height: 45,
                                //     //   width: 150,
                                //     //   offset: 50,
                                //     // ),
                                //   ],
                                // )
                                // Obx(() {
                                //   return controller.isExpanded.isTrue ? SizedBox() :
                                // }),
                                ),
                          ),
                        );
                      }
                    },
                  ),
                  backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
                ),
              );
            },
            listener: (context, authState) {});
      },
    );


  }

  Widget textMaker(BuildContext context, String text1, String text2,
      String text3, String secondTextColor) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

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
  onCancelAlertDialog(BuildContext context,Map<String,dynamic> mapData) async {
    BuildContext moContext;
    moContext = context;

    var language = AppLocalizations.of(moContext)!;

    var titleWidget = textMaker(
        moContext,
        language.order_cancel_message,
        language.order_cancel_title_message,
        "\n${controller.orderInfoDetails.value?.deliveryCancelReason.toString()}\n",
        "Gray");

    showDialog(
        context: moContext,
        builder: (moContext) => WidgetDialog(
          titleWidget: titleWidget,
          icons: AssetsPath.orderCancelCartIcon,
          okButtonText: language.okay,
          closeButtonText: "",
          isSingleButton: true,
          isBothButtonHide: false,
          isCloseDialog: false,
          onPositivePressed: () async {
            //close screen
            Navigator.of(moContext).pop();
            if(mapData['from'].toString() == "orderListing"){
              Get.back();
            }else {
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

  @protected
  @mustCallSuper
  void dispose() {
    print("dispose");
    // controller.timer?.cancel();
  }
}