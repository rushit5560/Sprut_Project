import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import 'package:sprut/data/models/map_screen_models/cars_model/cars_model.dart';
import 'package:sprut/data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';
import 'package:sprut/data/models/tariff_screen_model/profile_model.dart';
import 'package:sprut/data/models/tariff_screen_model/service_model.dart';
import 'package:sprut/data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import 'package:sprut/data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:fl_location/fl_location.dart' as fl;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/models/tariff_screen_model/card_model.dart';
import '../../../../data/models/tariff_screen_model/recharge_model.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../views/payment/tariff_payment_recharge_view.dart';

class TariffController extends GetxController {
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
  CameraPosition? kGooglePlex;
  CameraPosition? kLake;
  List<LatLng> latlng = [];

  fl.LocationServicesStatus? locationServiceStatus;

  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();
  AvailableCitiesModel currentCity =
      Get.find<HomeViewController>().currentCity!;

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
  List<Cards> cards = [];
  Profile? _profile;
  Cards? _card;
  // List<String> comments = [
  //   "I am near",
  //   "Entrance number",
  //   "Please call me back",
  //   "Come in from the side of the"
  // ];

  DateFormat dateFormatter = DateFormat("EEEE, HH:mm");
  DateFormat timeFormatter = DateFormat("HH:mm");
  DateFormat isoFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  DateFormat isoPreFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  String formattedLocalDate(BuildContext context) {
    DateFormat dateLocalFormatter =
        DateFormat("EEEE, HH:mm", Localizations.localeOf(context).languageCode);
    return dateLocalFormatter.format(preOrderDateTime);
  }

  String formattedDate() {
    return dateFormatter.format(preOrderDateTime);
  }

  String formattedISODate() {
    return preOrderDateTime.toUtc().toIso8601String();
  }

  String formattedTime() {
    return timeFormatter.format(DateTime.now());
  }

  String formattedISOToTime(String dateTimeVal) {
    if (dateTimeVal.isEmpty) return "";
    return timeFormatter.format(DateTime.parse(dateTimeVal).toLocal());
  }

  OrderModel? _orderModel;

  OrderModel get orderModel => _orderModel!;
  set orderModel(value) => _orderModel = value;

  DateTime? _preOrderDateTime;

  DateTime get preOrderDateTime => _preOrderDateTime!;
  set preOrderDateTime(value) => _preOrderDateTime = value;

  RxBool _preOrder = false.obs;
  bool get preOrder => _preOrder.value;
  set preOrder(value) => _preOrder.value = value;

  Cards get card => _card!;
  set card(value) => _card = value;

  RxInt _balance = 0.obs;
  int get balance => _balance.value;
  set balance(value) => _balance.value = value;

  RxString _paymentType = "".obs;
  String get paymentType => _paymentType.value;
  set paymentType(value) => _paymentType.value = value;

  RxString _comment = "".obs;
  String get comment => _comment.value;
  set comment(value) {
    _comment.value = value;

    Helpers.comment = value;
    // databaseService.saveToDisk(DatabaseKeys.comments, value);
  }

  RxList<ServiceModel> _service = <ServiceModel>[].obs;
  List<ServiceModel> get service => _service;
  set service(value) {
    _service.add(value);

    Helpers.setService(_service);
    // var jsonService = jsonEncode(_service.map((e) => e.toJson()).toList());
    // databaseService.saveToDisk(DatabaseKeys.services, jsonService.toString());
  }

  set serviceRemove(ServiceModel value) {
    // _service.remove(value);
    for (int i = 0; i < _service.length; i++) {
      if (_service[i].optionId == value.optionId) {
        _service.removeAt(i);
        break;
      }
    }

    Helpers.setService(_service);
    // var jsonService = jsonEncode(_service.map((e) => e.toJson()).toList());
    // databaseService.saveToDisk(DatabaseKeys.services, jsonService.toString());
  }

  RxString _webUrl = "".obs;
  String get webUrl => _webUrl.value;
  set webUrl(value) => _webUrl.value = value;

  RxString _orderId = "".obs;
  String get orderId => _orderId.value;
  set orderId(value) => _orderId.value = value;

  String balanceTitle = "balance";
  String cashTitle = "cash";
  String cardTitle = "card";

  TextEditingController commentController = new TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  TextEditingController whereToAriveEdtingController =
      new TextEditingController();
  TextEditingController wheretoGoController = new TextEditingController();

  bool isRepeatOrderModel = false;

  getTariffOptions() async {
    tariffs = await tariffScreenRepository.fetchTariffsOptions(
        cityCode: Get.find<HomeViewController>().selectedCityCode);
    update();

    if (isRepeatOrderModel && Helpers.repeatOrderModel != null) {
      String? repeatFareOption = Helpers.repeatOrderModel!.rate!.optionId;

      if (repeatFareOption != null && repeatFareOption != "") {
        int defaultIndex = tariffs
            .indexWhere((element) => element.optionId == repeatFareOption);

        if (defaultIndex != -1) {
          TariffOption tariffDefault = tariffs[defaultIndex];

          tariffs.removeAt(defaultIndex);

          tariffs.insert(0, tariffDefault);
        }
      }
    } else {
      String? defaultFare =
          databaseService.getFromDisk(DatabaseKeys.defaultFare);
      if (defaultFare != null && defaultFare != "") {
        int defaultIndex =
            tariffs.indexWhere((element) => element.optionId == defaultFare);

        if (defaultIndex != -1) {
          TariffOption tariffDefault = tariffs[defaultIndex];

          tariffs.removeAt(defaultIndex);

          tariffs.insert(0, tariffDefault);
        }
      }
    }
    update();
  }

  getProfile() async {
    _profile = await tariffScreenRepository.fetchProfile();
    if (isRepeatOrderModel && Helpers.repeatOrderModel != null) {
      if (Helpers.repeatOrderModel!.paymentType != null &&
          Helpers.repeatOrderModel!.paymentType != "") {
        if (Helpers.repeatOrderModel!.isCardPay!) {
          paymentType = Helpers.repeatOrderModel!.paymentType;
        } else {
          paymentType = "cash";
        }
      }
    }

    if (paymentType.isEmpty) {
      paymentType = _profile?.paymentType;
    }

    if (paymentType.isEmpty) {
      paymentType = cashTitle;
    }
    balance = _profile?.balance;
    update();
  }

  getCards() async {
    cards = await tariffScreenRepository.fetchCards();

    for (int i = 0; i < cards.length; i++) {
      if (cards[i].cardDefault!) {
        card = cards[i];
      }
    }
    update();
  }

  getServices() async {
    services = await tariffScreenRepository.fetchServices(
        cityCode: Get.find<HomeViewController>().selectedCityCode);
    update();
  }

  addCard(BuildContext context) async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);
    RechargeModel rechargeModel = await tariffScreenRepository.addCard();

    Navigator.pop(context);

    webUrl = rechargeModel.liqpay.url;

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TariffPaymentRechargeView(),
      ),
    )
        .then((value) {
      if (value != null) {
        if (value["status"]) {
          Helpers.showCircularProgressDialog(context: context);
          try {
            getCards();
          } catch (e) {}
          Navigator.pop(context);
        }
      }
    });
  }

  updatePaymentType(
      BuildContext context, String titleType, Cards changeCard) async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    if (paymentType != titleType) {
      paymentType = titleType;
      if (paymentType == "card") {
        card = changeCard;
      }

      Helpers.showCircularProgressDialog(context: context);
      Profile profile =
          await tariffScreenRepository.updatedProfile(paymentType);
    } else {
      paymentType = titleType;
      if (paymentType == "card") {
        card = changeCard;
      }

      Helpers.showCircularProgressDialog(context: context);
    }

    if (paymentType == "card" && !card.cardDefault!) {
      card = await tariffScreenRepository.defaultCard("${card.id!}");

      List<Cards> _cardsFetch = [];

      for (int i = 0; i < cards.length; i++) {
        if (card.id == cards[i].id) {
          cards[i] = cards[i].copyWith(cardDefault: true);
        } else {
          cards[i] = cards[i].copyWith(cardDefault: false);
        }
        update();
      }
    }

    update();

    Navigator.pop(context);
  }

  createOrder(BuildContext context) async {
    if (paymentType.isEmpty) {
      Helpers.showSnackBar(context, "Please select the payment type");
      return;
    }

    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);

    DecodedAddress? decodedArrivalAddress;
    DecodedAddress? decodedDestinationAddress;
    try {
      decodedArrivalAddress = await mainScreenRepostory.reverseGeoCoding(
          latitude: arrivalAddress.lat!,
          longitude: arrivalAddress.lon!,
          cityCode: Get.find<HomeViewController>().selectedCityCode);
    } catch (e) {}

    try {
      decodedDestinationAddress = await mainScreenRepostory.reverseGeoCoding(
          latitude: destinationAddress.lat!,
          longitude: destinationAddress.lon!,
          cityCode: Get.find<HomeViewController>().selectedCityCode);
    } catch (e) {}

    var fromAddress = {};
    if (decodedArrivalAddress != null) {
      fromAddress = decodedArrivalAddress.toJson();
    } else {
      fromAddress = arrivalAddress.toJson();
    }

    var toAddress = {};
    if (decodedDestinationAddress != null) {
      toAddress = decodedDestinationAddress.toJson();
    } else {
      toAddress = destinationAddress.toJson();
    }

    dynamic data;
    List<String> optionIds = _service.map((e) => e.toIdJson()).toList();
    if (preOrder) {
      ServiceModel preOrderServiceModel =
          services.singleWhere((element) => element.code == "preorder");

      if (!optionIds.contains(preOrderServiceModel.toIdJson())) {
        optionIds.add(preOrderServiceModel.toIdJson());
      }

      data = {
        "comment": commentController.text.trim(),
        "rateId": tariffs[selectedIndex].optionId,
        "optionsIds": optionIds,
        "addresses": [fromAddress, toAddress],
        "preorderTime": formattedISODate(),
      };
    } else {
      data = {
        "comment": commentController.text.trim(),
        "rateId": tariffs[selectedIndex].optionId,
        "optionsIds": optionIds,
        "addresses": [fromAddress, toAddress],
      };
    }
    print("heredata ${data}");
    OrderModel orderModel = await tariffScreenRepository.createOrder(
        cityCode: Get.find<HomeViewController>().selectedCityCode, data: data);

    if (orderModel.orderId!.isNotEmpty) {
      Navigator.pop(context);
      this.orderModel = orderModel;
      orderId = orderModel.orderId;

      if (preOrder) {
        databaseService.saveToDisk(DatabaseKeys.preorder, "1");
      } else {
        databaseService.saveToDisk(DatabaseKeys.preorder, "");
      }

      databaseService.saveToDisk(
          DatabaseKeys.order, jsonEncode(orderModel.toJson()));
      databaseService.saveToDisk(
          DatabaseKeys.arrivalAddress, jsonEncode(arrivalAddress.toJson()));
      databaseService.saveToDisk(DatabaseKeys.destinationAddress,
          jsonEncode(destinationAddress.toJson()));

      databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
      databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

      await tariffScreenRepository.addPaymentOrder(
          cityCode: Get.find<HomeViewController>().selectedCityCode,
          orderId: orderId,
          paymentType: paymentType);

      isBottomSheetExpanded = false;
      scrollController.close();

      await Get.toNamed(Routes.searchView);
    } else {
      Navigator.pop(context);
      Helpers.showSnackBar(context, "Failed to create order");
    }
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

    // gMapCompleter.complete(controller);
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
          //             width: 7,
          //           ),
          //           Expanded(
          //             child: Text(
          //               destinationAddress.name!,
          //               style:
          //                   TextStyle(fontSize: 10.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     LatLng(position1.latitude, position1.longitude));
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
      // LatLng position2 = LatLng(currentCity.lat, currentCity.lon);

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
          //               style:
          //                   TextStyle(fontSize: 10.sp, color: Colors.black),
          //             ),
          //           ),
          //           edit()
          //         ],
          //       ),
          //       color: Colors.white,
          //     ),
          //     LatLng(position2.latitude, position2.longitude));

          // update();
        },
        markerId: markerId2,
        position: LatLng(destinationAddress.lat!, destinationAddress.lon!),
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
          //     LatLng(position1.latitude, position1.longitude));

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
          //     LatLng(destinationAddress.lat!, destinationAddress.lon!));
          // update();
        },
        markerId: markerId2,
        position: LatLng(destinationAddress.lat!, destinationAddress.lon!),
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
      googleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentCity.lat, currentCity.lon),
            zoom: 17.0,
          ),
        ),
      );
      // }
      update();
    });

    update();

    mapLoading = false;
  }

  getCars() async {
    var req = await mapScreenRepository.fetchCars(
        cityCode: Get.find<HomeViewController>().selectedCityCode);
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
          locationData = currentLocation;
          updateCurrentLocationMarker();
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
        cityCode: Get.find<HomeViewController>().selectedCityCode);

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
        locationData = currentLocation;
        // updateCurrentLocationMarker();
        // Use current location
      });
      // currentLocationString = await decodeLocationString(
      //   LatLng(locationData!.latitude!, locationData!.longitude!),
      // );
      update();
      // updateCurrentLocationMarker();
    }
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;
    print('herelatlngbound');
    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
      print('herelatlngbound1');
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
      print('herelatlngbound2');
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
      print('herelatlngbound3');
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
      print('herelatlngbound4');
    }

    LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 80);

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
    print('herelatlngbound5');
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      print('herelatlngbound6');
      return checkCameraLocation(cameraUpdate, mapController, centerBounds);
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
    if (locationServiceStatus == fl.LocationServicesStatus.enabled) {
      return locationState.Permission_Service;
    }
    if ((permissionGranted == null) || locationServiceStatus == null) {
      return locationState.Uknown;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    _preOrderDateTime = DateTime.now().add(Duration(minutes: 30));

    Future.delayed(Duration(seconds: 10), () {
      mapLoading = false;
      update();
    });
    arrivalAddress = Get.arguments['arrivalAddress'];
    log("arrival address ${arrivalAddress.lat}");
    log("arrival address ${arrivalAddress.lon}");
    print(arrivalAddress);
    destinationAddress = Get.arguments['destinationAddress'];
    log("destination address ${destinationAddress.lat}");
    log("destination address ${destinationAddress.lon}");
    print(destinationAddress);
    update();
    kLake = Get.arguments['kLake'];
    kGooglePlex = Get.arguments['kGooglePlex'];
    scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "tariffSelectionKey");

    try {
      isRepeatOrderModel = Get.arguments['repeatOrder'] ?? false;
    } catch (e) {}

    getTariffOptions();

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

    location.onLocationChanged.listen((LocationData currentLocation) {
      locationData = currentLocation;
      updateCurrentLocationMarker();
      // Use current location
    });

    updateCars();

    bool _status = await fl.FlLocation.isLocationServicesEnabled;
    if (_status) {
      locationServiceStatus = fl.LocationServicesStatus.enabled;
    } else {
      locationServiceStatus = fl.LocationServicesStatus.disabled;
    }
    fl.FlLocation.getLocationServicesStatusStream().listen((event) {
      locationServiceStatus = event;
      update();
    });

    whereToAriveEdtingController.text =
        Get.find<HomeViewController>().cache["whereToArriveControllerText"];
    wheretoGoController.text =
        Get.find<HomeViewController>().cache["whereToGoControllerText"];

    if (isRepeatOrderModel && Helpers.repeatOrderModel != null) {
      Helpers.comment = Helpers.repeatOrderModel!.comment ?? "";
      Helpers.service = Helpers.repeatOrderModel!.options ?? [];

      if (Helpers.repeatOrderModel!.preOrderTime != null &&
          Helpers.repeatOrderModel!.preOrderTime != "") {
        DateTime preOrderDateTimeNew =
            DateTime.parse(Helpers.repeatOrderModel!.preOrderTime!).toLocal();

        if (preOrderDateTimeNew.compareTo(_preOrderDateTime!) == -1) {
          preOrderDateTime = _preOrderDateTime;
        } else {
          preOrderDateTime = preOrderDateTimeNew;
        }

        preOrder = true;
      }
    }

    _comment.value = Helpers.comment;
    commentController.text = Helpers.comment;
    _service.addAll(Helpers.service);

    // if (databaseService.getFromDisk(DatabaseKeys.comments) != null) {
    //   _comment.value = databaseService.getFromDisk(DatabaseKeys.comments);
    //   commentController.text =
    //       databaseService.getFromDisk(DatabaseKeys.comments);
    // }

    // if (databaseService.getFromDisk(DatabaseKeys.services) != null) {
    //   _service.value = List<ServiceModel>.from(
    //     jsonDecode(databaseService.getFromDisk(DatabaseKeys.services)).map(
    //       (x) => ServiceModel.fromJson(x),
    //     ),
    //   );
    // }

    getProfile();
    getCards();
    getServices();

    super.onInit();
  }

  locationStatusBar(context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    if (getLocationState() == locationState.Uknown) {
      return Container();
    }
    if (getLocationState() == locationState.Permission_Service) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    updateCameraLocation(
                        LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                        LatLng(
                            destinationAddress.lat!, destinationAddress.lon!),
                        googleMapController!);
                    return;
                  }
                  if (arrivalAddress.lat != 0.0 &&
                      destinationAddress.lat == 0.0) {
                    googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target:
                              LatLng(arrivalAddress.lat!, arrivalAddress.lon!),
                          zoom: 17.0,
                        ),
                      ),
                    );
                    // updateCameraLocation(LatLng(arrivalAddress.lat, arrivalAddress.lon),
                    //     LatLng(arrivalAddress.lat, arrivalAddress.lon), gMapController);
                    return;
                  }
                  if (destinationAddress.lat != 0.0 &&
                      arrivalAddress.lat == 0.0) {
                    googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                              destinationAddress.lat!, destinationAddress.lon!),
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
                  googleMapController!.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(currentCity.lat, currentCity.lon),
                        zoom: 17.0,
                      ),
                    ),
                  );
                });
              },
              child: Container(

                  // margin: EdgeInsets.only(right: 10),
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
              width: MediaQuery.of(context).size.width * 0.85,
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

  updateCars() {
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   getCars();
    //   // if (isStopped) {
    //   // timer.cancel();
    //   // }
    //   // print("Dekhi 5 sec por por kisu hy ni :/");
    // });
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

  var iconsServiceArray = [
    "preorder",
    "delivery",
  ];
  String getServiceIconExist(iconName) {
    return iconsServiceArray.indexOf(iconName) == -1
        ? 'assets/services/luggage.png'
        : 'assets/services/$iconName.png';
  }

  bool getServiceExist(serviceId) {
    bool isExist = false;
    for (int i = 0; i < _service.length; i++) {
      if (_service[i].optionId == serviceId) {
        isExist = true;
        break;
      } else if (i == _service.length - 1) {
        isExist = false;
      }
    }
    return isExist;
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
            Image.asset("assets/images/edit.png", height: 3.h),
          ],
        ),
        color: Color(0xff8370DC),
        height: 54,
        width: 70,
      ),
    );
  }
}
