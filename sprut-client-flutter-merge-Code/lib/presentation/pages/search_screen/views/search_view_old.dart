import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:sprut/presentation/pages/search_screen/views/search_driver/driver_arrived_view.dart';
import 'package:sprut/presentation/pages/search_screen/views/search_driver/rating_view.dart';
import 'package:sprut/presentation/pages/search_screen/views/search_driver/ride_view.dart';

import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../../../widgets/my_drawer/my_drawer.dart';
import '../../../widgets/primary_elevated_btn/primary_elevated_btn.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../controllers/search_controller.dart';
import 'search_driver/search_driver_view.dart';
import 'search_driver/search_found_view.dart';

class SearchViewOld extends GetView<SearchController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeViewController homeViewController = Get.put(HomeViewController());
  final DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        top: false,
        bottom: false,
        child: GetBuilder<SearchController>(
            init: SearchController(context: context),
            builder: (controller) {
              return Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  onDrawerChanged: (isOpened) {
                    controller.update();
                  },
                  onEndDrawerChanged: (isOpened) {
                    controller.update();
                  },
                  drawer: MyDrawer(
                    isEnable: false,
                  ),
                  body: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: SlidingUpPanel(
                          onPanelSlide: (value) {
                            if (!controller.isBottomSheetExpanded) {
                              if (value > 0.02 &&
                                  (controller.status == "searching" ||
                                      controller.status == "driver-assigned" ||
                                      controller.status == "arrived" ||
                                      controller.status == "transporting" ||
                                      controller.status == "completed")) {
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
                          minHeight: findMinHeight(context),
                          maxHeight: findMaxHeight(context),
                          panel: findStatusWidget(),
                          body: SafeArea(
                            top: false,
                            bottom: false,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: controller.status.isEmpty
                                      ? MediaQuery.of(context).size.width *
                                          1.320
                                      : (controller.status ==
                                                  "driver-assigned" ||
                                              controller.status ==
                                                  "transporting"
                                          ? MediaQuery.of(context).size.width *
                                              1.470
                                          : MediaQuery.of(context).size.width *
                                              1.600),
                                  child: GoogleMap(
                                    zoomControlsEnabled: false,
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
                                    markers: Set<Marker>.of(
                                        controller.markers.values),
                                    initialCameraPosition: CameraPosition(
                                        target: (controller.locationData !=
                                                null)
                                            ? LatLng(
                                                controller
                                                    .locationData!.latitude!,
                                                controller
                                                    .locationData!.longitude!)
                                            : LatLng(
                                                controller.currentCity!.lat,
                                                controller.currentCity!.lon)),
                                    onMapCreated: controller.onMapsCreated,
                                    onCameraIdle: () {},
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
                                if (controller.databaseService.getFromDisk(
                                            DatabaseKeys.preorder) !=
                                        "" &&
                                    controller.status != "searching")
                                  Positioned(
                                    top: 10,
                                    right: 8,
                                    child: SafeArea(
                                      child: Container(
                                        width: 12.h,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: PrimaryElevatedBtn(
                                            height: 5.h,
                                            fontSize: 10.sp,
                                            buttonText: language.done,
                                            onPressed: () {
                                              controller.cancelPreOrder();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (!controller.isBottomSheetExpanded)
                        Positioned(
                          top: 10,
                          left: 6,
                          right: 5,
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState!.openDrawer();
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
                                        if ((databaseService.getFromDisk(
                                                        DatabaseKeys
                                                            .readNews) ==
                                                    null ||
                                                (databaseService.getFromDisk(
                                                            DatabaseKeys
                                                                .readNews) !=
                                                        null &&
                                                    homeViewController
                                                            .newsCount >
                                                        databaseService
                                                            .getFromDisk(
                                                                DatabaseKeys
                                                                    .readNews))) &&
                                            homeViewController.newsCount > 0)
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              margin: const EdgeInsets.all(4.0),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                "${(databaseService.getFromDisk(DatabaseKeys.readNews) != null && homeViewController.newsCount > databaseService.getFromDisk(DatabaseKeys.readNews)) ? (homeViewController.newsCount - databaseService.getFromDisk(DatabaseKeys.readNews)).toInt() : homeViewController.newsCount}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    height: 5.h,
                                    width: 5.h,
                                    decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(5)),
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
                    ],
                  ),
                  backgroundColor: colorScheme.onBackground);
            }),
      ),
    );
  }

  double findMinHeight(BuildContext context) {
    if (controller.status == "searching")
      return MediaQuery.of(context).size.width * 0.600;
    else if (controller.status == "driver-assigned")
      return MediaQuery.of(context).size.width * 0.750;
    else if (controller.status == "arrived")
      return MediaQuery.of(context).size.width * 0.650;
    else if (controller.status == "transporting")
      return MediaQuery.of(context).size.width * 0.850;
    else if (controller.status == "completed")
      return MediaQuery.of(context).size.width * 0.650;
    else
      return MediaQuery.of(context).size.width * 0.650;
  }

  double findMaxHeight(BuildContext context) {
    if (controller.status == "searching")
      return MediaQuery.of(context).size.width * 0.900;
    else if (controller.status == "driver-assigned")
      return MediaQuery.of(context).size.width * 1.110;
    else if (controller.status == "arrived")
      return MediaQuery.of(context).size.width * 1.000;
    else if (controller.status == "transporting")
      return MediaQuery.of(context).size.width * 1.250;
    else if (controller.status == "completed") {
      if (controller.orderRating > 0 && controller.orderRating <= 3) {
        return MediaQuery.of(context).size.width * 1.900;
      } else if (controller.orderRating > 3 && controller.orderRating <= 5) {
        return MediaQuery.of(context).size.width * 1.400;
      } else {
        return MediaQuery.of(context).size.width * 1.000;
      }
    } else
      return MediaQuery.of(context).size.width * 1.000;
  }

  double findBottomMinHeight(BuildContext context) {
    if (controller.status == "searching")
      return MediaQuery.of(context).size.width * 0.350;
    else if (controller.status == "driver-assigned")
      return MediaQuery.of(context).size.width * 0.450;
    else if (controller.status == "arrived")
      return MediaQuery.of(context).size.width * 0.350;
    else if (controller.status == "transporting")
      return MediaQuery.of(context).size.width * 0.550;
    else if (controller.status == "completed")
      return MediaQuery.of(context).size.width * 0.350;
    else
      return MediaQuery.of(context).size.width * 0.350;
  }

  double findBottomMaxHeight(BuildContext context) {
    if (controller.status == "searching")
      return MediaQuery.of(context).size.width * 0.650;
    else if (controller.status == "driver-assigned")
      return MediaQuery.of(context).size.width * 0.800;
    else if (controller.status == "arrived")
      return MediaQuery.of(context).size.width * 0.700;
    else if (controller.status == "transporting")
      return MediaQuery.of(context).size.width * 0.950;
    else if (controller.status == "completed")
      return MediaQuery.of(context).size.width * 0.650;
    else
      return MediaQuery.of(context).size.width * 0.650;
  }

  Widget findStatusWidget() {
    if (controller.status == "searching")
      return SearchDriverView();
    else if (controller.status == "driver-assigned")
      return SearchFoundView();
    else if (controller.status == "arrived")
      return DriverArrivedView();
    else if (controller.status == "transporting")
      return RideView();
    else if (controller.status == "completed")
      return RatingView();
    else
      return Container();
  }
}
