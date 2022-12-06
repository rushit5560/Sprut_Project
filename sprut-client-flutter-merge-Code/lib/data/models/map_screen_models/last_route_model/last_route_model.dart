// ignore: file_names
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/data/models/map_screen_models/order/order.dart';


class LastRouteInfo {
  String? routeName;
  TariffOption? option;
  Order? order;
  MyAddress? arrivalAddress;
  MyAddress? destinationAddress;
  CameraPosition? kLake;
  CameraPosition? kGooglePlex;
 AvailableCitiesModel? city;

  LastRouteInfo({
    this.routeName,
    this.option,
    this.order,
    this.arrivalAddress,
    this.destinationAddress,
    this.kLake,
    this.kGooglePlex,
    this.city,
  });
}
