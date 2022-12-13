import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import 'package:sprut/data/models/map_screen_models/cars_model/cars_model.dart';
import 'package:sprut/data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';
import 'package:sprut/data/models/tariff_screen_model/service_model.dart';
import 'package:sprut/data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import 'package:sprut/data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/tariff_screen/controllers/tariff_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:fl_location/fl_location.dart' as fl;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/tariff_screen_model/profile_model.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';

class SearchController extends GetxController {
  SearchController({this.context});

  final BuildContext? context;

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  bool mapLoading = true;
  bool isPanelSlide = false;
  bool isBottomSheetExpanded = false;
  List<TariffOption> tariffs = [];
  String? currentLocationString;
  bool serviceEnabled = false;
  PermissionStatus? permissionGranted;
  MarkerId? centerMarkerID;
  MyAddress arrivalAddress = MyAddress();
  MyAddress destinationAddress = MyAddress();
  // CameraPosition? kGooglePlex;
  // CameraPosition? kLake;
  List<LatLng> latlng = [];

  fl.LocationServicesStatus? locationServiceStatus;

  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();

  AvailableCitiesModel? currentCity;

  TariffScreenRepository tariffScreenRepository = TariffScreenRepository();
  MainScreenRepostory mapScreenRepository = MainScreenRepostory();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  PanelController scrollController = PanelController();
  LocationData? locationData;
  Completer<GoogleMapController> gMapCompleter = Completer();
  GoogleMapController? googleMapController;
  CameraPosition? initialCameraPosition;
  Location location = new Location();
  int selectedIndex = 0;
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<Car> cars = [];
  int _markerIdCounter = 0;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  List<ServiceModel> services = [];

  DateFormat dateFormatter = DateFormat("EEE, HH:mm");
  DateFormat timeFormatter = DateFormat("HH:mm");
  DateFormat isoFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

  final amountController = new TextEditingController(text: "0");
  FocusNode amountFocusNode = FocusNode();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String formattedTime(String dateTimeVal) {
    if (dateTimeVal.isEmpty) return "";

    int timeVal = DateTime.now()
        .difference(DateTime.parse(dateTimeVal).toLocal())
        .inSeconds;

    final int minutes = timeVal ~/ 60;
    final int seconds = timeVal % 60;
    return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }

  String formattedArrivedTime(String dateTimeVal) {
    if (dateTimeVal.isEmpty) return "";

    int timeVal = DateTime.now()
        .difference(DateTime.parse(dateTimeVal).toLocal())
        .inSeconds;

    final int minutes = timeVal ~/ 60;
    final int seconds = timeVal % 60;
    return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }

  String formattedISOToTime(String dateTimeVal) {
    if (dateTimeVal.isEmpty) return "";
    return timeFormatter.format(DateTime.parse(dateTimeVal).toLocal());
  }

  OrderModel? _orderModel;

  OrderModel get orderModel => _orderModel!;
  set orderModel(value) => _orderModel = value;

  RxString _status = "searching".obs;
  String get status => _status.value;
  set status(value) => _status.value = value;

  RxString _orderId = "".obs;
  String get orderId => _orderId.value;
  set orderId(value) => _orderId.value = value;

  RxString _orderCreateTime = "".obs;
  String get orderCreateTime => _orderCreateTime.value;
  set orderCreateTime(value) => _orderCreateTime.value = value;

  RxString _orderArriveTime = "".obs;
  String get orderArriveTime => _orderArriveTime.value;
  set orderArriveTime(value) => _orderArriveTime.value = value;

  RxString _orderWaitingTime = "".obs;
  String get orderWaitingTime => _orderWaitingTime.value;
  set orderWaitingTime(value) => _orderWaitingTime.value = value;

  RxString _orderRideTime = "".obs;
  String get orderRideTime => _orderRideTime.value;
  set orderRideTime(value) => _orderRideTime.value = value;

  RxInt _orderRating = 0.obs;
  int get orderRating => _orderRating.value;
  set orderRating(value) => _orderRating.value = value;

  RxString _paymentTip = "".obs;
  String get paymentTip => _paymentTip.value;
  set paymentTip(value) => _paymentTip.value = value;

  bool isDeleteApi = false;

  RxString _personalComment = "".obs;
  String get personalComment => _personalComment.value;
  set personalComment(value) {
    _personalComment.value = value;
  }

  RxList<int> _problem = <int>[].obs;
  List<int> get problem => _problem;
  set problem(value) {
    _problem.add(value);
  }

  set problemRemove(int value) {
    _problem.remove(value);
  }

  bool getProblemExist(value) {
    return _problem.indexOf(value) == -1 ? false : true;
  }

  RxString _balance = "".obs;
  String get balance => _balance.value;
  set balance(value) => _balance.value = value;

  final commentController = new TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  TextEditingController whereToAriveEdtingController =
      new TextEditingController();
  TextEditingController wheretoGoController = new TextEditingController();

  void showNotification(String title, String body) {
    try {
      flutterLocalNotificationsPlugin.show(
        123,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              "sprut_channel_id", "Sprut Notification",
              channelDescription: "Sprut",
              importance: Importance.max,
              icon: "ic_launcher",
              styleInformation: BigTextStyleInformation(body)),
        ),
      );
    } catch (e) {}
  }

  deleteOrder(BuildContext context) async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);
    isDeleteApi = true;
    try {
      await tariffScreenRepository.deleteOrder(
          cityCode: currentCity!.code, orderId: orderId);
      Navigator.pop(context);
      timer?.cancel();
    } on Exception catch (_) {
      Navigator.pop(context);
    }

    status = "";
    isBottomSheetExpanded = false;
    scrollController.close();

    databaseService.saveToDisk(DatabaseKeys.order, "");
    databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
    databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

    databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
    databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

    databaseService.saveToDisk(DatabaseKeys.preorder, "");

    Navigator.pop(context);
    isDeleteApi = false;
  }

  Timer? timer;
  updateOrderTimer() async {
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("heretimer  ${timer.tick} $status");

      String _arriveTimeCheck =
          databaseService.getFromDisk(DatabaseKeys.orderArriveTime) ?? "";
      String _rideTimeCheck =
          databaseService.getFromDisk(DatabaseKeys.orderRideTime) ?? "";

      if (status == "searching") {
        orderCreateTime = formattedTime(orderModel.createdAt!);
      } else if (status == "driver-assigned") {
        orderArriveTime = formattedISOToTime(orderModel.arrivesAt!);
      } else if (status == "arrived" && _arriveTimeCheck != "") {
        orderWaitingTime = formattedTime(
            databaseService.getFromDisk(DatabaseKeys.orderArriveTime));
      } else if (status == "transporting" && _rideTimeCheck != "") {
        orderRideTime = formattedTime(
            databaseService.getFromDisk(DatabaseKeys.orderRideTime));
      } else if (status == "completed") {
        orderArriveTime = formattedISOToTime(orderModel.arrivesAt!);
      }

      if (timer.tick % 5 == 0) {
        updateOrder();
      }
    });
  }

  updateOrder() async {
    if (!isDeleteApi) {
      try {
        OrderModel orderModel = await tariffScreenRepository.updateOrder(
            cityCode: currentCity!.code, orderId: this.orderModel.orderId!);

        if (status != orderModel.status) {
          var language = AppLocalizations.of(context!)!;
          if (orderModel.status == "driver-assigned") {
            showNotification(language.found_driver_1,
                "${orderModel.car!.driverName} ${language.found_driver_2} ${orderModel.car!.makeRaw} ${orderModel.car!.modelRaw} ${orderModel.car!.colorRaw} ${language.found_driver_3} ${timeFormatter.format(DateTime.parse(orderModel.arrivesAt!).toLocal())}");
          } else if (orderModel.status == "arrived") {
            showNotification(language.arrive_driver_1,
                "${orderModel.car!.driverName} ${language.arrive_driver_2} ${orderModel.car!.makeRaw} ${orderModel.car!.modelRaw} ${orderModel.car!.colorRaw} ${language.arrive_driver_3}");
          } else if (orderModel.status == "cancelled") {
            showNotification(
                language.cancel_driver_1, language.cancel_driver_2);
          }
        }

        status = orderModel.status;
        this.orderModel = orderModel;

        if (status == "driver-assigned" ||
            status == "arrived" ||
            status == "transporting") {
          try {
            showDriverMarker(status);
          } catch (e) {}
        }

        if (status == "searching") {
          orderCreateTime = formattedTime(orderModel.createdAt!);
        } else if (status == "driver-assigned") {
          orderArriveTime = formattedISOToTime(orderModel.arrivesAt!);
        } else if (status == "arrived") {
          int timeVal = DateTime.now()
              .difference(DateTime.parse(orderModel.arrivesAt!).toLocal())
              .inMinutes;

          if (timeVal < 0 &&
              databaseService.getFromDisk(DatabaseKeys.orderArriveTime) == "") {
            databaseService.saveToDisk(DatabaseKeys.orderArriveTime,
                DateTime.now().toUtc().toIso8601String());
          } else if (databaseService
                  .getFromDisk(DatabaseKeys.orderArriveTime) ==
              "") {
            databaseService.saveToDisk(
                DatabaseKeys.orderArriveTime, orderModel.arrivesAt!);
          }

          orderWaitingTime = formattedTime(
              databaseService.getFromDisk(DatabaseKeys.orderArriveTime));
        } else if (status == "transporting") {
          if (databaseService.getFromDisk(DatabaseKeys.orderRideTime) == "") {
            databaseService.saveToDisk(DatabaseKeys.orderRideTime,
                DateTime.now().toUtc().toIso8601String());
          }

          orderRideTime = formattedTime(
              databaseService.getFromDisk(DatabaseKeys.orderRideTime));
        } else if (status == "cancelled") {
          timer?.cancel();

          databaseService.saveToDisk(DatabaseKeys.order, "");
          databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
          databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

          databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
          databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

          databaseService.saveToDisk(DatabaseKeys.preorder, "");

          status = "";
          isBottomSheetExpanded = false;
          scrollController.close();

          Navigator.pop(context!);
        } else if (status == "completed") {
          orderArriveTime = formattedISOToTime(orderModel.arrivesAt!);

          timer?.cancel();

          try {
            getProfile();
          } catch (e) {}
        }

        update();
      } catch (e) {}
    }
  }

  rateOrder(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (orderRating == 0) {
      resetOrder(context);
      return;
    }

    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);

    String mainProblem = "";

    if (orderRating <= 3) {
      var language = AppLocalizations.of(context)!;
      for (int i = 0; i < problem.length; i++) {
        String langValue = "";
        if (problem[i] == 0) {
          langValue = language.traffic_offence;
        } else if (problem[i] == 1) {
          langValue = language.dirty_salon;
        } else if (problem[i] == 2) {
          langValue = language.ruffled_driver;
        }

        if (mainProblem.isEmpty)
          mainProblem = langValue;
        else
          mainProblem = mainProblem + "," + langValue;
      }
      mainProblem = mainProblem + " " + personalComment.trim();
    }

    try {
      await tariffScreenRepository.orderRating(
          cityCode: currentCity!.code,
          orderId: orderId,
          rating: orderRating,
          review: mainProblem.trim());

      Navigator.pop(context);
    } on Exception catch (_) {
      Navigator.pop(context);
    }

    double tipAmount = 0;
    if (orderRating > 3) {
      if (paymentTip == "") {
        tipAmount = 0.0;
      } else if (paymentTip == "10") {
        tipAmount = 10.0;
      } else if (paymentTip == "20") {
        tipAmount = 20.0;
      } else if (paymentTip == "other" &&
          amountController.text.trim().isNotEmpty) {
        tipAmount = double.parse(amountController.text.trim().toString());
      } else {
        tipAmount = 0.0;
      }

      if (tipAmount > 0) {
        Helpers.showCircularProgressDialog(context: context);
        print("heretip  $tipAmount");
        try {
          await tariffScreenRepository.orderTip(
              cityCode: currentCity!.code, orderId: orderId, tip: tipAmount);

          Navigator.pop(context);
        } on Exception catch (_) {
          Navigator.pop(context);
        }
      }
    }

    resetOrder(context);
  }

  resetOrder(BuildContext context) {
    status = "";
    isBottomSheetExpanded = false;
    scrollController.close();

    databaseService.saveToDisk(DatabaseKeys.order, "");
    databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
    databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

    databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
    databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

    // databaseService.saveToDisk(DatabaseKeys.preorder, "");

    // try {
    //   Get.find<TariffController>().preOrder = false;
    // } catch (e) {}

    try {
      Get.find<TariffController>().getProfile();
    } catch (e) {}

    Navigator.pop(context);
  }

  cancelPreOrder() {
    databaseService.saveToDisk(DatabaseKeys.order, "");
    databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
    databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

    databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
    databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

    databaseService.saveToDisk(DatabaseKeys.preorder, "");

    try {
      Get.find<TariffController>().preOrder = false;
    } catch (e) {}
  }

  callDriver() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: orderModel.car?.driverPhoneNumber,
    );
    await launchUrl(launchUri);
  }

  shareDriverInfo(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    var shareMsg =
        "${orderModel.car?.driverName} on ${orderModel.car?.makeRaw} ${orderModel.car?.modelRaw} ${orderModel.car?.colorRaw} (${orderModel.car?.licensePlateNumber!}) coming now. Right now the driver at https://maps.google.com/maps?q=loc:${orderModel.car?.lat},${orderModel.car?.lon}";

    await Share.share(
      shareMsg,
      subject: '',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  addOrderRating(int rating) {
    orderRating = rating;
    if (!isBottomSheetExpanded) {
      scrollController.open();
      isBottomSheetExpanded = true;
    }

    update();
  }

  getProfile() async {
    try {
      Profile? _profile = await tariffScreenRepository.fetchProfile();
      if (_profile != null) {
        balance = _profile.balance;

        update();
      }
    } catch (e) {}
  }

  String markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  onMapsCreated(GoogleMapController controller) async {
    googleMapController = controller;
    customInfoWindowController.googleMapController = controller;
    update();
    // locationData = await location.getLocation();
    // initialCameraPosition = CameraPosition(
    //   target: LatLng(locationData!.latitude!, locationData!.longitude!),
    //   zoom: 17,
    // );

    if (!gMapCompleter.isCompleted) {
      gMapCompleter.complete(controller);
    } else {
      return;
    }

    await Future.delayed(Duration(milliseconds: 100), () async {});
    print("heremo");
    MarkerId markerId1 = MarkerId(markerIdVal(increment: true));
    MarkerId markerId2 = MarkerId(markerIdVal(increment: true));
    // centerMarkerID = markerId;
    print("heremo1  ${arrivalAddress.lat}  ||  ${destinationAddress.lat}");
    if (arrivalAddress.lat != 0.0 && destinationAddress.lat != 0.0) {
      LatLng position1 = LatLng(arrivalAddress.lat!, arrivalAddress.lon!);

      Marker marker1 = Marker(
        onTap: () {
          // customInfoWindowController.addInfoWindow!(
          //     Container(
          //       child: Row(
          //         children: [
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Expanded(
          //             child: Text(
          //               arrivalAddress.name!,
          //               style: TextStyle(fontSize: 8.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     position1);

          // update();
        },
        markerId: markerId1,
        position: position1,
        // infoWindow: InfoWindow(
        //     title: '✎ ${arrivalAddress.name}',
        //     onTap: () {
        //       Get.back(result: true);
        //     }),
        icon: await Helpers.bitmapDescriptorFromSvgAsset(
            Get.context!, AssetsPath.addressMarker),
        draggable: false,
      );
      markers[markerId1] = marker1;

      LatLng position2 =
          LatLng(destinationAddress.lat!, destinationAddress.lon!);

      Marker marker2 = Marker(
        onTap: () {
          // customInfoWindowController.addInfoWindow!(
          //     Container(
          //       child: Row(
          //         children: [
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Expanded(
          //             child: Text(
          //               destinationAddress.name!,
          //               style: TextStyle(fontSize: 8.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     position2);

          // update();
        },
        markerId: markerId2,
        position: position2,
        // infoWindow: InfoWindow(
        //     title: '✎ ${destinationAddress.name}',
        //     onTap: () {
        //       Get.back(result: true);
        //     }),
        icon: await Helpers.bitmapDescriptorFromSvgAsset(
            Get.context!, AssetsPath.addressMarker),
        draggable: false,
      );
      markers[markerId2] = marker2;
      Future.delayed(Duration(milliseconds: 1000), () {
        controller.showMarkerInfoWindow(marker2.markerId);
      });
    }
    if (arrivalAddress.lat != 0.0 && destinationAddress.lat == 0.0) {
      LatLng position1 = LatLng(arrivalAddress.lat!, arrivalAddress.lon!);

      Marker marker1 = Marker(
        onTap: () {
          // customInfoWindowController.addInfoWindow!(
          //     Container(
          //       child: Row(
          //         children: [
          //           SizedBox(
          //             width: 4,
          //           ),
          //           Expanded(
          //             child: Text(
          //               arrivalAddress.name!,
          //               style: TextStyle(fontSize: 8.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     position1);

          // update();
        },
        markerId: markerId1,
        position: position1,
        // infoWindow: InfoWindow(
        //     title: '✎ ${arrivalAddress.name}',
        //     onTap: () {
        //       Get.back(result: true);
        //     }),
        icon: await Helpers.bitmapDescriptorFromSvgAsset(
            Get.context!, AssetsPath.addressMarker),
        draggable: false,
      );
      markers[markerId1] = marker1;
      update();
      Future.delayed(Duration(milliseconds: 1000), () {
        controller.showMarkerInfoWindow(marker1.markerId);
      });
    }
    if (destinationAddress.lat != 0.0 && arrivalAddress.lat == 0.0) {
      LatLng position2 =
          LatLng(destinationAddress.lat!, destinationAddress.lon!);

      Marker marker2 = Marker(
        onTap: () {
          // customInfoWindowController.addInfoWindow!(
          //     Container(
          //       child: Row(
          //         children: [
          //           SizedBox(
          //             width: 7,
          //           ),
          //           Expanded(
          //             child: Text(
          //               destinationAddress.name!,
          //               style: TextStyle(fontSize: 8.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     position2);
          // update();
        },
        markerId: markerId2,
        position: position2,
        // infoWindow: InfoWindow(
        //     title: '✎ ${destinationAddress.name}',
        //     onTap: () {
        //       Get.back(result: true);
        //     }),
        icon: await Helpers.bitmapDescriptorFromSvgAsset(
            Get.context!, AssetsPath.addressMarker),
        draggable: false,
      );
      markers[markerId2] = marker2;
      update();
      Future.delayed(Duration(milliseconds: 1000), () {
        controller.showMarkerInfoWindow(marker2.markerId);
      });
    }

    print("MARKERS: ${markers.length}");
    // mapMarkers.add(marker);
    // update();

    Future.delayed(Duration(milliseconds: 2), () async {
      googleMapController = await gMapCompleter.future;
      if (destinationAddress.lat != 0.0 && arrivalAddress.lat != 0.0) {
        await updateCameraLocation(
            LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
            LatLng(destinationAddress.lat!, destinationAddress.lon!),
            googleMapController!);

        return;
      }
      if (arrivalAddress.lat != 0.0 && destinationAddress.lat == 0.0) {
        googleMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
              zoom: 17.0,
            ),
          ),
        );
        // updateCameraLocation(LatLng(arrivalAddress.lat, arrivalAddress.lon),
        //     LatLng(arrivalAddress.lat, arrivalAddress.lon), gMapController);
        return;
      }
      if (destinationAddress.lat != 0.0 && arrivalAddress.lat == 0.0) {
        googleMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(destinationAddress.lat!, destinationAddress.lon!),
              zoom: 17.0,
            ),
          ),
        );
        // updateCameraLocation(
        //     LatLng(destinationAddress.lat, destinationAddress.lon),
        //     LatLng(destinationAddress.lat, destinationAddress.lon),
        //     gMapController);
        return;
      }
      // else {
      if (currentCity != null) {
        googleMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentCity!.lat, currentCity!.lon),
              zoom: 17.0,
            ),
          ),
        );
      }
      // }
      update();
    });

    update();

    mapLoading = false;
  }

  showDriverMarker(String status) async {
    if (orderModel.car != null) {
      if (orderModel.car?.lat != 0.0 && orderModel.car?.lon != 0.0) {
        LatLng position = LatLng(orderModel.car!.lat!, orderModel.car!.lon!);

        MarkerId markerId = MarkerId("driverlocation");

        if (markers.keys.contains(markerId)) {
          Marker marker = markers[markerId]!.copyWith(positionParam: position);
          markers[markerId] = marker;
        } else {
          Marker marker = Marker(
            onTap: () {
              // customInfoWindowController.addInfoWindow!(
              //     Container(
              //       child: Row(
              //         children: [
              //           SizedBox(
              //             width: 4,
              //           ),
              //           Expanded(
              //             child: Text(
              //               orderModel.car!.driverName!,
              //               style:
              //                   TextStyle(fontSize: 8.sp, color: Colors.black),
              //             ),
              //           ),
              //           edit()
              //         ],
              //       ),
              //       color: Colors.white,
              //     ),
              //     position);
            },
            markerId: markerId,
            position: position,
            icon: await Helpers.bitmapDescriptorFromSvgAssetNew(
                Get.context!, AssetsPath.carSvg),
            draggable: false,
          );
          markers[markerId] = marker;
        }

        Future.delayed(Duration(milliseconds: 2), () async {
          googleMapController = await gMapCompleter.future;

          if (status == "driver-assigned" || status == "arrived") {
            if (arrivalAddress.lat != 0.0) {
              await updateCameraLocation(
                  LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                  position,
                  googleMapController!);
            } else {
              googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 17.0,
                  ),
                ),
              );
            }
          } else if (status == "transporting") {
            if (destinationAddress.lat != 0.0) {
              await updateCameraLocation(
                  LatLng(destinationAddress.lat!, destinationAddress.lon!),
                  position,
                  googleMapController!);
            } else {
              googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 17.0,
                  ),
                ),
              );
            }
          }
        });
      }
    }
  }

  getCars() async {
    var req = await mapScreenRepository.fetchCars(cityCode: currentCity!.code);
    if (req.runtimeType == cars.runtimeType) {
      cars = req;
      // markersSet.add(value)
      // final Uint8List markerIcon =
      //     await Helpers.getBytesFromAsset('assets/icons/car.jpg', 30);
      BitmapDescriptor markerIcon = await Helpers.getBitmapDescriptorForSVG(
          Get.context!, AssetsPath.carSvg,
          size: Size(30, 30));

      // var carIcon = await BitmapDescriptor.fromAssetImage(
      //     ImageConfiguration(devicePixelRatio: 31.2, size: Size(200, 200)),
      //     "assets/icons/car.jpg");
      // cars = [];
      for (Car car in cars) {
        MarkerId markerId = MarkerId(car.carId!);
        LatLng position = LatLng(car.lat!, car.lon!);
        Marker _marker = Marker(
          markerId: markerId,
          position: position,
          icon: markerIcon,
          // icon: BitmapDescriptor.fromBytes(markerIcon),
          draggable: false,
          rotation: car.heading != null ? car.heading!.toDouble() : 0.0,
        );
        markers[markerId] = _marker;
      }
      update();
    } else {
      if (req == 501) {
      } else {}
    }
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    update();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBVQIoxBSObiRBpQT9q-lIOZicV_ui3jj0",
        PointLatLng(arrivalAddress.lat!, arrivalAddress.lon!),
        PointLatLng(destinationAddress.lat!, destinationAddress.lon!),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      log(result.errorMessage.toString());
    }
    addPolyLine(polylineCoordinates);
  }

  /// Formatting address [based on client requirements]
  filterDecodedAddress(DecodedAddress item) {
    String name = '';
    isNotEmptyOrNull(item.street) ? name = name + '${item.street}' : '';
    isNotEmptyOrNull(item.houseNumber)
        ? name = name +
            (isNotEmptyOrNull(item.street) ? ', ' : '') +
            '${item.houseNumber}'
        : '';
    isNotEmptyOrNull(item.name)
        ? name = name +
            // (isNotEmptyOrNull(item.houseNumber) ? ', ' : '') +
            ', ${item.name}'
        : '';
    isNotEmptyOrNull(item.city)
        ? name = name +
            // (isNotEmptyOrNull(item.name) ? ', ' : '')
            ', ${item.city}'
        : '';
    if (name.endsWith(', ')) {
      name = name.replaceRange(name.length - 2, name.length, '');
    }
    if (name.startsWith(', ')) {
      name = name.replaceRange(0, 2, '');
    }
    return name;
  }

  updateCurrentLocationMarker() async {
    print("heremarker");
    if (locationData != null) {
      MarkerId markerId = MarkerId("currentlocation");
      centerMarkerID = markerId;
      LatLng position =
          LatLng(locationData!.latitude!, locationData!.longitude!);
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        icon: await Helpers.bitmapDescriptorFromSvgAsset(
            Get.context!, AssetsPath.locationMarkerSvg),
        draggable: false,
      );

      markers[markerId] = marker;
      // mapMarkers.add(marker);
      update();
    }
  }

  getLocation(from) async {
    // var rand = Random();
    // print("RequestService from GET LOCATION(MAIN MAP CONTROLLER) ${from}");

    // if (from != "init") {
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      locationServiceStatus = serviceEnabled
          ? fl.LocationServicesStatus.enabled
          : fl.LocationServicesStatus.disabled;
      if (!serviceEnabled) {
        update();
        permissionGranted = await location.hasPermission();

        return;
      }
    }
    locationServiceStatus = serviceEnabled
        ? fl.LocationServicesStatus.enabled
        : fl.LocationServicesStatus.disabled;

    // }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (locationData != null) {
      location.onLocationChanged.listen((LocationData currentLocation) {
        print("herechange");
        if (currentLocation != locationData) {
          locationData = currentLocation;
          updateCurrentLocationMarker();
        }
        // Use current location
      });
      currentLocationString = await decodeLocationString(
        LatLng(locationData!.latitude!, locationData!.longitude!),
      );
      update();
      updateCurrentLocationMarker();
    }
  }

  getLocationState() {
    if ((permissionGranted == PermissionStatus.denied ||
            permissionGranted == PermissionStatus.deniedForever ||
            permissionGranted == null) &&
        locationServiceStatus == fl.LocationServicesStatus.disabled) {
      return locationState.NoPermission_NoService;
    }
    if ((permissionGranted == PermissionStatus.denied ||
            permissionGranted == PermissionStatus.deniedForever) &&
        locationServiceStatus == fl.LocationServicesStatus.enabled) {
      return locationState.NoPermission_Service;
    }
    if ((permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) &&
        locationServiceStatus == fl.LocationServicesStatus.disabled) {
      return locationState.Permission_NoService;
    }
    if ((permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) &&
        locationServiceStatus == fl.LocationServicesStatus.enabled) {
      return locationState.Permission_Service;
    }
    if ((permissionGranted == null) || locationServiceStatus == null) {
      return locationState.Uknown;
    }
  }

  isNotEmptyOrNull(String? str) {
    if (str != null) {
      if (str.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// [Reverse Geocoding]
  decodeLocationString(LatLng latLong, {fromCenterMarker = false}) async {
    var request = await await mainScreenRepostory.reverseGeoCoding(
        latitude: latLong.latitude,
        longitude: latLong.longitude,
        cityCode: currentCity!.code);

    try {
      print(isNotEmptyOrNull(request.name)
          ? request.name
          : '' +
              (isNotEmptyOrNull(request.name) ? ', ' : '') +
              (isNotEmptyOrNull(request.city) ? request.city : ''));
      if (request.runtimeType == DecodedAddress) {
        return filterDecodedAddress(request);
      }
    } catch (e) {
      return null;
    }
  }

  // getLocation(from) async {
  //   // var rand = Random();
  //   // print("RequestService from GET LOCATION(MAIN MAP CONTROLLER) ${from}");

  //   // if (from != "init") {
  //   serviceEnabled = await location.serviceEnabled();

  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();

  //     locationServiceStatus = serviceEnabled
  //         ? fl.LocationServicesStatus.enabled
  //         : fl.LocationServicesStatus.disabled;
  //     if (!serviceEnabled) {
  //       update();
  //       permissionGranted = await location.hasPermission();

  //       return;
  //     }
  //   }
  //   locationServiceStatus = serviceEnabled
  //       ? fl.LocationServicesStatus.enabled
  //       : fl.LocationServicesStatus.disabled;

  //   // }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   locationData = await location.getLocation();

  //   if (locationData != null) {
  //     location.onLocationChanged.listen((LocationData currentLocation) {
  //       locationData = currentLocation;
  //       // updateCurrentLocationMarker();
  //       // Use current location
  //     });
  //     // currentLocationString = await decodeLocationString(
  //     //   LatLng(locationData!.latitude!, locationData!.longitude!),
  //     // );
  //     update();
  //     // updateCurrentLocationMarker();
  //   }
  // }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;
    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 110);

    return checkCameraLocation(cameraUpdate, mapController, centerBounds);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate,
      GoogleMapController mapController, LatLng centerBounds) async {
    // mapController.moveCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: centerBounds,
    //       zoom: 17.0,
    //     ),
    //   ),
    // );
    mapController.moveCamera(cameraUpdate);

    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController, centerBounds);
    }
  }

  // getLocationState() {
  //   if ((permissionGranted == PermissionStatus.denied ||
  //           permissionGranted == PermissionStatus.deniedForever ||
  //           permissionGranted == null) &&
  //       locationServiceStatus == fl.LocationServicesStatus.disabled) {
  //     return locationState.NoPermission_NoService;
  //   }
  //   if ((permissionGranted == PermissionStatus.denied ||
  //           permissionGranted == PermissionStatus.deniedForever) &&
  //       locationServiceStatus == fl.LocationServicesStatus.enabled) {
  //     return locationState.NoPermission_Service;
  //   }
  //   if ((permissionGranted == PermissionStatus.granted ||
  //           permissionGranted == PermissionStatus.grantedLimited) &&
  //       locationServiceStatus == fl.LocationServicesStatus.disabled) {
  //     return locationState.Permission_NoService;
  //   }
  //   if (locationServiceStatus == fl.LocationServicesStatus.enabled) {
  //     return locationState.Permission_Service;
  //   }
  //   if ((permissionGranted == null) || locationServiceStatus == null) {
  //     return locationState.Uknown;
  //   }
  // }

  @override
  void onInit() async {
    super.onInit();

    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      currentCity = AvailableCitiesModel.fromJson(jsonDecode(
          databaseService.getFromDisk(DatabaseKeys.selectedCity) ?? ''));
    }

    String orderGet = databaseService.getFromDisk(DatabaseKeys.order);
    if (orderGet != "") {
      orderModel = OrderModel.fromJson(jsonDecode(orderGet));
      log("ordermodele     ${orderModel.deliveryStatus}");
      log("ordermodele1111111    ${orderModel}");

      orderId = orderModel.orderId;

      orderCreateTime = formattedTime(orderModel.createdAt!);

      updateOrder();

      updateOrderTimer();
    }

    if (databaseService.getFromDisk(DatabaseKeys.arrivalAddress) != "") {
      arrivalAddress = MyAddress.fromJson(
          jsonDecode(databaseService.getFromDisk(DatabaseKeys.arrivalAddress)));

      whereToAriveEdtingController.text = arrivalAddress.name!;
    }

    if (databaseService.getFromDisk(DatabaseKeys.destinationAddress) != "") {
      destinationAddress = MyAddress.fromJson(jsonDecode(
          databaseService.getFromDisk(DatabaseKeys.destinationAddress)));

      wheretoGoController.text = destinationAddress.name!;
    }

    Future.delayed(Duration(seconds: 8), () {
      mapLoading = false;
      update();
    });

    update();
    // kLake = Get.arguments['kLake'];
    // kGooglePlex = Get.arguments['kGooglePlex'];
    scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "SearchSelectionKey");

    // _addMarker(LatLng(arrivalAddress.lat!, arrivalAddress.lon!), "origin",
    //     BitmapDescriptor.defaultMarker);

    // /// destination marker
    // _addMarker(LatLng(destinationAddress.lat!, destinationAddress.lon!),
    //     "destination", BitmapDescriptor.defaultMarkerWithHue(90));

    getDirections();
    // // getCars();

    getLocation("init");

    // _conStatus = ConnectionUtil.getInstance();
    // _conStatus.initialize();

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   locationData = currentLocation;
    //   updateCurrentLocationMarker();
    //   // Use current location
    // });

    bool _status = await fl.FlLocation.isLocationServicesEnabled;
    if (_status) {
      locationServiceStatus = fl.LocationServicesStatus.enabled;
    } else {
      locationServiceStatus = fl.LocationServicesStatus.disabled;
    }
    fl.FlLocation.getLocationServicesStatusStream().listen((event) {
      if (locationServiceStatus != event) {
        print("herelocation");
        locationServiceStatus = event;
        update();
      }
    });
  }

  locationStatusBar(context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    if (getLocationState() == locationState.Uknown) {
      return Container();
    }

//  if (status == "driver-assigned" ||
//             status == "arrived" ||
//             status == "transporting") {

    if (getLocationState() == locationState.Permission_Service) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                // await value.getLocation();
                // value.gMapController.animateCamera(cameraUpdate)
                updateCurrentLocationMarker();
                // animateToCurrent();
                Future.delayed(Duration(milliseconds: 500), () async {
                  googleMapController = await gMapCompleter.future;
                  if (destinationAddress.lat != 0.0 &&
                      arrivalAddress.lat != 0.0) {
                    if (orderModel.car != null) {
                      if (orderModel.car?.lat != 0.0 &&
                          orderModel.car?.lon != 0.0) {
                        LatLng positionNew =
                            LatLng(orderModel.car!.lat!, orderModel.car!.lon!);

                        if (status == "driver-assigned" ||
                            status == "arrived") {
                          updateCameraLocation(
                              LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                              positionNew,
                              googleMapController!);

                          return;
                        }

                        if (status == "transporting") {
                          updateCameraLocation(
                              LatLng(destinationAddress.lat!,
                                  destinationAddress.lon!),
                              positionNew,
                              googleMapController!);

                          return;
                        }
                      }
                    }

                    updateCameraLocation(
                        LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                        LatLng(
                            destinationAddress.lat!, destinationAddress.lon!),
                        googleMapController!);
                    return;
                  }
                  if (arrivalAddress.lat != 0.0 &&
                      destinationAddress.lat == 0.0) {
                    if (orderModel.car != null) {
                      if (orderModel.car?.lat != 0.0 &&
                          orderModel.car?.lon != 0.0) {
                        LatLng positionNew =
                            LatLng(orderModel.car!.lat!, orderModel.car!.lon!);

                        if (status == "driver-assigned" ||
                            status == "arrived") {
                          updateCameraLocation(
                              LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                              positionNew,
                              googleMapController!);

                          return;
                        }
                      }
                    }

                    googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target:
                              LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                          zoom: 17.0,
                        ),
                      ),
                    );
                    return;
                  }
                  if (destinationAddress.lat != 0.0 &&
                      arrivalAddress.lat == 0.0) {
                    if (orderModel.car != null) {
                      if (orderModel.car?.lat != 0.0 &&
                          orderModel.car?.lon != 0.0) {
                        LatLng positionNew =
                            LatLng(orderModel.car!.lat!, orderModel.car!.lon!);

                        if (status == "transporting") {
                          updateCameraLocation(
                              LatLng(destinationAddress.lat!,
                                  destinationAddress.lon!),
                              positionNew,
                              googleMapController!);

                          return;
                        }
                      }
                    }

                    googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                              destinationAddress.lat!, destinationAddress.lon!),
                          zoom: 17.0,
                        ),
                      ),
                    );

                    return;
                  }
                  // else {
                  if (currentCity != null) {
                    googleMapController!.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(currentCity!.lat, currentCity!.lon),
                          zoom: 17.0,
                        ),
                      ),
                    );
                  }
                });
              },
              child: Container(
                  padding: EdgeInsets.all(8),
                  height: 5.h,
                  width: 5.h,
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
      );
    }
    if ((getLocationState() == locationState.NoPermission_NoService) ||
        (getLocationState() == locationState.NoPermission_Service) ||
        (getLocationState() == locationState.Permission_NoService)) {
      var colorScheme = Theme.of(context).colorScheme;
      var textTheme = Theme.of(context).textTheme;

      return Container(
        // color: Colors.blue,
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6)),
                color: Color(0xfff5f5f5),
              ),
              child: Text(
                language.turnOnGPSMessage,
                style: textTheme.bodyText1!
                    .copyWith(color: AppThemes.dark, fontSize: 10.sp),
              ),
            ),
            GestureDetector(
              onTap: () async {
                getLocation("init");
              },
              child: Container(
                  width: 16.w,
                  height: 7.4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsPath.powerSvg,
                        height: 3.h,
                      ),
                    ],
                  )),
            )
          ],
        ),
      );
    }
    return Container();
  }

  var iconsArray = [
    "cargo",
    "comfort",
    "drive",
    "economy",
    "Group (map-car)",
    "promo",
    "standart",
    "van",
    "wagon",
  ];
  String getIconExist(iconName) {
    print('hereicon ${iconsArray.indexOf(iconName)}');
    return iconsArray.indexOf(iconName) == -1
        ? 'assets/tariffs/standart.png'
        : 'assets/tariffs/$iconName.png';
  }

  updateAmountController(String type) {
    String amountText = amountController.text.trim();
    var amountVal;
    if (amountText.isNotEmpty) {
      amountVal = double.parse(amountText);
    } else {
      amountVal = 0.0;
    }

    var balanceVal;
    if (balance.isNotEmpty) {
      balanceVal = double.parse(balance);
    } else {
      balanceVal = 0.0;
    }

    if (type == "add") {
      if (amountVal < balanceVal) {
        amountVal += 1.0;
      }
    } else {
      if (amountVal >= 1) {
        amountVal -= 1.0;
      }
    }

    amountController.text = amountVal.toString();
    amountController.selection = TextSelection(
      baseOffset: amountController.text.length,
      extentOffset: amountController.text.length,
    );
  }
}

class edit extends StatelessWidget {
  const edit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset("assets/images/edit.png", height: 2.5.h),
          ],
        ),
        color: Color(0xff8370DC),
        height: 36,
        width: 44,
      ),
    );
  }
}
