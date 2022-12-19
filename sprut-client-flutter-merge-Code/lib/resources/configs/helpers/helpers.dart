import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/provider/network_provider.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import 'dart:math';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:ui' as ui; //
import '../../../data/models/tariff_screen_model/order_model.dart';
import '../../../data/models/tariff_screen_model/service_model.dart';
import '../../../presentation/widgets/custom_dialog/custom_dialog.dart';
import '../../app_themes/app_themes.dart';

class Helpers {
  Helpers._();

  static List<ServiceModel> service = <ServiceModel>[];
  static String comment = "";

  static OrderModel? repeatOrderModel = null;

  static void setService(List<ServiceModel> serviceNew) {
    service.clear();

    service.addAll(serviceNew);
  }

  static final DatabaseService dataBaseService =
      serviceLocator.get<DatabaseService>();

  static systemStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      // Note RED here
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ));
  }

  static showCircularProgressDialog({required BuildContext context}) {
    return showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (_) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: WillPopScope(
              onWillPop: () {
                return Future.value(true);
              },
              child: Center(
                child: Lottie.asset('assets/images/loading1.json'),
              ),
            ),
          );
        });
  }

  static showCustomMessageDialog(context, message) {
    showDialog(
        context: context,
        builder: (context) {
          return MyCustomDialog(
            message: message,
          );
        });
  }

  static showSnackBar(BuildContext context, String message) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500),
    )));
  }

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static void internetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context1) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        child: Container(
          height: 180.0,
          width: 280.0,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Please check your internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppThemes.darkGrey,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context1);
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.fromWidth(120)),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                      ),
                    ),
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  static get getSecureHeaders => {
        "x-api-key": NetworkProviderRest.apiKey,
        "Content-Type": "application/json",
        "x-session-token":
            dataBaseService.getFromDisk(DatabaseKeys.sessionToken),
      };

  //Food Delivery
  static get getSecureHeaders1 => {
        "x-api-key": NetworkProviderRest.apiKey1,
        "Content-Type": "application/json",
        "x-session-token":
            dataBaseService.getFromDisk(DatabaseKeys.sessionToken),
      };

  //End

  static submitCity({required AvailableCitiesModel city}) {
    dataBaseService.saveToDisk(
        DatabaseKeys.selectedCity, jsonEncode(city.toJson()));
  }

  static saveTypeOfView() {
    dataBaseService.saveToDisk(
        DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
    dataBaseService.saveToDisk(
        DatabaseKeys.isLoginTypeSelected, AppConstants.TAXI_APP);
  }

  static String getSubmitCity() {
    AvailableCitiesModel selectedCity = AvailableCitiesModel.fromJson(
        jsonDecode(dataBaseService.getFromDisk(DatabaseKeys.selectedCity)));
    return selectedCity.name;
  }

  static getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  static bool isLoggedIn() {
    return dataBaseService.getFromDisk(DatabaseKeys.isLoggedIn) ?? false;
  }

  static clearUser() {
    dynamic workAddress =
        dataBaseService.getFromDisk(DatabaseKeys.userWorkAddress);
    dynamic homeAddress =
        dataBaseService.getFromDisk(DatabaseKeys.userHomeAddress);

    dynamic homeAddressLat =
        dataBaseService.getFromDisk(DatabaseKeys.homeAddressLatitude);
    dynamic homeAddressLong =
        dataBaseService.getFromDisk(DatabaseKeys.homeAddressLongitude);

    dynamic workAddressLat =
        dataBaseService.getFromDisk(DatabaseKeys.workAddressLatitude);
    dynamic mworkAddressLong =
        dataBaseService.getFromDisk(DatabaseKeys.workAddressLongitude);

    dataBaseService.clearStorage();

    dataBaseService.saveToDisk(DatabaseKeys.userHomeAddress, homeAddress);
    dataBaseService.saveToDisk(DatabaseKeys.userWorkAddress, workAddress);

    dataBaseService.saveToDisk(
        DatabaseKeys.homeAddressLatitude, homeAddressLat);
    dataBaseService.saveToDisk(
        DatabaseKeys.homeAddressLongitude, homeAddressLong);

    dataBaseService.saveToDisk(
        DatabaseKeys.workAddressLatitude, workAddressLat);
    dataBaseService.saveToDisk(
        DatabaseKeys.workAddressLongitude, mworkAddressLong);

    dataBaseService.saveToDisk(DatabaseKeys.userDeliverBuildingAddress, "null");
    dataBaseService.saveToDisk(DatabaseKeys.userDeliverAddress, "null");
    dataBaseService.saveToDisk(DatabaseKeys.recentlySearchAddress, "null");
    dataBaseService.saveToDisk(DatabaseKeys.saveDeliverAddress, "null");
    dataBaseService.saveToDisk(DatabaseKeys.saveCurrentAddress, "null");
    dataBaseService.saveToDisk(DatabaseKeys.saveCurrentLat, "");
    dataBaseService.saveToDisk(DatabaseKeys.saveCurrentLang, "");
    dataBaseService.saveToDisk(DatabaseKeys.saveCard, "");
    dataBaseService.saveToDisk(DatabaseKeys.isLocationStatus, false);
    dataBaseService.saveToDisk(
        DatabaseKeys.isLoginTypeIn, AppConstants.TAXI_APP);
    dataBaseService.saveToDisk(
        DatabaseKeys.isLoginTypeSelected, AppConstants.TAXI_APP);
    dataBaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
    dataBaseService.saveToDisk(DatabaseKeys.cartObject, "");
    dataBaseService.saveToDisk(DatabaseKeys.establishmentObject, "");
    dataBaseService.saveToDisk(DatabaseKeys.lastStatus, "");
    dataBaseService.saveToDisk(DatabaseKeys.paymentMethod, "");
    dataBaseService.saveToDisk(DatabaseKeys.orderAmounts, "");
  }

  static Future<BitmapDescriptor> getBitmapDescriptorForSVG(
    BuildContext context,
    String svgAssetLink, {
    Size size = const Size(30, 30),
  }) async {
    String svgString = await DefaultAssetBundle.of(context).loadString(
      svgAssetLink,
    );
    final drawableRoot = await svg.fromSvgString(
      svgString,
      'debug: $svgAssetLink',
    );
    final ratio = ui.window.devicePixelRatio.ceil();
    final width = size.width.ceil() * ratio;
    final height = size.height.ceil() * ratio;
    final picture = drawableRoot.toPicture(
        size: Size(
          width.toDouble(),
          height.toDouble(),
        ),
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.modulate));
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uInt8List = byteData?.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uInt8List!);
  }

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        50 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 50 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAssetNew(
      BuildContext context, String assetName) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        34 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 34 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  //  static showStatelessLoader(BuildContext context) async {
  //   ProgressLoader().widgetBuilder = (context, _) => MyLoader();
  //   await ProgressLoader().show(context);
  //   // await Future<void>.delayed(Duration(seconds: 2));
  //   // await ProgressLoader().dismiss();
  // }

  //FOOD DELIVERY
  static systemStatusBar1() {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // Note RED here
    ));*/
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent, // Note RED here
    ));
  }

  static String isLoginTypeIn() {
    DatabaseService dataBaseService = serviceLocator.get<DatabaseService>();

    return dataBaseService.getFromDisk(DatabaseKeys.isLoginTypeIn) ??
        AppConstants.TAXI_APP;
  }

  static Color primaryBackgroundColor(ColorScheme color) {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? color.background
        : Colors.black;
  }

  static Color secondaryBackground() {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? Colors.white
        : AppThemes.foodBgColor;
  }

  static Color primaryTextColor() {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? AppThemes.dark
        : Colors.white;
  }

  static Color primaryLineColor() {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? AppThemes.colorBorderLine
        : AppThemes.colorBorderLine;
  }

  static Color secondaryTextColor() {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? AppThemes.dark
        : AppThemes.offWhiteColor;
  }

  static Color subtitleTextColor() {
    return Helpers.isLoginTypeIn() == AppConstants.TAXI_APP
        ? AppThemes.dark
        : AppThemes.colorTextLight;
  }

  static String priceSymbol(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return language.currency_symbol;
  }

  static String distance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'K') {
      dist = dist * 1.609344;
    } else if (unit == 'N') {
      dist = dist * 0.8684;
    }
    return dist.toStringAsFixed(2);
  }

  static double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  static double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }

  static String? getLac(BuildContext context) {
    return Localizations.maybeLocaleOf(context)?.toLanguageTag() ?? "ru";
  }

  static String? orderCreatedDate(
      BuildContext context, DateTime? datetime, String today_at) {
    Jiffy.locale(getLac(context));
    //print("Before Created Time --> ${datetime.toString()}");

    if (datetime == null) {
      return "";
    }
    DateTime? localConvertDate = datetime.toLocal();
    //print("After Created Time --> ${localConvertDate.toString()}");

    if (localConvertDate != null) {
      if (localConvertDate.day == DateTime.now().day &&
          localConvertDate.month == DateTime.now().month &&
          localConvertDate.year == DateTime.now().year) {
        var jiffy1 = Jiffy({
          "year": localConvertDate.year,
          "month": localConvertDate.month,
          "day": localConvertDate.day,
          "hour": localConvertDate.hour,
          "minute": localConvertDate.minute,
        });
        jiffy1.local();

        String timing = is24HoursFormat(context)
            ? jiffy1.format("HH:mm")
            : jiffy1.format("hh:mm a");

        return '$today_at ' + timing;
        //jiffy1.jm;
      }

      var js = Jiffy({
        "year": localConvertDate.year,
        "month": localConvertDate.month,
        "day": localConvertDate.day,
        "hour": localConvertDate.hour,
        "minute": localConvertDate.minute,
      });
      js.local();

      return is24HoursFormat(context)
          ? js.format("yyyy MMM dd, HH:mm")
          : js.format("yyyy MMM dd, hh:mm a");
    }
    //yMMMdjm
    return "No Date";
  }

  static String orderStringCreatedDate(
      BuildContext context, String? datetime, String today_at) {
    //print("orderStringCreatedDate--> ${datetime.toString()}");
    if (datetime == null) {
      return "";
    }

    if (DateTime.parse(datetime).toLocal() == DateTime.now().toLocal()) {
      String timing = is24HoursFormat(context)
          ? Jiffy(datetime).format("HH:mm")
          : Jiffy(datetime).format("hh:mm a");
      return '$today_at ' + timing;
    }

    var jiffy1 = Jiffy(datetime);
    jiffy1.local();

    // return jiffy1.yMMMdjm;
    return is24HoursFormat(context)
        ? Jiffy(datetime).format("yyyy MMM dd, HH:mm")
        : Jiffy(datetime).format("yyyy MMM dd, hh:mm a");
  }

  static String? getTimeDelivery(
      BuildContext context, DateTime? dateTime, num? times) {
    Jiffy.locale(getLac(context));
    DateTime? localConvertDate = dateTime?.toLocal();

    var jiffy1 = Jiffy({
      "year": localConvertDate?.year,
      "month": localConvertDate?.month,
      "day": localConvertDate?.day,
      "hour": localConvertDate?.hour,
      "minute": (localConvertDate?.minute)
    }).add(minutes: times!.toInt());
    jiffy1.local();
    return is24HoursFormat(context)
        ? jiffy1.format("HH:mm")
        : jiffy1.format("hh:mm a");
  }

  static bool is24HoursFormat(BuildContext context) {
    // print(
    //     "is24HoursFormat------> ${MediaQuery.of(context).alwaysUse24HourFormat}}");
    return MediaQuery.of(context).alwaysUse24HourFormat;
  }

  /*
  *     switch (index) {
      case 0:
        orderStatus = "Order preparing";
        break;
      case 1:
        orderStatus = "Order is packing";
        break;
      case 2:
        orderStatus = "Courier on the way";
        break;
      case 3:
        orderStatus = "Order cancelled";
        break;
    }
  * */

  static String getListingOrderStatus(
      BuildContext context, String? deliveryStatus, AppLocalizations language) {
    switch (deliveryStatus.toString()) {
      case "Order preparing":
        return language.txt_order_preparing;
      case "Order is packing":
        return language.txt_order_packing;
      case "Waiting for delivery partner":
        return language.txt_order_packing;
      case "Order cancelled":
        return language.txt_order_cancelled;
      case "Courier on the way":
        return language.txt_order_courier_on_the_way;
      case "Order delivered":
        return language.txt_order_delivered;
    }
    return language.txt_order_preparing;
  }

  static String? getOrderStatusByDeliveryStatus(
      BuildContext context, String? deliveryStatus, AppLocalizations language) {
    //print("getOrderStatusByDeliveryStatus :: $deliveryStatus");
    switch (deliveryStatus) {
      case AppConstants.ORDER_STATUS_NEW:
        return language.txt_order_preparing;
      case AppConstants.ORDER_STATUS_CANCELED_KITCHEN:
        return language.txt_order_cancelled;
      case AppConstants.ORDER_STATUS_NOT_ACCEPTED:
        return language.txt_order_cancelled;
      case AppConstants.ORDER_STATUS_ACCEPTED:
        return language.txt_order_preparing;
      case AppConstants.ORDER_STATUS_PAID:
        return language.txt_order_preparing;
      case AppConstants.ORDER_STATUS_PAYMENT_WAIT:
        return language.txt_order_preparing;
      case AppConstants.ORDER_STATUS_COOKING:
        return language.txt_order_preparing;
      case AppConstants.ORDER_STATUS_CANCELED_CLIENT:
        return language.txt_order_cancelled;
      case AppConstants.ORDER_STATUS_CANCELED_CLIENT_PAYMENT:
        return language.txt_order_cancelled;
      case AppConstants.ORDER_STATUS_READY_FOR_DELIVERY:
        return language.txt_order_packing; //Waiting for delivery partner
      case AppConstants.ORDER_STATUS_HANDED_TO_COURIER:
        return language.txt_order_courier_on_the_way;
      case AppConstants.ORDER_STATUS_DELIVERED:
        return language.txt_order_delivered;
      case AppConstants.ORDER_STATUS_DRIVER_ASSIGNED:
        return language.txt_order_courier_on_the_way;
      case AppConstants.ORDER_STATUS_DRIVER_ARRIVED:
        return language.txt_order_courier_on_the_way;
      case AppConstants.ORDER_STATUS_DRIVER_TRANSPORTING:
        return language.txt_order_courier_on_the_way;
      case AppConstants.ORDER_STATUS_DRIVER_SEARCHING:
        return language.txt_order_packing;
      case AppConstants.ORDER_STATUS_DRIVER_CANCELLED:
        return language.txt_order_cancelled;
    }
    return language.txt_order_preparing;
  }

  static String? getOrderStatusByDeliveryStatusDefault(
      BuildContext context, String? deliveryStatus, AppLocalizations language) {
    // print("deliveryStatus:: $deliveryStatus");
    switch (deliveryStatus) {
      case AppConstants.ORDER_STATUS_NEW:
        return "Order preparing";
      case AppConstants.ORDER_STATUS_CANCELED_KITCHEN:
        return "Order cancelled";
      case AppConstants.ORDER_STATUS_NOT_ACCEPTED:
        return "Order cancelled";
      case AppConstants.ORDER_STATUS_ACCEPTED:
        return "Order preparing";
      case AppConstants.ORDER_STATUS_PAID:
        return "Order preparing";
      case AppConstants.ORDER_STATUS_PAYMENT_WAIT:
        return "Order preparing";
      case AppConstants.ORDER_STATUS_COOKING:
        return "Order preparing";
      case AppConstants.ORDER_STATUS_CANCELED_CLIENT:
        return "Order cancelled";
      case AppConstants.ORDER_STATUS_CANCELED_CLIENT_PAYMENT:
        return "Order cancelled";
      case AppConstants.ORDER_STATUS_READY_FOR_DELIVERY:
        return "Order is packing"; //Waiting for delivery partner
      //Courier on the way
      case AppConstants.ORDER_STATUS_HANDED_TO_COURIER:
        return "Courier on the way";
      case AppConstants.ORDER_STATUS_DELIVERED:
        return "Order delivered";
      case AppConstants.ORDER_STATUS_DRIVER_ASSIGNED:
        return "Courier on the way";
      case AppConstants.ORDER_STATUS_DRIVER_ARRIVED:
        return "Courier on the way";
      case AppConstants.ORDER_STATUS_DRIVER_TRANSPORTING:
        return "Courier on the way";
      case AppConstants.ORDER_STATUS_DRIVER_SEARCHING:
        return "Order is packing";
      case AppConstants.ORDER_STATUS_DRIVER_CANCELLED:
        return "Order cancelled";
    }
    return "Order preparing";
  }

  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

//END FOOD DELIVERY

}
