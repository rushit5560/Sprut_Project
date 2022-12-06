import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fl_location/fl_location.dart' as fl;
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

import '../../../../data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import '../../../../data/models/map_screen_models/my_address_model/my_address_model.dart';
import '../../../../data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import '../../../../data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../../home_screen/controllers/home_controller.dart';

class AddressFoodSuggestionController extends GetxController {
  var tappedDeliveredAddress = "";
  var tappedBuildingAddress = "";

  bool isWhereToDeliveredSelectedFromPromt = false;
  bool isWhereToBuildingAddressSelectedFromPromt = false;

  /// Text Editing Controllers in home view

  TextEditingController whereToAddressEditingController =
      new TextEditingController();
  TextEditingController wheretoDeliverGoController =
      new TextEditingController();
  FocusNode whereToAddressFocusNode = FocusNode();
  FocusNode wheretoDeliverFocusNode = FocusNode();

  ///[food screen ]
  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();
  bool showFoodSuggestions = true;
  bool isFoodBottomSheetExpanded = true;
  bool isFoodBottomSheetTapped = false;
  bool isWhereToDeliveredFieldTapped = false;
  bool isWhereBuildingAddressTapped = false;

  bool isSaveButtonEnable = false;
  String lastSelectedAddress = "";

  ///

  var osmFoodSuggestionsFuture;
  String lastFocus = "";
  String searchTerm = "";
  String selectedCityCode = "";
  bool isHomeSuggestion = false;
  bool isWorkSuggestion = false;
  String currentAddress = "";

  MyAddress deliveredAddress = MyAddress();
  MyAddress buildingAddress = MyAddress();

  List<SuggestionItem> suggestions = [];
  List<SuggestionItem> lastThreeAddresses = [];

  ///[Recently Search List]
  List<dynamic> recentlyList = [];
  List<SuggestionItem> recentlyAddedList = [];

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  /// [Location Fields]
  PermissionStatus? permissionGranted;
  LocationData? locationData;
  Location location = new Location();
  fl.LocationServicesStatus? locationServiceStatus;

  /// Is Location Service Enabled
  bool serviceEnabled = false;

  /// [Fields of Keyboard listener]
  bool keyboardVisibility = false;

  RxString selectCityName = ''.obs;
  String? currentLocationString;

  AvailableCitiesModel? currentCity;
  AvailableCitiesModel? selectedCity;

  // Map<String, dynamic> cache = {
  //   "whereToDeliverControllerText": "",
  //   "whereToAddressControllerText": ""
  // };

  Map<String, dynamic> cacheAddress = {
    "homeAddress": "",
    "workAddress": "",
  };

  @override
  onInit() {
    super.onInit();
  }

  checkSaveDeliveryAddress() {
    // print("checkSaveDeliveryAddress");
    if (databaseService
                .getFromDisk(DatabaseKeys.saveDeliverAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress)
            .toString()
            .isNotEmpty) {
      var data = databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
      var deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));

      deliveredAddress = MyAddress(
        name: deliverAddress.name,
        // address: displayName,
        street: deliverAddress.street,
        houseNo: deliverAddress.houseNo,
        lat: deliverAddress.lat,
        lon: deliverAddress.lon,
        city: deliverAddress.city,
        cityCode: deliverAddress.cityCode,
        isSaveAddress: true,
      );
    }
  }

  fetchUserLocation(BuildContext context) async {
    /// Restoring default address of home and work
    // ChooseOnMapController chooseOnMapController =
    // Get.put(ChooseOnMapController());
    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      selectedCity = AvailableCitiesModel.fromJson(
          jsonDecode(databaseService.getFromDisk(DatabaseKeys.selectedCity)));
      if (selectedCity != null) {
        selectCityName.value = selectedCity!.name;
        currentCity = selectedCity;
        selectedCityCode = selectedCity!.code;
      }

      LatLng position = locationData != null
          ? LatLng(
              locationData!.latitude!,
              locationData!.longitude!,
            )
          : LatLng(selectedCity!.lat, selectedCity!.lon);
      // print('heredefaultlocation1  ${position.latitude} || ${position.longitude}  ${locationData}');
    }
    debugPrint("selectedCityCode::1 $selectedCityCode");

    String _homeAddress =
        databaseService.getFromDisk(DatabaseKeys.userHomeAddress) ?? "";

    // chooseOnMapController.addHomeAddressEditingController.text = _homeAddress;
    cacheAddress["homeAddress"] = _homeAddress;

    String _workAddress =
        databaseService.getFromDisk(DatabaseKeys.userWorkAddress) ?? "";

    // chooseOnMapController.addWorkAddressEditingController.text = _workAddress;
    cacheAddress["workAddress"] = _workAddress;

    update();

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      locationServiceStatus = serviceEnabled
          ? fl.LocationServicesStatus.enabled
          : fl.LocationServicesStatus.disabled;
      if (!serviceEnabled) {
        permissionGranted = await location.hasPermission();

        update();
        return;
      }
    }

    locationServiceStatus = serviceEnabled
        ? fl.LocationServicesStatus.enabled
        : fl.LocationServicesStatus.disabled;
    locationServiceStatus = serviceEnabled
        ? fl.LocationServicesStatus.enabled
        : fl.LocationServicesStatus.disabled;

    // }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted ||
          permissionGranted != PermissionStatus.grantedLimited) {
        lastSelectedAddress = "";
        return;
      }
    }

    if ((permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) &&
        locationServiceStatus == fl.LocationServicesStatus.enabled) {
      // Helpers.showCircularProgressDialog(context: Get.context!);
      locationData = await location.getLocation();
      // print('herecurrentloc  $locationData');

      // Navigator.pop(Get.context!);
      if (locationData != null) {
        databaseService.saveToDisk(
            DatabaseKeys.defaultLatitude, locationData!.latitude!);
        databaseService.saveToDisk(
            DatabaseKeys.defaultLongitude, locationData!.longitude!);

        final DecodedAddress address =
            await mainScreenRepostory.reverseGeoCoding(
                latitude: locationData!.latitude!,
                longitude: locationData!.longitude!,
                cityCode: selectedCityCode);

        String getDecAddress = filterDecodedAddress(address) ?? "";

        if (getDecAddress != "") {
          Future.delayed(Duration(milliseconds: 2), () async {
            currentAddress = getDecAddress;
            update();
          });
        }

        update();
      }
      {}
    }
    if (databaseService
        .getFromDisk(DatabaseKeys.saveDeliverAddress)
        .toString() ==
        "null" ||
        databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress)
            .toString()
            .isEmpty){
      if (locationData != null) {
        currentLocationString = await decodeLocationString(
            LatLng(locationData!.latitude!, locationData!.longitude!), false);
      }
    }
  }

  Container divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35),
      width: MediaQuery.of(context).size.width,
      height: 0.5,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
    );
  }

  updateSearchTerm(val) {
    searchTerm = val;

    log(searchTerm);
    update();
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
  //   if ((permissionGranted == PermissionStatus.granted ||
  //           permissionGranted == PermissionStatus.grantedLimited) &&
  //       locationServiceStatus == fl.LocationServicesStatus.enabled) {
  //     return locationState.Permission_Service;
  //   }
  //   if ((permissionGranted == null) || locationServiceStatus == null) {
  //     return locationState.Uknown;
  //   }
  // }

  updateSuggestions() async {
    print('heresuggestionfocus $lastFocus');
    var val = "";
    if (lastFocus == "whereToDeliver") {
      val = wheretoDeliverGoController.text;
      if (wheretoDeliverGoController.text.isEmpty) {
        suggestions = [];
        update();
        return;
      }
    }

    updateSearchTerm(val);

    updateHomeWorkSuggestion(val);

    osmFoodSuggestionsFuture = getSuggestions();
    // log("suggestions");
    // print(osmFoodSuggestionsFuture);
    update();
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

  filterSuggesstionName(SuggestionItem item) {
    // print("ITEM : ${item.toJson()}");
    String name = '';
    isNotEmptyOrNull(item.street) ? name = name + '${item.street}' : '';
    isNotEmptyOrNull(item.houseNumber)
        ? name = name +
            (isNotEmptyOrNull(item.street) ? ', ' : '') +
            '${item.houseNumber}'
        : '';
    isNotEmptyOrNull(item.name)
        ? name = name +
            (isNotEmptyOrNull(item.houseNumber) ? ', ' : ', ') +
            '${item.name}'
        : '';
    isNotEmptyOrNull(item.city)
        ? name =
            name + (isNotEmptyOrNull(item.name) ? ', ' : ', ') + '${item.city}'
        : '';
    if (name.endsWith(', ')) {
      name = name.replaceRange(name.length - 2, name.length, '');
    }
    if (name.startsWith(', ')) {
      name = name.replaceRange(0, 2, '');
    }
    return name;
  }

  getSuggestions() async {
    log("selectedCityCode::: $selectedCityCode");
    log("get suggestions");
    if (searchTerm.isNotEmpty) {
      List<SuggestionItem> _suggestion =
          await mainScreenRepostory.fetchOsmSuggestions(
              searchTerm: searchTerm,
              cityCode: selectedCityCode.isEmpty ? "umn" : selectedCityCode);

      suggestions = _suggestion;
      update();

      return suggestions;
    } else {
      List<SuggestionItem> _suggestionEmpty = [];
      update();
      return Future.value(_suggestionEmpty);
    }
  }

  updateHomeWorkSuggestion(String val) {
    // print('herehomeadd  ${cacheAddress["homeAddress"].toString()}  ||   $val');
    if (cacheAddress["homeAddress"].toString().isNotEmpty &&
        cacheAddress["homeAddress"]
            .toString()
            .toLowerCase()
            .startsWith(val.toLowerCase()) &&
        val.isNotEmpty) {
      // print('herehomeadd1');
      isHomeSuggestion = true;
    } else {
      // print('herehomeadd2');
      isHomeSuggestion = false;
    }

    // print('hereworkadd  ${cacheAddress["workAddress"].toString()}  ||   $val');
    if (cacheAddress["workAddress"].toString().isNotEmpty &&
        cacheAddress["workAddress"]
            .toString()
            .toLowerCase()
            .startsWith(val.toLowerCase()) &&
        val.isNotEmpty) {
      // print('hereworkadd1');
      isWorkSuggestion = true;
    } else {
      // print('hereworkadd2');
      isWorkSuggestion = false;
    }

    update();
  }

  // updateControllerCache() {
  //   cache['whereToDeliverControllerText'] = wheretoDeliverGoController.text;
  //   cache['whereToAddressControllerText'] =
  //       whereToAddressEditingController.text;
  // }

  onSuggestionTap(dynamic item, bool isOtherAddressScreen) {
    update();

    log(lastFocus.toString());
    if (isWhereToDeliveredFieldTapped == true) {
      isWhereToDeliveredSelectedFromPromt = true;
      log("Where to delivered ${isWhereToDeliveredSelectedFromPromt.toString()}");
      update();
    } else if (isWhereBuildingAddressTapped) {
      isWhereToBuildingAddressSelectedFromPromt = true;
      log("where to building field tapped ${isWhereToBuildingAddressSelectedFromPromt.toString()}");
      update();
    }
    update();
    // print(isOtherAddressScreen);

    // print("LAST FOCUS: ${lastFocus}");
    if (wheretoDeliverFocusNode.hasFocus || lastFocus == "whereToDeliver") {
      String displayName = filterSuggesstionName(item);
      // String displayName =
      //     item.name + ", " + "${item.street}" + ", " + "${item.houseNumber}";
      // print('hereitemcity  $displayName');
      wheretoDeliverGoController.text = displayName;
      tappedDeliveredAddress = displayName;

      deliveredAddress = MyAddress(
        name: displayName,
        // address: displayName,
        street: item.street,
        houseNo: item.houseNumber,
        lat: item.lat,
        lon: item.lon,
        city: currentCity!.name,
        cityCode: currentCity!.code,
        isSaveAddress: true,
      );
      // cache['whereToDeliverControllerText'] = displayName;
      //save address into local Db for recently search list
      lastSelectedAddress = displayName;
      debugPrint("lastSelectedAddress::: $lastSelectedAddress");
      saveToDBRecentlySearchList(item);
      wheretoDeliverFocusNode.unfocus();
    }

    if (whereToAddressFocusNode.hasFocus ||
        lastFocus == "whereToBuildingAddress") {
      String displayName = filterSuggesstionName(item);
      // String displayName =
      //     item.name + ", " + "${item.street}" + ", " + "${item.houseNumber}";
      // print('building address   $displayName');
      whereToAddressEditingController.text = displayName;
      tappedBuildingAddress = displayName;

      buildingAddress = MyAddress(
        name: displayName,
        // address: displayName,
        street: item.street,
        houseNo: item.houseNumber,
        lat: item.lat,
        lon: item.lon,
        city: currentCity!.name,
        cityCode: currentCity!.code,
      );
      // cache['whereToAddressControllerText'] = displayName;
      whereToAddressFocusNode.unfocus();
    }
  }

  saveToDBRecentlySearchList(dynamic recentlySearch) {
    recentlyList.add(recentlySearch);
    String recentlyData = json.encode(recentlyList);
    databaseService.saveToDisk(
        DatabaseKeys.recentlySearchAddress, recentlyData);
    update();
  }

  getListOfRecentlySearchList() {
    debugPrint(
        "${databaseService.getFromDisk(DatabaseKeys.recentlySearchAddress).toString()}");
    if (databaseService
                .getFromDisk(DatabaseKeys.recentlySearchAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.recentlySearchAddress)
            .toString()
            .isNotEmpty) {
      var rsList = jsonDecode(databaseService
          .getFromDisk(DatabaseKeys.recentlySearchAddress)
          .toString());

      debugPrint("Recently List:: ${rsList.toString()}");
      recentlyList = List<dynamic>.from(rsList);
      List<SuggestionItem> _suggestionItems = [];
      List _decoded = recentlyList;
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
      recentlyAddedList = _suggestionItems;
      update();
    }
  }

  saveButtonStatusChange(bool isChanged) {
    if (isChanged) {
      if (wheretoDeliverGoController.text.toString().isNotEmpty &&
          wheretoDeliverGoController.text.toString().length >= 3) {
        isSaveButtonEnable = true;
      } else {
        isSaveButtonEnable = false;
      }
    }
  }

  finalSaveAddressOfDelivery(BuildContext context) async {
    debugPrint(
        "--------------------finalSaveAddressOfDelivery---------------------");
    whereToAddressFocusNode.unfocus();
    wheretoDeliverFocusNode.unfocus();

    if (deliveredAddress.lat != null &&
        deliveredAddress.lon != null &&
        deliveredAddress.lat != "" &&
        deliveredAddress.lon != "") {
      debugPrint("Save Address:: " + jsonEncode(deliveredAddress).toString());
      databaseService.saveToDisk(DatabaseKeys.saveDeliverAddress,
          jsonEncode(deliveredAddress).toString());
    }

    // if (deliveredAddress.lat != null &&
    //     deliveredAddress.lon != null &&
    //     deliveredAddress.name != null) {
    //
    //   debugPrint("Save Address:: " + jsonEncode(deliveredAddress).toString());
    //
    //   databaseService.saveToDisk(DatabaseKeys.saveDeliverAddress, jsonEncode(deliveredAddress).toString());
    //
    //   debugPrint("--------------------Location Save---------------------");
    // } else {
    //
    //   // deliveredAddress = MyAddress(
    //   //   name: wheretoDeliverGoController.text.toString(),
    //   //   // address: displayName,
    //   //   street: whereToAddressEditingController.text.toString().isNotEmpty
    //   //       ? whereToAddressEditingController.text.toString()
    //   //       : "",
    //   //   houseNo: "",
    //   //   lat: databaseService.getFromDisk(DatabaseKeys.saveCurrentLat),
    //   //   lon: databaseService.getFromDisk(DatabaseKeys.saveCurrentLang),
    //   //   city: currentCity!.name,
    //   //   cityCode: currentCity!.code,
    //   //   isSaveAddress: true,
    //   // );
    //   // databaseService.saveToDisk(DatabaseKeys.saveDeliverAddress, jsonEncode(deliveredAddress).toString());
    //   // debugPrint("--------------------Current Save---------------------");
    // }

    databaseService.saveToDisk(DatabaseKeys.userDeliverAddress,
        wheretoDeliverGoController.text.toString());
    databaseService.saveToDisk(DatabaseKeys.userDeliverBuildingAddress,
        whereToAddressEditingController.text.toString());

    Helpers.showCircularProgressDialog(context: context);
    await Future.delayed(Duration(milliseconds: 1500), () {
      debugPrint("-------------------- Future.delayed ---------------------");
    });
    debugPrint("--------------------Future.delayed End---------------------");
    Navigator.of(context).pop();
    Get.back();
  }

  onFoodMyLocationTap(context) async {
    debugPrint("--------------------onFoodMyLocationTap---------------------");
    if (wheretoDeliverFocusNode.hasFocus || lastFocus == "whereToDeliver") {
      debugPrint("if condition");
      if (locationData != null) {
        var res = "";
        debugPrint("if condition1");
        if ((databaseService.getFromDisk(DatabaseKeys.saveCurrentLat) !=
                    locationData!.latitude! &&
                databaseService.getFromDisk(DatabaseKeys.saveCurrentLang) !=
                    locationData!.longitude!) ||
            currentAddress.isEmpty) {
          res = databaseService.getFromDisk(DatabaseKeys.saveCurrentAddress);
          // res = await decodeLocationString(
          //     LatLng(locationData!.latitude!, locationData!.longitude!), true);
          currentAddress = res;
          // print('Food Current Location 1 $res');
        } else {
          res = currentAddress;
          // print('Food Current Location 2 $res');
        }
        print('Food Current Location 3 $res');
        if (res.runtimeType == String) {
          wheretoDeliverGoController.text = res;
          // print('Food Current Location 4 $res');
          deliveredAddress = MyAddress(
            name: res,
            houseNo: "",
            lat: locationData!.latitude,
            lon: locationData!.longitude,
            city: currentCity!.name,
            cityCode: currentCity!.code,
            isSaveAddress: true,
          );
          // updateControllerCache();
          saveButtonStatusChange(true);
          update();
          wheretoDeliverFocusNode.unfocus();
        }
      }
    }

    // if (lastFocus == "whereToBuildingAddress") {
    //   FocusScope.of(context).requestFocus(wheretoDeliverFocusNode);
    //   lastFocus = "whereToDeliver";
    // } else if (lastFocus == "whereToDeliver") {
    //   FocusScope.of(context).requestFocus(whereToAddressFocusNode);
    //
    //   lastFocus = "whereToBuildingAddress";
    // }
  }

  /// [Reverse Geocoding]
  decodeLocationString(LatLng latLong, bool isSetData) async {
    debugPrint(
        "------------------------------DecodeLocationString--------------------------");
    //reverse?lat=49.23722&lon=28.46722
    var request = await await mainScreenRepostory.reverseGeoCoding(
        latitude: latLong.latitude,
        longitude: latLong.longitude,
        cityCode: selectedCityCode);

    try {
      print(isNotEmptyOrNull(request.name)
          ? request.name
          : '' +
              (isNotEmptyOrNull(request.name) ? ', ' : '') +
              (isNotEmptyOrNull(request.city) ? request.city : ''));
      debugPrint("decodeLocationString Line No => 569");
      if (request.runtimeType == DecodedAddress) {
        debugPrint("decodeLocationString Line No => 571");
        log(lastFocus.toString());
        if (lastFocus == "") {
          if (isSetData) {
            wheretoDeliverGoController.text = filterDecodedAddress(request);
          }
          deliveredAddress = MyAddress(
            lat: latLong.latitude,
            lon: latLong.longitude,
            name: filterDecodedAddress(request),
            isSaveAddress: true,
          );
        } else {
          debugPrint("decodeLocationString Line No => 581");
          if (isSetData) {
            wheretoDeliverGoController.text = filterDecodedAddress(request);
          }
          deliveredAddress = MyAddress(
            lat: latLong.latitude,
            lon: latLong.longitude,
            name: filterDecodedAddress(request),
            isSaveAddress: true,
          );
        }
        debugPrint("decodeLocationString Line No => 589");
        // updateControllerCache();

        return filterDecodedAddress(request);
      }
    } catch (e) {
      debugPrint("decodeLocationString Line No => 594");
      return null;
    }
  }

  /// Formatting address [based on client requirements]
  filterDecodedAddress(DecodedAddress item) {
    //print('heredecode:1 ${item.toJson()}');
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
    //print('heredecode $name');
    return name;
  }

  //food delivery address return
  getDeliveryAddress() {
    HomeViewController controller =
        Get.put(HomeViewController(), permanent: true);

    var streetAddress = "";

    if (databaseService
                .getFromDisk(DatabaseKeys.saveDeliverAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress)
            .toString()
            .isNotEmpty) {
      //get save address
      var data = databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
      var deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));
      streetAddress = deliverAddress.name.toString();
      lastSelectedAddress = streetAddress;
    } else {
      //check gps location
      if (controller.isLocationEnable()) {
        //location enable
        debugPrint("disabled Location");
        streetAddress = "";
      } else {
        debugPrint("Enabled Location");
        streetAddress = controller.getCurrentLocationAddress();
        lastSelectedAddress = streetAddress;
      }
    }
    wheretoDeliverGoController.text = streetAddress;
    wheretoDeliverFocusNode.requestFocus();
    var streetBuildingAddress = "";
    if (databaseService
                .getFromDisk(DatabaseKeys.userDeliverBuildingAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.userDeliverBuildingAddress)
            .toString()
            .isNotEmpty) {
      streetBuildingAddress = databaseService
          .getFromDisk(DatabaseKeys.userDeliverBuildingAddress)
          .toString();

      whereToAddressEditingController.text = streetBuildingAddress;
    } else {
      whereToAddressEditingController.text = "";
    }

    saveButtonStatusChange(true);
    update();
  }

  /// [Clearing text editing controller where to arive and where to go]

// updateControllerCache() {
//   cache['whereToGoControllerText'] = wheretoGoController.text;
//   cache['whereToArriveControllerText'] = whereToAriveEdtingController.text;
// }

}
