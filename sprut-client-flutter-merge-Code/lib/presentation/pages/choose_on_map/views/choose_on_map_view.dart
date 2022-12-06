import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

class ChooseOnMapView extends GetView {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ChooseOnMapController controller = Get.put(ChooseOnMapController());

  final HomeViewController homeViewController = Get.put(HomeViewController());
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: GetBuilder<ChooseOnMapController>(
          builder: (_) => Scaffold(
              bottomSheet: controller.chooseOnMapBottom(context),
              key: _scaffoldKey,
              body: Stack(alignment: Alignment.center, children: [
                AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn,
                  opacity: controller.mapLoading ? 1.0 : 0,
                  child: GoogleMap(
                    markers: Set<Marker>.of(controller.mapMarkers.values),
                    mapType: MapType.normal,

                    onTap: (c) {},
                    initialCameraPosition: CameraPosition(
                      target: LatLng(homeViewController.locationData!.latitude!,
                          homeViewController.locationData!.longitude!),
                      zoom: 17.0,
                    ),
                    onMapCreated: controller.onMapsCreated,

                    onCameraIdle: () {
                      if (controller.currentCamPosition != null) {
                        controller.decodeLocationString(
                            controller.currentCamPosition!.target,
                            fromCenterMarker: true);
                      }
                      if (controller.currentCamPosition != null) {
                        if (controller.isHomeAddressScreen) {
                          log("yes home address stored in homeAddressLocationData");
                          // controller.homeAddressLocationData =
                          //     controller.currentCamPosition!.target;

                          if (controller.homeAddressLocationData != null) {
                            databaseService.saveToDisk(
                                DatabaseKeys.homeAddressLatitude,
                                controller.homeAddressLocationData!.latitude);

                            databaseService.saveToDisk(
                                DatabaseKeys.homeAddressLongitude,
                                controller.homeAddressLocationData!.longitude);
                          }
                        } else if (controller.isWorkAddressScreen) {
                          log("yes work address is stored in work address location data");
                          // controller.workAddressLocationData =
                          //     controller.currentCamPosition!.target;

                          if (controller.homeAddressLocationData != null) {
                            databaseService.saveToDisk(
                                DatabaseKeys.workAddressLatitude,
                                controller.homeAddressLocationData!.latitude);

                            databaseService.saveToDisk(
                                DatabaseKeys.workAddressLatitude,
                                controller.homeAddressLocationData!.longitude);
                          }
                        }
                      }

                      /// for showing previous selected address in choose in map screen where to arive field
                    },
                    onCameraMove: (CameraPosition position) {
                      controller.currentCamPosition = position;
                      if (controller.mapMarkers.length > 0) {
                        controller.updateControllerCache();
                        controller.update();
                      }

                      // if (controller.currentCamPosition != null) {
                      //   if (controller.isHomeAddressScreen) {
                      //     log("yes home address stored in homeAddressLocationData");
                      //     controller.homeAddressLocationData =
                      //          controller.currentCamPosition!.target;
                      //     databaseService.saveToDisk(
                      //         DatabaseKeys.homeAddressLocationData,
                      //         controller.currentCamPosition!.target);
                      //   } else if (controller.isWorkAddressScreen) {
                      //     log("yes work address is stored in work address location data");
                      //     controller.workAddressLocationData =
                      //         controller.currentCamPosition!.target;
                      //     databaseService.saveToDisk(
                      //         DatabaseKeys.workAddressLocationData,
                      //         controller.currentCamPosition!.target);
                      //   }
                      // }
                    },
                    // markers: Set.of(Marker),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(0, -34),
                    child: Image.asset(
                      AssetsPath.pointer,
                      height: 50,
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    left: 6,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 7.w,
                          ),
                          height: 5.h,
                          width: 5.h,
                          decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    )),
                // Positioned(
                //   top: 5,
                //   child: SafeArea(
                //     child: GestureDetector(
                //       onTap: () {
                //         context
                //             .read<AuthBloc>()
                //             .add(AuthAvailableCitiesEvent());
                //         showCupertinoModalBottomSheet(
                //           expand: false,
                //           enableDrag: true,
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(14)),
                //           context: context,
                //           builder: (context) => SafeArea(
                //               child: SelectCities(
                //             isChooseMapScreen: true,
                //           )),
                //         );
                //       },
                //       child: Container(
                //         child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Obx(() => Text(
                //                     controller.selectCityName.value,
                //                     style: textTheme.bodyText1!.copyWith(
                //                         fontSize: 10.sp,
                //                         color: Colors.black),
                //                   )),
                //               Icon(
                //                 Icons.keyboard_arrow_down,
                //                 color: AppThemes.dark,
                //                 size: 30,
                //               )
                //             ]),
                //         decoration: BoxDecoration(
                //             color: colorScheme.primary.withOpacity(0.7),
                //             borderRadius: BorderRadius.circular(8)),
                //         height: 5.h,
                //         width: 27.w,
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                    right: 5,
                    bottom: 22.h,
                    child: controller.locationStatusBar(context))
              ]),
              backgroundColor: colorScheme.onBackground)),
    );
  }
}
