import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import 'package:sprut/data/models/map_screen_models/cars_model/cars_model.dart';
import 'package:sprut/data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import 'package:sprut/data/models/map_screen_models/last_route_model/last_route_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/data/models/map_screen_models/order/order.dart';
import 'package:sprut/data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import 'package:sprut/data/provider/map_screen_provider/map_screen_provider.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';

import '../../models/tariff_screen_model/profile_model.dart';

class MainScreenRepostory {
  DatabaseService database = serviceLocator.get<DatabaseService>();

  final MapsScreenDataProvider mainScreenProvider = MapsScreenDataProvider();

  Future<dynamic> reverseGeoCoding(
      {required double latitude, longitude, required String cityCode}) async {
    log("reverse");
    try {
      final Response response = await mainScreenProvider.reverseGeoCoding(latitude: latitude, longitude: longitude, cityCode: cityCode);
      // print('hereresponse  ${response.statusCode}');
      //print('hereresponse  $response');
      if(response.statusCode == 200) {
        if (response.data.toString() != null) {
          DecodedAddress _decodedAddress = DecodedAddress.fromJson(response.data);
          return _decodedAddress;
        }
      }else{
        DecodedAddress _decodedAddress = DecodedAddress(houseNumber: "",city: "",street: "",osmId: 0, lat: 0.0, lon: 0.0, name: "");
        return _decodedAddress;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchOsmSuggestions(
      {required String searchTerm, required String cityCode}) async {
    try {
      final Response response = await mainScreenProvider.getOsmSuggestion(
          searchTerm: searchTerm, cityCode: cityCode);

      List<SuggestionItem> _suggestionItems = [];

      List _decoded = await response.data;
      for (var item in _decoded) {
        bool isExist = false;
        SuggestionItem itemName = SuggestionItem.fromJson(item);
        for (var newItem in _suggestionItems) {
          if (itemName == newItem) {
            isExist = true;
            break;
          }
        }

        if (!isExist) {
          _suggestionItems.add(SuggestionItem.fromJson(item));
        }
      }

      return _suggestionItems;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchCars({required String cityCode}) async {
    List<Car> _cars = [];

    try {
      final Response response =
          await mainScreenProvider.getCars(cityCode: cityCode);

      List _decoded = response.data;
      for (var item in _decoded) {
        _cars.add(Car.fromJson(item));
      }
      return _cars;
    } catch (e) {
      return Future.error(e);
    }
  }

  fetchTripAddresses() async {
    var addresses = database.getFromDisk('addresses');
    if (addresses != null) {
      var decoded = await json.decode(addresses);
      // print(await addresses);
    }
    return addresses;
  }

  getAddressSuggestion(String searchTerm) async {
    List<MyAddress> addresses = [];
    var fetchedAddress = await fetchTripAddresses();
    if (fetchedAddress != null) {
      fetchedAddress = await json.decode(fetchedAddress);
      fetchedAddress.forEach((address) {
        addresses.add(MyAddress.fromJson(address));
      });
    }
    MyAddress matchedAddress =
        addresses.firstWhere((address) => address.name!.contains(searchTerm));
    if (matchedAddress != null) {
      SuggestionItem item = SuggestionItem(
        name: matchedAddress.name,
        lat: matchedAddress.lat,
        lon: matchedAddress.lon,
        houseNumber: matchedAddress.houseNo,
        street: matchedAddress.street,
        city: matchedAddress.city,
      );
      // await getLast3Addresses();

      return item;
    } else {
      // await getLast3Addresses();

      return null;
    }
  }

  saveTripAddresses(MyAddress address1, MyAddress address2) async {
    address1.timeStamp = DateTime.now();
    address2.timeStamp = DateTime.now();
    List addresses = [address1, address2];
    var fetchedAddress = await fetchTripAddresses();

    if (fetchedAddress != null) {
      fetchedAddress = await json.decode(fetchedAddress);
      fetchedAddress.forEach((address) {
        if (address['name'] != address1.name &&
            address['name'] != address2.name) {
          addresses.add(MyAddress.fromJson(address));
          print(addresses[0].runtimeType);
        }
      });
    }
    // int recurringIndex1 =
    //     addresses.indexWhere((element) => element['name'] == address1.name);

    // int recurringIndex2 =
    //     addresses.indexWhere((element) => element['name'] == address2.name);
    // if (recurringIndex1 != -1) {
    //   addresses.removeAt(recurringIndex1);
    // }
    // if (recurringIndex1 != -1) {
    //   addresses.removeAt(recurringIndex2);
    // }

    var decodedAddresses = await json.encode(addresses);

    await database.saveToDisk('addresses', decodedAddresses);
    // await _prefs.clear();
  }

  getLast3AddressSuggestions() async {
    List<MyAddress> addresses = [];
    List<SuggestionItem> suggestions = [];
    var fetchedAddress = await fetchTripAddresses();
    if (addresses != null) {
      fetchedAddress = await json.decode(fetchedAddress);
      fetchedAddress.forEach((address) {
        addresses.add(MyAddress.fromJson(address));
        // print(addresses[0].runtimeType);
      });
    }
    if (addresses.length > 0) {
      List<MyAddress> latestAddreses = [];
      // addresses.sort(()
      // print("Unsorted");
      // addresses.forEach((element) {
      //   print(element.toJson());
      // });

      addresses.sort((a, b) {
        var adate = a.timeStamp; //before -> var adate = a.expiry;
        var bdate = b.timeStamp; //var bdate = b.expiry;
        return -adate!.compareTo(bdate!);
      });
      addresses.forEach((address) {
        suggestions.add(SuggestionItem(
          name: address.name,
          lat: address.lat,
          lon: address.lon,
          houseNumber: address.houseNo,
          street: address.street,
          city: address.city,
        ));
      });
      if (suggestions.length > 3) {
        suggestions = suggestions.take(3).toList();
        return suggestions;
      } else {
        return suggestions;
      }
    } else {
      return suggestions;
    }
  }

  saveLastRouteInfo(
      {AvailableCitiesModel? city,
      TariffOption? option,
      Order? order,
      MyAddress? arrivalAddress,
      MyAddress? destinationAddress,
      CameraPosition? kLake,
      CameraPosition? kGooglePlex,
      String? routeName}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("lastRoute", routeName!);

    var _kLake = json.encode(kLake!.toMap());
    await _prefs.setString("lastKLake", _kLake);

    var _kGooglePlex = json.encode(kGooglePlex!.toMap());
    await _prefs.setString("lastKGooglePlex", _kGooglePlex);

    var _order = json.encode(order!.toJson());
    await _prefs.setString("lastOrder", _order);

    var _arrivalAddress = json.encode(arrivalAddress!.toJson());
    await _prefs.setString("lastArrivalAddress", _arrivalAddress);

    var _destinationAddress = json.encode(destinationAddress!.toJson());
    await _prefs.setString("lastDestinationAddress", _destinationAddress);

    var _city = json.encode(city!.toJson());
    await _prefs.setString("lastCity", _city);

    var _tariffOption = json.encode(option!.toJson());
    await _prefs.setString("lastTariffOption", _tariffOption);

    // var _fetchedKLake = _prefs.getString('lastKLake');
    // var fetchedKLake = await json.decode(_fetchedKLake);
    // print("FETCHED K LAKE");
    // print(fetchedKLake);

    // //  await _prefs.setString(
    // //   "order", DriverSearching.routeName);
    // var _order = json.encode(order.toJson());
    // await _prefs.setString("lastOrder", _order);
    // var _fetchedOrder = _prefs.getString('lastOrder');
    // var fetchedOrder = await json.decode(_fetchedOrder);
    // print("FETCHED K ORDER");
    // print(fetchedOrder);
  }

  clearLastRoute() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("lastOrder");
    await _prefs.remove("lastRoute");
    await _prefs.remove("lastCity");
    await _prefs.remove("lastTariffOption");
    await _prefs.remove("lastArrivalAddress");
    await _prefs.remove("lastDestinationAddress");
    await _prefs.remove("lastKLake");
    await _prefs.remove("lastKGooglePlex");

    LastRouteInfo _info = await fetchLastRouteInfo();
    print(_info.toString());
    print(_info.routeName);
  }

  fetchLastRouteInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _order = _prefs.getString('lastOrder');
    var _decodedOrder = _order == null ? null : await json.decode(_order);

    var _city = _prefs.getString('lastCity');

    var _decodedCity = _city == null ? null : await json.decode(_city);

    var _tariffOption = _prefs.getString('lastTariffOption');
    var _decodedTariffOption =
        _tariffOption == null ? null : await json.decode(_tariffOption);

    var _arrivalAddress = _prefs.getString('lastArrivalAddress');
    var _decodedArrivalAddress =
        _arrivalAddress == null ? null : await json.decode(_arrivalAddress);

    var _destinationAddress = _prefs.getString('lastDestinationAddress');
    var _decodedDestinationAddress = _destinationAddress == null
        ? null
        : await json.decode(_destinationAddress);

    var _kLake = _prefs.getString('lastKLake');
    var _decodedKLake = _kLake == null ? null : await json.decode(_kLake);

    var _kGooglePlex = _prefs.getString('lastKGooglePlex');
    var _decodedKGooglePlex =
        _kGooglePlex == null ? null : await json.decode(_kGooglePlex);

    var routeName = _prefs.getString('lastRoute');

    LastRouteInfo _info = LastRouteInfo(
      arrivalAddress: _decodedArrivalAddress == null
          ? null
          : MyAddress.fromJson(_decodedArrivalAddress),
      destinationAddress: _decodedDestinationAddress == null
          ? null
          : MyAddress.fromJson(_decodedDestinationAddress),
      city: _decodedCity == null
          ? null
          : AvailableCitiesModel.fromJson(_decodedCity),
      kGooglePlex: _decodedKGooglePlex == null
          ? null
          : CameraPosition.fromMap(_decodedKGooglePlex),
      kLake:
          _decodedKLake == null ? null : CameraPosition.fromMap(_decodedKLake),
      option: _decodedTariffOption == null
          ? null
          : TariffOption.fromJson(_decodedTariffOption),
      order: _decodedOrder == null ? null : Order.fromJson(_decodedOrder),
      routeName: routeName,
    );

    return _info;
  }

  Future<dynamic> updateToken(String token) async {
    try {
      final Response response = await mainScreenProvider.updateToken(token);

      ProfileModel profileModel = ProfileModel.fromJson(response.data);

      return profileModel.profile;
    } catch (e) {
      return Future.error(e);
    }
  }

  //Food Delivery
  //get Active counts
  Future<dynamic> getActiveCounts(String cityCode) async {
    try {
      final dynamic response = await mainScreenProvider.getActiveCounts(cityCode);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
  //End
}
