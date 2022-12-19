import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_bloc.dart';
import 'package:sprut/business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import 'package:sprut/presentation/widgets/my_drawer/my_drawer.dart';
import 'package:sprut/resources/configs/routes/routes.dart';

import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/responsive/responsive.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../../no_internet/no_internet.dart';
import '../controllers/tariff_controller.dart';
import 'tariff_bottom/tariff_bottom_view.dart';

class TariffView extends GetView<TariffController> {
  final HomeViewController homeViewController = Get.find<HomeViewController>();

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, connectionState) {
        if (connectionState is ConnectedFailureState) {
          return NoInternetScreen(onPressed: () async {});
        }

        if (connectionState is ConnectedSucessState) {}
        return SafeArea(
          top: false,
          bottom: false,
          child: GetBuilder<TariffController>(
              init: TariffController(),
              builder: (controller) => SlidingUpPanel(
                    onPanelSlide: (value) {
                      if (!controller.isBottomSheetExpanded) {
                        if (value > 0.05) {
                          controller.isBottomSheetExpanded = true;
                          controller.update();
                        }
                      }
                    },
                    controller: controller.scrollController,
                    onPanelOpened: () {},
                    onPanelClosed: () {
                      if (controller.isBottomSheetExpanded) {
                        controller.isBottomSheetExpanded = false;
                        controller.update();
                      }
                    },
                    minHeight: _scaffoldKey.currentState != null
                        ? _scaffoldKey.currentState!.isDrawerOpen
                            ? 0
                            : MediaQuery.of(context).size.width * 0.950
                        : MediaQuery.of(context).size.width * 0.950,
                    maxHeight: MediaQuery.of(context).size.height * 0.950,
                    panel: TariffBottomView(),
                    body: WillPopScope(
                      onWillPop: () async {
                        Get.find<HomeViewController>()
                            .wheretoGoController
                            .text = "";
                        Get.offNamed(Routes.homeScreen);
                        return true;
                      },
                      child: WillPopScope(
                        onWillPop: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          return true;
                        },
                        child: Scaffold(
                            key: _scaffoldKey,
                            onDrawerChanged: (isOpened) {
                              controller.update();
                            },
                            onEndDrawerChanged: (isOpened) {
                              controller.update();
                            },
                            drawer: MyDrawer(
                              isEnable: false,
                            ),
                            resizeToAvoidBottomInset: false,
                            body: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 1.100,
                                  child: GoogleMap(
                                    zoomControlsEnabled: true,
                                    onCameraMove: (position) {
                                      controller.customInfoWindowController
                                          .onCameraMove!();
                                    },
                                    onTap: (lat) {
                                      controller.customInfoWindowController
                                          .hideInfoWindow!();
                                    },
                                    polylines: Set<Polyline>.of(
                                        controller.polylines.values),
                                    mapType: MapType.normal,
                                    compassEnabled: false,
                                    mapToolbarEnabled: false,

                                    myLocationButtonEnabled: false,

                                    // markers: value.markersSet,
                                    markers: Set<Marker>.of(
                                        controller.markers.values),

                                    initialCameraPosition: CameraPosition(
                                      target:
                                          /*(Get.find<HomeViewController>()
                                                    .locationData !=
                                                null)
                                            ? LatLng(
                                                Get.find<HomeViewController>()
                                                    .locationData!
                                                    .latitude!,
                                                Get.find<HomeViewController>()
                                                    .locationData!
                                                    .longitude!)
                                            :*/
                                          LatLng(
                                              Get.find<HomeViewController>()
                                                  .selectedCity!
                                                  .lat,
                                              Get.find<HomeViewController>()
                                                  .selectedCity!
                                                  .lon),
                                      zoom: 12.4746,
                                    ),

                                    onMapCreated: controller.onMapsCreated,

                                    // markers: Set<Marker>.of(value.markers.values),
                                    // markers: value.mapMarkers,
                                    // markers: value.markersSet,
                                    // markers: Set<Marker>.of(controller.mapMarkers.values),
                                    onCameraIdle: () {},

                                    // markers: Set.of(Marker),
                                  ),
                                ),
                                controller.mapLoading
                                    ? Positioned(
                                        top: 0,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: lottie.Lottie.asset(
                                                    'assets/images/loading1.json',
                                                    height: 10.h),
                                              ),
                                              SizedBox(
                                                height: 45.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                CustomInfoWindow(
                                  controller:
                                      controller.customInfoWindowController,
                                  height: 50,
                                  width: 310,
                                  offset: 50,
                                ),
                                Positioned(
                                  top: 10,
                                  left: 6,
                                  child: SafeArea(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /*GestureDetector(
                                          onTap: () {
                                            _scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                          child: Container(
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.menu,
                                                    color: Colors.white,
                                                    size: 7.w,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            height: 5.h,
                                            width: 5.h,
                                            decoration: BoxDecoration(
                                                color: colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),*/

                                        GestureDetector(
                                          onTap: () {
                                            homeViewController
                                                .updateSuggestionsOnBack();
                                            Get.back();
                                            // FocusManager.instance.primaryFocus?.focus();
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        controller.locationStatusBar(context),
                                      ],
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   right: 5,
                                //   bottom:
                                //       Responsive.isSmallMobile(context) ? 14.h : 12.h,
                                //   child: controller.locationStatusBar(context),
                                // ),
                              ],
                            ),
                            backgroundColor: colorScheme.onBackground),
                      ),
                    ),
                  )),
        );
      },
    );
  }
}
