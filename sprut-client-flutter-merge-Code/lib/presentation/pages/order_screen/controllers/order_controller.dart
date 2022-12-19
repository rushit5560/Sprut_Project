import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';

import '../../../../data/models/available_cities_model/available_cities_model.dart';
import '../../../../data/models/oder_delivery/oder_delivery_response.dart';
import '../../../../data/models/tariff_screen_model/order_model.dart';
import '../../../../data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import '../../../../data/repositories/order_repository/order_repository.dart';
import 'package:fl_location/fl_location.dart' as fl;

import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../../tariff_screen/views/map_window/custom_info_map_window.dart';

class OrderController extends GetxController {
  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  PanelController scrollController = PanelController();

  ScrollController scrollViewController = ScrollController();

  /// [Google Maps Fields]
  Completer<GoogleMapController> gMapCompleter = Completer();
  GoogleMapController? googleMapController;
  bool isMapView = false;
  fl.LocationServicesStatus? locationServiceStatus;
  List<AvailableCitiesModel?>? allCities;
  AvailableCitiesModel? currentCity;
  CameraPosition? currentCamPosition;

  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();

  /// [Location Fields]
  PermissionStatus? permissionGranted;
  LocationData? locationData;
  Location location = new Location();
  String selectedCityCode = "";

  /// Is Location Service Enabled
  bool serviceEnabled = false;

  String orderCurrentStatus = "";

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  MarkerId? centerMarkerID;
  Set<Marker> markers = {};

  OrderRepository orderRepository = OrderRepository();

  final orderInfoDetails = Rxn<MakeOrderResponse>();

  // final data = Rxn<List<OrderModel>>();
  final data = Rxn<List<OrderModel>>();
  final isExpanded = false.obs;

  final _repository = OrderRepository();

  String _startAddress = 'A';
  String _destinationAddress = 'B';
  String? _placeDistance;
  LatLng? currentPosition;
  LatLng? storeLocation;
  LatLng? driverLocation;
  String _currentAddress = 'A';
  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  //rating
  int selectedIndex = 1;

  bool isLoading = false;
  bool isShowCancelDialog = false;

  Timer? timer;
  Timer? timer1;

  //Option Selected
  String emptyOption = "";
  RxString _optionYesOrNo = "".obs;

  String get comment => _optionYesOrNo.value;

  set optionYesOrNo(value) {
    _optionYesOrNo.value = value;
    Helpers.comment = value;
  }

  var tempCarData;

  //load more

  // At the beginning, we fetch the first 20 posts
  int page = 1;

  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int limit = 10;

  // There is next page or not
  bool hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;
  ScrollController listController = ScrollController();

  getOrders(BuildContext context) async {
    isLoading = true;
    isFirstLoadRunning = true;
    // isMapView = false;
    var orders = await _repository.fetchOrders(
        Get.find<HomeViewController>().selectedCityCode, "1");
    print("object listing------->${orders}");
    if (page == 1) {
      data.value?.clear();
    }
    data.value = orders;
    isLoading = false;
    isFirstLoadRunning = false;
    update();
  }

  //init view time call
  getOrderInfo(BuildContext context, String order_id, int firstTime) async {
    if (firstTime == 1) {
      isLoading = true;
    }

    var orderDetails = await _repository.fetchOrderInformation(
        Get.find<HomeViewController>().selectedCityCode, order_id);
    orderInfoDetails.value = MakeOrderResponse.fromJson(orderDetails);

    if (isMapView) {
      calculateDistance();
    }

    if (orderInfoDetails.value?.car != null) {
      tempCarData = orderInfoDetails.value?.car;
    }

    //orderInfoDetails.value?.deliveryStatus ==
    //             AppConstants.ORDER_STATUS_CANCELED_CLIENT ||
    if (orderInfoDetails.value?.deliveryStatus ==
        AppConstants.ORDER_STATUS_CANCELED_KITCHEN) {
      isShowCancelDialog = true;
      update();
    } else {
      isShowCancelDialog = false;
    }

    if (firstTime == 1) {
      isLoading = false;
    }
    update();
  }

  //every 5 second call
  getOrderInfoInitCall(BuildContext context, String order_id) async {
    isLoading = true;
    // MakeOrderResponse data =  MakeOrderResponse.fromJson(response.body);
    var orderDetails = await _repository.fetchOrderInformation(
        Get.find<HomeViewController>().selectedCityCode, order_id);

    isLoading = false;

    orderInfoDetails.value = MakeOrderResponse.fromJson(orderDetails);

    if (isMapView) {
      calculateDistance();
    }
    if (orderInfoDetails.value?.deliveryStatus ==
            AppConstants.ORDER_STATUS_CANCELED_CLIENT ||
        orderInfoDetails.value?.deliveryStatus ==
            AppConstants.ORDER_STATUS_CANCELED_KITCHEN) {
      isShowCancelDialog = true;
      update();
    } else {
      isShowCancelDialog = false;
    }
    update();
  }

  /// When Maps is created  below method is called
  onMapsCreated(GoogleMapController controller) async {
    isMapView = true;
    googleMapController = controller;
    customInfoWindowController.googleMapController = controller;
    //gMapCompleter.complete(controller);

    currentCamPosition = CameraPosition(
      target: LatLng(Get.find<HomeViewController>().locationData!.latitude!,
          Get.find<HomeViewController>().locationData!.longitude!),
    );

    calculateDistance();
  }

  // Method for calculating the distance between two places
  calculateDistance() async {
    try {
      if (orderInfoDetails.value != null) {
        if (orderInfoDetails.value?.addresses != null) {
          double? latPos = orderInfoDetails.value?.addresses![0].lat;
          double? lanPos = orderInfoDetails.value?.addresses![0].lon;

          double? latPos1 = orderInfoDetails.value?.addresses![1].lat;
          double? lanPos1 = orderInfoDetails.value?.addresses![1].lon;

          double? driverLat1 = orderInfoDetails.value?.car!.lat;
          double? driverLat2 = orderInfoDetails.value?.car!.lon;

          currentPosition = orderInfoDetails.value != null
              ? LatLng(latPos!.toDouble(), lanPos!.toDouble())
              : LatLng(49.2454602, 28.4876724);
          var startPlacemark = LatLng(latPos!.toDouble(), lanPos!.toDouble());
          // var destinationPlacemark = LatLng(48.3794 ,31.1656);
          var destinationPlacemark =
              LatLng(latPos1!.toDouble(), lanPos1!.toDouble());

          var driverLocation = LatLng(driverLat1!, driverLat2!);
          storeLocation = destinationPlacemark;
          // Use the retrieved coordinates of the current position,
          // instead of the address if the start position is user's
          // current position, as it results in better accuracy.
          double startLatitude = _startAddress == _currentAddress
              ? currentPosition!.latitude
              : startPlacemark.latitude;

          double startLongitude = _startAddress == _currentAddress
              ? currentPosition!.longitude
              : startPlacemark.longitude;

          double destinationLatitude = storeLocation!.latitude.toDouble();
          double destinationLongitude = storeLocation!.longitude.toDouble();

          String startCoordinatesString = '($startLatitude, $startLongitude)';
          String destinationCoordinatesString =
              '($destinationLatitude, $destinationLongitude)';

          String driverCoordinatesString =
              '($destinationLatitude, $destinationLongitude)';

          // Start Location Marker
          Marker startMarker = Marker(
            onTap: () {
              //Info window comment 29 Sep, 2022
              /* customInfoWindowController.addInfoWindow!(
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Current Address",
                            style:
                                TextStyle(fontSize: 8.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          AssetsPath.infoWindowHomeIcons,
                        ),
                        decoration: BoxDecoration(
                            color: AppThemes.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0)))),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
              ),
              LatLng(startLatitude, startLongitude));*/
            },
            markerId: MarkerId(startCoordinatesString),
            position:
                LatLng(currentPosition!.latitude, currentPosition!.longitude),
            // position: LatLng(startLatitude, startLongitude),
            // infoWindow: InfoWindow(
            //   title: "Current Address",
            //   snippet: _startAddress,
            // ),
            icon: await Helpers.bitmapDescriptorFromSvgAsset(
                Get.context!, AssetsPath.addressHomeMarker),
            //AssetsPath.addressMarker
            draggable: false,
          );

          // Destination Location Marker
          Marker destinationMarker = Marker(
            onTap: () {
              //Info windo comment 29 Sep,, 2022
              /*customInfoWindowController.addInfoWindow!(
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Destination Address",
                            style:
                                TextStyle(fontSize: 8.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          AssetsPath.infoWindowStoreIcons,
                        ),
                        decoration: BoxDecoration(
                            color: AppThemes.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0)))),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
              ),
              LatLng(destinationLatitude, destinationLongitude));*/
            },
            markerId: MarkerId(destinationCoordinatesString),
            position: LatLng(destinationLatitude, destinationLongitude),
            // infoWindow: InfoWindow(
            //   title: 'Destination Address',
            //   snippet: _destinationAddress,
            // ),
            icon: await Helpers.bitmapDescriptorFromSvgAsset(
                Get.context!, AssetsPath.addressShopMarker),
            //AssetsPath.addressMarker//AssetsPath.locationMarkerSvg
            draggable: false,
          );

          //Delvery User location
          // Destination Location Marker
          Marker deliveryBoyLocation = Marker(
            onTap: () {},
            markerId: MarkerId("car location"),
            position: LatLng(driverLocation.latitude, driverLocation.longitude),
            icon: await Helpers.bitmapDescriptorFromSvgAsset(
                Get.context!, AssetsPath.carSvg),
            //AssetsPath.addressMarker//AssetsPath.locationMarkerSvg
            draggable: false,
          );

          // Adding the markers to the list
          markers.add(startMarker);
          markers.add(destinationMarker);
          markers.add(deliveryBoyLocation);

          print(
            'START COORDINATES: ($startLatitude, $startLongitude)',
          );
          print(
            'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
          );

          // Calculating to check that the position relative
          // to the frame, and pan & zoom the camera accordingly.
          double miny = (startLatitude <= destinationLatitude)
              ? startLatitude
              : destinationLatitude;
          double minx = (startLongitude <= destinationLongitude)
              ? startLongitude
              : destinationLongitude;
          double maxy = (startLatitude <= destinationLatitude)
              ? destinationLatitude
              : startLatitude;
          double maxx = (startLongitude <= destinationLongitude)
              ? destinationLongitude
              : startLongitude;

          double southWestLatitude = miny;
          double southWestLongitude = minx;

          double northEastLatitude = maxy;
          double northEastLongitude = maxx;

          // Accommodate the two locations within the
          // camera view of the map
          // googleMapController?.animateCamera(
          //   CameraUpdate.newCameraPosition(
          //     CameraPosition(
          //       target: LatLng(destinationLatitude, destinationLongitude),
          //       zoom: 17.0,
          //     ),
          //   ),
          // );
          googleMapController?.animateCamera(
            // CameraUpdate.newCameraPosition(
            //   CameraPosition(
            //     target: LatLng(
            //         southWestLatitude,
            //         southWestLongitude),
            //     zoom: 11.0, tilt: 11.0
            //   ),
            // ),
            CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  northeast: LatLng(northEastLatitude, northEastLongitude),
                  southwest: LatLng(southWestLatitude, southWestLongitude),
                ),
                100),
          );
          update();
        }
      }

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      // );

      //Comment code for draw path
      /*await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      _placeDistance = totalDistance.toStringAsFixed(2);
      // print('DISTANCE: $_placeDistance km');
      update();*/
    } catch (e) {
      // print('DISTANCE: km ${e}');
      print(e);
    }
    update();
  }

  //
  // animateToCurrent() async {
  //   if (locationData != null) {
  //     googleMapController?.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: LatLng(
  //               Get.find<HomeViewController>().locationData!.latitude!,
  //               Get.find<HomeViewController>().locationData!.longitude!),
  //           zoom: 17.0,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAgOMMJYUIhOFW_uiRmfNFUvkMvI0t9pis", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xff8370DC),
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
  }

  updateRatingIndex(int pos) {
    if (orderCurrentStatus == "Order delivered") selectedIndex = pos;
    update();
  }

  //total amount calculate
  getTotalAmount(List<Product>? productsList) {
    if (productsList?.isNotEmpty == true) {
      num amountTotal = 0;
      for (int c = 0; c < productsList!.length; c++) {
        var amount;
        String prices = productsList[c].price!;
        // amount = (productsList[c].quantity! * double.parse(prices));
        amount = (int.parse(productsList[c].quantity.toString()) *
            double.parse(prices));
        amountTotal = amountTotal + amount;
      }
      return "${amountTotal.round().toStringAsFixed(0)}";
    }
    return "0";
  }

  double getSubTotal(List<ProductElement>? productsList) {
    if (productsList?.isNotEmpty == true) {
      double amountTotal = 0;
      for (int c = 0; c < productsList!.length; c++) {
        var amount;
        String prices = productsList[c].price!;
        amount = (int.parse(productsList[c].quantity.toString()) *
            double.parse(prices));
        amountTotal = amountTotal + amount;
        // debugPrint(amountTotal.toString());
      }
      return double.parse(amountTotal.toStringAsFixed(2));
    }
    return 0;
  }

  //cart item total counts
  String getCartItemTotalAmount(List<ProductElement>? productsList) {
    if (productsList?.isNotEmpty == true) {
      num amountTotal = 0;
      for (int c = 0; c < productsList!.length; c++) {
        var amount;
        String prices = productsList[c].price!;
        // amount = (productsList[c].quantity! * double.parse(prices));
        amount = (int.parse(productsList[c].quantity.toString()) *
            double.parse(prices));
        amountTotal = amountTotal + amount;
        debugPrint(amountTotal.toString());
      }
      return "${amountTotal.toStringAsFixed(2)}";
    }
    return "0";
  }

  String getItemPriceWith2Digit(String? price) {
    print("getItemPriceWith2Digit :: $price");
    return "${double.parse("${price.toString()}").toStringAsFixed(2)}";
  }

  double getCashback(List<ProductElement>? productsList) {
    return orderInfoDetails.value!.establishment!
        .getCashBack(getSubTotal(productsList));
  }

  double getTotal(List<ProductElement>? productsList) {
    return getSubTotal(productsList);
  }

  String getEstablishmentAddress() {
    String? establishmentAddress = "";

    if (orderInfoDetails.value?.addresses != null) {
      if (orderInfoDetails.value?.establishment?.addresses?.isNotEmpty ==
          true) {
        var length = orderInfoDetails.value?.addresses?.length;
        for (int i = 0; i < length!.toInt(); i++) {
          if (orderInfoDetails.value?.addresses![i].osmId?.isNotEmpty == true) {
            if (orderInfoDetails
                    .value?.establishment?.addresses![i].place?.street
                    .toString()
                    .isNotEmpty ==
                true) {
              establishmentAddress = orderInfoDetails
                  .value?.establishment?.addresses![i].place?.street
                  .toString();
            }

            if (orderInfoDetails
                    .value?.establishment?.addresses![i].place?.houseNumber
                    .toString()
                    .isNotEmpty ==
                true) {
              if (establishmentAddress?.isEmpty == true) {
                establishmentAddress =
                    "${orderInfoDetails.value?.establishment?.addresses![i].place?.houseNumber.toString()}";
              } else {
                establishmentAddress =
                    "$establishmentAddress, ${orderInfoDetails.value?.establishment?.addresses![i].place?.houseNumber.toString()}";
              }
            }

            if (orderInfoDetails.value?.establishment?.addresses![i].place?.name
                    .toString()
                    .isNotEmpty ==
                true) {
              if (establishmentAddress?.isEmpty == true) {
                establishmentAddress =
                    "${orderInfoDetails.value?.establishment?.addresses![i].place?.name.toString()}";
              } else {
                establishmentAddress =
                    "$establishmentAddress, ${orderInfoDetails.value?.establishment?.addresses![i].place?.name.toString()}";
              }
            }

            if (orderInfoDetails.value?.establishment?.addresses![i].place?.city
                    .toString()
                    .isNotEmpty ==
                true) {
              if (establishmentAddress?.isEmpty == true) {
                establishmentAddress =
                    "${orderInfoDetails.value?.establishment?.addresses![i].place?.city.toString()}";
              } else {
                establishmentAddress =
                    "$establishmentAddress, ${orderInfoDetails.value?.establishment?.addresses![i].place?.city.toString()}";
              }
            }
          }
        }
      }
    }
    return establishmentAddress.toString();
  }

  String getDeliveryAddress() {
    String? deliveryAddress = "";
    if (orderInfoDetails.value?.addresses?.isNotEmpty == true) {
      var length = orderInfoDetails.value?.addresses?.length;
      for (int i = 0; i < length!.toInt(); i++) {
        if (orderInfoDetails.value?.addresses![i].osmId?.isEmpty == true) {
          if (orderInfoDetails.value?.addresses![i].street
                  .toString()
                  .isNotEmpty ==
              true) {
            deliveryAddress =
                orderInfoDetails.value?.addresses![i].street.toString();
          }

          if (orderInfoDetails.value?.addresses![i].houseNumber
                  .toString()
                  .isNotEmpty ==
              true) {
            deliveryAddress =
                "$deliveryAddress, ${orderInfoDetails.value?.addresses![i].houseNumber.toString()}";
          }

          // print(
          //     "getDeliveryAddress City --> ${orderInfoDetails.value?.addresses![1].city}");
          if (orderInfoDetails.value?.addresses![i].city
                  .toString()
                  .isNotEmpty ==
              true) {
            deliveryAddress =
                "$deliveryAddress, ${orderInfoDetails.value?.addresses![i].city.toString()}";
          }
        }
      }
    }

    return deliveryAddress.toString();
  }

  //calculate free shipping
  String freeShippingAmount() {
    // debugPrint("freeShippingAmount");
    num shippingAmount = 0;
    if (double.parse(
            orderInfoDetails.value!.establishment!.minimalPrice.toString()) >
        double.parse(
            getCartItemFinalTotalAmount(orderInfoDetails.value!.products))) {
      shippingAmount = (double.parse(
              orderInfoDetails.value!.establishment!.minimalPrice!.toString()) -
          double.parse(
              getCartItemFinalTotalAmount(orderInfoDetails.value!.products)));
    }
    // debugPrint("freeShippingAmount IS --> $shippingAmount");
    return shippingAmount.toStringAsFixed(2);
  }

  String getCartItemFinalTotalAmount(List<ProductElement>? productsList) {
    if (productsList?.isNotEmpty == true) {
      num amountTotal = 0;
      for (int c = 0; c < productsList!.length; c++) {
        var amount;
        String prices = productsList[c].price!;
        // amount = (productsList[c].quantity! * double.parse(prices));
        amount = (int.parse(productsList[c].quantity.toString()) *
            double.parse(prices));
        amountTotal = amountTotal + amount;
      }
      return "${amountTotal.toStringAsFixed(2)}";
    }
    return "0";
  }

  String getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(
      List<ProductElement>? productsList) {
    num finalAmountTotal = 0;
    if (productsList?.isNotEmpty == true) {
      // if ((storeDetailsData.cashbackPercent ?? 0) > 0){
      //   finalAmountTotal = double.parse(getCartItemFinalTotalAmount()) - (getCashback());
      //   // debugPrint("$finalAmountTotal");
      //   finalAmountTotal = finalAmountTotal + double.parse(freeShippingAmount()) + storeDetailsData.calculatedPrice!.toInt();
      //   return finalAmountTotal.toStringAsFixed(2);
      // }
      finalAmountTotal =
          (double.parse(getCartItemFinalTotalAmount(productsList)) +
              double.parse(freeShippingAmount()) +
              orderInfoDetails.value!.establishment!.calculatedPrice!.toInt());
      return finalAmountTotal.toStringAsFixed(2);
    }
    return "${finalAmountTotal.toStringAsFixed(2)}";
  }

  //Cancel order
  Future<dynamic> cancelOrderCall(BuildContext context) async {
    Helpers.showCircularProgressDialog(context: context);
    var result = await orderRepository.cancelOrder(
        cityCode: Get.find<HomeViewController>().selectedCityCode,
        orderId: "${orderInfoDetails.value?.orderId}",
        deliverySta: "canceledClientPayment");
    Navigator.pop(context);
    print("Result ---> ${result}");
    return result;
  }

  shareDriverInfo(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    // var shareMsg =
    //     "Name on LIC98976545) coming now. Right now the driver at https://maps.google.com/maps?q=loc:${orderInfoDetails.value?.addresses![0].lat},${orderInfoDetails.value?.addresses![0].lon}";
    var shareMsg =
        "${orderInfoDetails.value?.car?.driverName} on ${orderInfoDetails.value?.car?.makeRaw} ${orderInfoDetails.value?.car?.modelRaw} ${orderInfoDetails.value?.car?.colorRaw} (${orderInfoDetails.value?.car?.licensePlateNumber!}) coming now. Right now the driver at https://maps.google.com/maps?q=loc:${orderInfoDetails.value?.car?.lat},${orderInfoDetails.value?.car?.lon}";

    await Share.share(
      shareMsg,
      subject: '',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  feedbackOrder(BuildContext context, bool isStats) async {
    Helpers.showCircularProgressDialog(context: context);
    await Future.delayed(Duration(seconds: 1));
    var result = await orderRepository.feedbackOrders(
        cityCode: Get.find<HomeViewController>().selectedCityCode,
        orderId: "${orderInfoDetails.value?.orderId}",
        isOrderStatus: isStats);
    print("Feed back Response ---> ${result.toString()}");

    var ratingResult = await orderRepository.ratingOrders(
        cityCode: Get.find<HomeViewController>().selectedCityCode,
        orderId: "${orderInfoDetails.value?.orderId}",
        ratingValue: selectedIndex.toString());
    print("Rating Response ---> ${ratingResult.toString()}");
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    Get.back();
  }

  //load more data
  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        listController.position.extentAfter < 300) {
      // setState(() {
      //   _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      // });
      isLoadMoreRunning = true;
      update();
      page += 1; // Increase _page by 1
      try {
        var orders = await _repository.fetchOrders(
            Get.find<HomeViewController>().selectedCityCode, "$page");

        if (orders?.isNotEmpty == true) {
          // setState(() {
          //   _posts.addAll(fetchedPosts);
          // });
          data.value?.addAll(orders!);
          update();
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          // setState(() {
          //   _hasNextPage = false;
          // });
          hasNextPage = false;
          update();
        }
      } catch (err) {
        print('Something went wrong!');
        // if (kDebugMode) {
        //   print('Something went wrong!');
        // }
      }

      isLoadMoreRunning = false;
      update();
      // setState(() {
      //   _isLoadMoreRunning = false;
      // });
    }
  }

  updateCurrentLocationMarker() async {
    if (locationData != null) {
      MarkerId markerId = MarkerId("currentlocation");
      centerMarkerID = markerId;
      LatLng position = LatLng(
          Get.find<HomeViewController>().locationData!.latitude!,
          Get.find<HomeViewController>().locationData!.longitude!);

      if (mapMarkers.keys.contains(markerId)) {
        Marker marker = mapMarkers[markerId]!.copyWith(positionParam: position);
        mapMarkers[markerId] = marker;
      } else {
        Marker marker = Marker(
          markerId: markerId,
          position: position,
          icon: await Helpers.bitmapDescriptorFromSvgAsset(
              Get.context!, AssetsPath.locationMarkerSvg),
          draggable: false,
        );
        mapMarkers[markerId] = marker;
      }

      // mapMarkers.add(marker);
      update();
    }
  }

  fetchUserLocation() async {
    serviceEnabled = await location.serviceEnabled();
    print("Locationn data 5");
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      print("Locationn data 4");
      locationServiceStatus = serviceEnabled
          ? fl.LocationServicesStatus.enabled
          : fl.LocationServicesStatus.disabled;
      if (!serviceEnabled) {
        permissionGranted = await location.hasPermission();

        update();
        return;
      }
    }
    print("Locationn data 3");
    locationServiceStatus = serviceEnabled
        ? fl.LocationServicesStatus.enabled
        : fl.LocationServicesStatus.disabled;

    print("Locationn data 2");
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("Locationn data 1 $locationServiceStatus");
    print("Locationn data 1 $permissionGranted");

    if ((permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) &&
        locationServiceStatus == fl.LocationServicesStatus.enabled) {
      Position a = await Geolocator.getCurrentPosition();
      if (a != null) {
        googleMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(a.latitude, a.longitude),
              zoom: 17.0,
            ),
          ),
        );
      }
      {}
    }
  }

  animateToCurrent() async {
    if (locationData != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData!.latitude!, locationData!.longitude!),
            zoom: 17.0,
          ),
        ),
      );
    }
  }
}
