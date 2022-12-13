import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fl_location/fl_location.dart' as fl;
import 'package:sizer/sizer.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/cars_model/cars_model.dart';
import 'package:sprut/data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import 'package:sprut/data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
import 'package:sprut/presentation/pages/news/controllers/news_controller.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/LocationUtil.dart';
import '../../../../data/models/oder_delivery/oder_delivery_response.dart';
import '../../../../data/models/tariff_screen_model/order_model.dart';
import '../../../../data/repositories/order_repository/order_repository.dart';
import '../../../../data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import '../../../../resources/app_constants/app_constants.dart';

class HomeViewController extends GetxController {
  var tappedAriveAddress = "";
  var tappedDestinationAddress = "";

  bool isWhereToAriveSelectedFromPromt = false;
  bool isWhereToGoSelectedFromPromt = false;

  bool isMapLoading = true;
  bool isWhereToAriveChanged = false;
  bool isWhereToGoChanged = false;
  RxBool isdrawerOpened = false.obs;
  PanelController scrollController = PanelController();
  RxBool isMapChanged = false.obs;
  bool isBottomSheetTapped = false;
  RxString userPhone = "".obs;
  bool isWhereToAriveFieldTapped = false;
  bool isWhereToGoFieldTapped = false;
  String selectedCityCode = "";
  bool closeButtonVisible = false;
  int whereToArriveTapCount = 0;
  MyAddress arrivalAddress = MyAddress();
  MyAddress destinationAddress = MyAddress();
  CameraPosition? kGooglePlex;
  CameraPosition? kLake;

  String lastFocus = "";
  String searchTerm = "";
  List<SuggestionItem> suggestions = [];
  List<SuggestionItem> lastThreeAddresses = [];

  int whereToGoTapCount = 0;
  List<AvailableCitiesModel?>? allCities;
  AvailableCitiesModel? currentCity;
  CameraPosition? currentCamPosition;

  TariffScreenRepository tariffScreenRepository = TariffScreenRepository();
  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();
  OrderRepository orderRepository = OrderRepository();
  bool showSuggestions = false;
  bool isBottomSheetExpanded = false;
  Map<String, dynamic> cache = {
    "whereToGoControllerText": "",
    "whereToArriveControllerText": ""
  };

  bool isStartLoading = false;

  Map<String, dynamic> cacheAddress = {
    "homeAddress": "",
    "workAddress": "",
  };

  String currentAddress = "";

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  /// Text Editing Controllers in home view

  TextEditingController whereToAriveEdtingController =
      new TextEditingController();
  TextEditingController wheretoGoController = new TextEditingController();
  FocusNode whereToAriveFocusNode = FocusNode();
  FocusNode wheretoGoFocusNode = FocusNode();

  /// [Google Maps Fields]

  Completer<GoogleMapController> gMapCompleter = Completer();
  GoogleMapController? googleMapController;
  CameraPosition? initialCameraPosition;

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  Set<Marker> markersSet = {};
  MarkerId? centerMarkerID;

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

  AvailableCitiesModel? selectedCity;

  /// When Maps is created  below method is called
  onMapsCreated(GoogleMapController controller) async {
    googleMapController = controller;

    //   locationData = await location.getLocation();
    // if (locationData != null) {
    //       googleMapController!.moveCamera(
    //         CameraUpdate.newCameraPosition(
    //           CameraPosition(
    //             target: LatLng(locationData!.latitude!, locationData!.longitude!),
    //             zoom: 17.0,
    //           ),
    //         ),
    //       );
    //     }

    userPhone.value =
        databaseService.getFromDisk(DatabaseKeys.userPhoneNumber) ?? "";
    update();

    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      selectedCity = AvailableCitiesModel.fromJson(
          jsonDecode(databaseService.getFromDisk(DatabaseKeys.selectedCity)));
      if (selectedCity != null) {
        selectCityName.value = selectedCity!.name;
        currentCity = selectedCity;
        selectedCityCode = selectedCity!.code;
      }
    }

    kGooglePlex = CameraPosition(
      target: LatLng(selectedCity!.lat, selectedCity!.lon),
      zoom: 3.4746,
    );

    kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(selectedCity!.lat, selectedCity!.lon),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );

    var defaultLatitude =
        databaseService.getFromDisk(DatabaseKeys.defaultLatitude);
    var defaultLongitude =
        databaseService.getFromDisk(DatabaseKeys.defaultLongitude);

    LatLng? defaultLatLong;
    if (defaultLatitude != null) {
      defaultLatLong = LatLng(defaultLatitude, defaultLongitude);
    }

    selectedCityCode =
        databaseService.getFromDisk(DatabaseKeys.selectedCityCode) ?? "vin";

    initialCameraPosition = defaultLatLong == null
        ? CameraPosition(target: LatLng(selectedCity!.lat, selectedCity!.lon))
        : CameraPosition(
            target: LatLng(defaultLatLong.latitude, defaultLatLong.longitude));

    kGooglePlex = defaultLatLong == null
        ? CameraPosition(target: LatLng(selectedCity!.lat, selectedCity!.lon))
        : CameraPosition(
            target: LatLng(defaultLatLong.latitude, defaultLatLong.longitude));

    update();

    markersSet = Set<Marker>.of(mapMarkers.values);

    if (!gMapCompleter.isCompleted) {
      gMapCompleter.complete(controller);
    }

    if (selectedCity != null) {
      LatLng position = locationData != null
          ? LatLng(
              locationData!.latitude!,
              locationData!.longitude!,
            )
          : LatLng(selectedCity!.lat, selectedCity!.lon);

      if (locationData != null) {
        MarkerId markerId = MarkerId("currentlocation");
        centerMarkerID = markerId;
        LatLng position =
            LatLng(locationData!.latitude!, locationData!.latitude!);

        Marker marker = Marker(
          markerId: markerId,
          position: position,
          icon: await Helpers.bitmapDescriptorFromSvgAsset(
              Get.context!, AssetsPath.locationMarkerSvg),
          draggable: false,
        );

        mapMarkers[markerId] = marker;
      }

      update();

      Future.delayed(Duration(milliseconds: 2), () async {
        // googleMapController = await gMapCompleter.future;
        googleMapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );

        update();
      });
    }
  }

  List<Car> cars = [];

  getCars() async {
    // var req = await mainScreenRepostory.fetchCars(cityCode: selectedCityCode);
    // if (req.runtimeType == cars.runtimeType) {
    //   cars = req;

    //   BitmapDescriptor markerIcon = await Helpers.getBitmapDescriptorForSVG(
    //       Get.context!, AssetsPath.carSvg,
    //       size: Size(30, 30));

    //   for (Car car in cars) {
    //     MarkerId markerId = MarkerId(car.carId!);
    //     LatLng position = LatLng(car.lat!, car.lon!);
    //     Marker _marker = Marker(
    //       consumeTapEvents: false,
    //       infoWindow: InfoWindow(
    //         title: "${car.makeRaw}, ${car.modelRaw}",
    //         snippet: "${car.colorRaw}",
    //       ),
    //       markerId: markerId,
    //       position: position,
    //       icon: markerIcon,
    //       draggable: false,
    //       rotation: car.heading != null ? car.heading!.toDouble() : 0.0,
    //     );
    //     mapMarkers[markerId] = _marker;
    //   }
    //   update();
    // } else {}
  }

  updateToken(String token) async {
    try {
      await mainScreenRepostory.updateToken(token);
    } catch (e) {}
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
                if (locationData == null) {
                  // Helpers.showCircularProgressDialog(context: context);
                  await fetchUserLocation();
                  // Navigator.pop(context);

                  // gMapController.animateCamera(cameraUpdate)
                  await updateCurrentLocationMarker();
                  animateToCurrent();
                } else {
                  await updateCurrentLocationMarker();
                  // ProgressLoader().dismiss();
                  animateToCurrent();
                }
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
                  width: 2.5.h,
                ),
              ),
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
              width: MediaQuery.of(context).size.width * 0.82,
              padding: EdgeInsets.all(12),
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
                await fetchUserLocation();
              },
              child: Container(
                  width: 14.w,
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

  fetchUserLocation() async {
    /// Restoring default address of home and work
    ChooseOnMapController chooseOnMapController =
        Get.put(ChooseOnMapController());

    String _homeAddress =
        databaseService.getFromDisk(DatabaseKeys.userHomeAddress) ?? "";

    chooseOnMapController.addHomeAddressEditingController.text = _homeAddress;
    cacheAddress["homeAddress"] = _homeAddress;

    String _workAddress =
        databaseService.getFromDisk(DatabaseKeys.userWorkAddress) ?? "";

    chooseOnMapController.addWorkAddressEditingController.text = _workAddress;
    cacheAddress["workAddress"] = _workAddress;

    update();

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      locationServiceStatus = serviceEnabled
          ? fl.LocationServicesStatus.enabled
          : fl.LocationServicesStatus.disabled;
      if (!serviceEnabled) {permissionGranted = await location.hasPermission();
        update();
        return;
      }
    }

    locationServiceStatus = serviceEnabled ? fl.LocationServicesStatus.enabled : fl.LocationServicesStatus.disabled;
    locationServiceStatus = serviceEnabled ? fl.LocationServicesStatus.enabled : fl.LocationServicesStatus.disabled;

    // }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    if ((permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) &&
        locationServiceStatus == fl.LocationServicesStatus.enabled) {
      // Helpers.showCircularProgressDialog(context: Get.context!);
      locationData = await location.getLocation();
      print('herecurrentloc  $locationData');

      // Navigator.pop(Get.context!);
      if (locationData != null) {
        databaseService.saveToDisk(DatabaseKeys.defaultLatitude, locationData!.latitude!);
        databaseService.saveToDisk(DatabaseKeys.defaultLongitude, locationData!.longitude!);

        final DecodedAddress address = await mainScreenRepostory.reverseGeoCoding(latitude: locationData!.latitude!, longitude: locationData!.longitude!, cityCode: selectedCityCode);

        String getDecAddress = filterDecodedAddress(address) ?? "";

        if (getDecAddress != "") {
          Future.delayed(Duration(seconds: 1), () async {
            googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(locationData!.latitude!, locationData!.longitude!), zoom: 17.0,),),);

            whereToAriveEdtingController.text = getDecAddress;
            currentAddress = getDecAddress;
            cache['whereToArriveControllerText'] = getDecAddress;

            update();
          });
        }

        update();
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) async {
      locationData = currentLocation;
      // updateCurrentLocationString(
      //     LatLng(currentLocation.latitude!, currentLocation.longitude!));
      // // currentLocationString = await decodeLocationString(
      //   LatLng(currentLocation.latitude, currentLocation.longitude),
      // );
      updateCurrentLocationMarker();
      // Use current location
    });
    if (locationData != null) {
      currentLocationString = await decodeLocationString(
        LatLng(locationData!.latitude!, locationData!.longitude!),
      );
    }
    update();
    await updateCurrentLocationMarker();
    getCars();

    // Need change the code
    Future.delayed(Duration(seconds: 2), () {
      if (Helpers.isLoginTypeIn() == AppConstants.TAXI_APP) {
        updateStatus();
      }
    });
  }

  updateWhereToArrive() {
    whereToAriveEdtingController.text = cache['whereToArriveControllerText'];
    update();
  }

  /// [Reverse Geocoding]
  decodeLocationString(LatLng latLong, {fromCenterMarker = false}) async {
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
      if (request.runtimeType == DecodedAddress) {
        log(lastFocus.toString());
        if (lastFocus == "") {
          if (isBottomSheetExpanded) {
            whereToAriveEdtingController.text = filterDecodedAddress(request);
            arrivalAddress = MyAddress(
              lat: latLong.latitude,
              lon: latLong.longitude,
              name: filterDecodedAddress(request),
            );
          }
          if (fromCenterMarker) {
            whereToAriveEdtingController.text = filterDecodedAddress(request);
            arrivalAddress = MyAddress(
              lat: latLong.latitude,
              lon: latLong.longitude,
              name: filterDecodedAddress(request),
            );
          }
        }
        // else if (lastFocus == "whereToGo") {
        //   wheretoGoController.text = filterDecodedAddress(request);
        //   arrivalAddress = MyAddress(
        //     lat: latLong.latitude,
        //     lon: latLong.longitude,
        //     name: filterDecodedAddress(request),
        //   );
        // }
        else {
          whereToAriveEdtingController.text = filterDecodedAddress(request);
          arrivalAddress = MyAddress(
            lat: latLong.latitude,
            lon: latLong.longitude,
            name: filterDecodedAddress(request),
          );
        }

        updateControllerCache();

        return filterDecodedAddress(request);
      }
    } catch (e) {
      return null;
    }
  }

  /// [Clearing text editing controller where to arive and where to go]

  updateControllerCache() {
    print('herecache  ${whereToAriveEdtingController.text}');
    cache['whereToGoControllerText'] = wheretoGoController.text;
    cache['whereToArriveControllerText'] = whereToAriveEdtingController.text;
  }

  updateCurrentLocationString(LatLng latLong) async {
    var request = await mainScreenRepostory.reverseGeoCoding(
        latitude: latLong.latitude,
        longitude: latLong.longitude,
        cityCode: selectedCityCode);
    print('hereaddress ${request.runtimeType}');
    if (request.runtimeType == DecodedAddress) {
      currentLocationString = filterDecodedAddress(request);
      update();
    }
  }

  updateCurrentAddressOnBottomSheetClose() async {
    final AvailableCitiesModel selectedCity;

    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
          databaseService.getFromDisk(DatabaseKeys.selectedCity) ?? ''));
      selectCityName.value = selectedCity.name;
      selectedCityCode = selectedCity.code;

      DecodedAddress address;
      String getAdd = "";
      if (locationData != null) {
        address = await mainScreenRepostory.reverseGeoCoding(
            latitude: locationData!.latitude!,
            longitude: locationData!.longitude!,
            cityCode: selectedCityCode);

        getAdd = filterDecodedAddress(address) ?? "";

        if (getAdd != "") {
          arrivalAddress = MyAddress(
            lat: locationData!.latitude!,
            lon: locationData!.longitude!,
            name: getAdd,
          );
        }
      }

      if (getAdd == "") {
        address = await mainScreenRepostory.reverseGeoCoding(
            latitude: selectedCity.lat,
            longitude: selectedCity.lon,
            cityCode: selectedCityCode);

        getAdd = filterDecodedAddress(address) ?? "";

        arrivalAddress = MyAddress(
          lat: selectedCity.lat,
          lon: selectedCity.lon,
          name: getAdd,
        );
      }

      whereToAriveEdtingController.text = getAdd;

      updateControllerCache();
    }
  }

  updateCurrentLocationMarker() async {
    if (locationData != null) {
      MarkerId markerId = MarkerId("currentlocation");
      centerMarkerID = markerId;
      LatLng position =
          LatLng(locationData!.latitude!, locationData!.longitude!);

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

  /// Formatting address [based on client requirements]
  filterDecodedAddress(DecodedAddress item) {
    //print('heredecode ${item.toJson()}');
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

  updateSearchTerm(val) {
    searchTerm = val;

    log(searchTerm);
    update();
  }

  var osmSuggestionsFuture;

  updateSuggestionsOnBack() async {
    print(lastFocus);
    whereToAriveFocusNode.requestFocus();

    lastFocus = "whereToArrive";

    var val = "";
    val = whereToAriveEdtingController.text;
    if (whereToAriveEdtingController.text.isEmpty) {
      suggestions = [];
      update();
      return;
    }

    updateSearchTerm(val);

    osmSuggestionsFuture = getSuggestions();
    log("suggestions");
    print(osmSuggestionsFuture);
    update();
  }

  bool isHomeSuggestion = false;
  bool isWorkSuggestion = false;

  updateSuggestions() async {
    print('heresuggestionfocus $lastFocus');
    var val = "";
    if (lastFocus == "whereToArrive") {
      val = whereToAriveEdtingController.text;
      if (whereToAriveEdtingController.text.isEmpty) {
        suggestions = [];
        update();
        return;
      }
    }
    if (lastFocus == "whereToGo") {
      val = wheretoGoController.text;

      if (wheretoGoController.text.isEmpty) {
        suggestions = [];
        update();
      }
    }
    updateSearchTerm(val);

    updateHomeWorkSuggestion(val);

    osmSuggestionsFuture = getSuggestions();
    log("suggestions");
    print(osmSuggestionsFuture);
    update();
  }

  updateHomeWorkSuggestion(String val) {
    print('herehomeadd  ${cacheAddress["homeAddress"].toString()}  ||   $val');
    if (cacheAddress["homeAddress"].toString().isNotEmpty &&
        cacheAddress["homeAddress"]
            .toString()
            .toLowerCase()
            .startsWith(val.toLowerCase()) &&
        val.isNotEmpty) {
      print('herehomeadd1');
      isHomeSuggestion = true;
    } else {
      print('herehomeadd2');
      isHomeSuggestion = false;
    }

    print('hereworkadd  ${cacheAddress["workAddress"].toString()}  ||   $val');
    if (cacheAddress["workAddress"].toString().isNotEmpty &&
        cacheAddress["workAddress"]
            .toString()
            .toLowerCase()
            .startsWith(val.toLowerCase()) &&
        val.isNotEmpty) {
      print('hereworkadd1');
      isWorkSuggestion = true;
    } else {
      print('hereworkadd2');
      isWorkSuggestion = false;
    }

    update();
  }

  getSuggestions() async {
    log(selectedCityCode);
    log("get suggestions");
    if (searchTerm.isNotEmpty) {
      List<SuggestionItem> _suggestion =
          await mainScreenRepostory.fetchOsmSuggestions(
              searchTerm: searchTerm, cityCode: selectedCityCode);

      suggestions = _suggestion;
      update();

      return suggestions;
    } else {
      List<SuggestionItem> _suggestionEmpty = [];
      update();
      return Future.value(_suggestionEmpty);
    }
  }

  collapseSheet() {
    // isBottomSheetExpanded = false;
    whereToAriveFocusNode.unfocus();
    wheretoGoFocusNode.unfocus();
    closeButtonVisible = false;

    whereToGoTapCount = 0;
    whereToArriveTapCount = 0;
    updateControllerCache();
    searchTerm = "";
    suggestions = [];
    update();
  }

  collapseWithoutUnfocus() {
    // isBottomSheetExpanded = false;
    closeButtonVisible = false;
    whereToGoTapCount = 0;
    whereToArriveTapCount = 0;
    updateControllerCache();

    update();
  }

  expandSheet(FocusNode fn) {
    // isBottomSheetExpanded = true;
    closeButtonVisible = true;
    showSuggestions = false;
    update();
    whereToArriveTapCount += 1;
    whereToGoTapCount += 1;
    updateSearchTerm("");
    suggestions = [];
    // fn..();
    update();
  }

  bool tariffSelectionStateMin = false;
  bool tariffSelectionStateExp = false;
  bool homeState = true;

  moveToTariff() async {
    if (whereToAriveEdtingController.text.isEmpty ||
        wheretoGoController.text.isEmpty) {
      return;
    }

    if (arrivalAddress.lat == null || destinationAddress.lat == null) {
      return;
    }

    if (whereToAriveEdtingController.text.isNotEmpty ||
        wheretoGoController.text.isNotEmpty) {
      await Get.toNamed(Routes.tarrifSelectionView, arguments: {
        "currentCity": currentCity,
        "arrivalAddress": arrivalAddress,
        "destinationAddress": destinationAddress,
        "kGooglePlex": kGooglePlex,
        "kLake": kLake,
      });
    }
  }

  moveToTariffRepeat() async {
    if (whereToAriveEdtingController.text.isEmpty ||
        wheretoGoController.text.isEmpty) {
      return;
    }

    if (arrivalAddress.lat == null || destinationAddress.lat == null) {
      return;
    }

    if (whereToAriveEdtingController.text.isNotEmpty ||
        wheretoGoController.text.isNotEmpty) {
      await Get.toNamed(Routes.tarrifSelectionView, arguments: {
        "currentCity": currentCity,
        "arrivalAddress": arrivalAddress,
        "destinationAddress": destinationAddress,
        "kGooglePlex": kGooglePlex,
        "kLake": kLake,
        "repeatOrder": true,
      });
    }
  }

  arrivalArbtraryAddresssValidator(context) {
    arrivalAddress = MyAddress(
      lat: 0.0,
      lon: 0.0,
      name: whereToAriveEdtingController.text,
    );
    cache['whereToArriveControllerText'] = whereToAriveEdtingController.text;
    // if (destinationAddress != MyAddress()) {
    //   //Move To Tariff

    //   Navigator.pop(context);
    //   collapseSheet();
    //   moveToTariff();
    // } else {
    //   Navigator.pop(context);
    //   FocusScope.of(context).requestFocus(whereToGoFN);
    // }

    if (destinationAddress.lat == null) {
      Navigator.pop(context);
      // FocusScope.of(context).requestFocus(wheretoGoFocusNode);
      return;
    }
    if (destinationAddress.name == null) {
      Navigator.pop(context);
      // FocusScope.of(context).requestFocus(wheretoGoFocusNode);
      return;
    }
    Navigator.pop(context);

    if (whereToAriveEdtingController.text.isNotEmpty) {
      moveToTariff();
    }
    collapseSheet();
  }

  destinationArbitraryAddressValidator(context) {
    destinationAddress = MyAddress(
      lat: 0.0,
      lon: 0.0,
      name: wheretoGoController.text,
    );
    cache['whereToGoControllerText'] = wheretoGoController.text;
    // if (arrivalAddress != MyAddress()) {
    //   //Move To Tariff

    //   Navigator.pop(context);
    //   collapseSheet();
    //   moveToTariff();
    // } else {}

    if (arrivalAddress.lat == null) {
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(whereToAriveFocusNode);
      return;
    }
    if (arrivalAddress.name == null) {
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(whereToAriveFocusNode);
      return;
    }

    Navigator.pop(context);
    collapseSheet();
    if (wheretoGoController.text.isNotEmpty) {
      moveToTariff();
    }
  }

  showWhereToArriveSaveAlert(context) async {
    // var colorScheme = Theme.of(context).colorScheme;
    // var textTheme = Theme.of(context).textTheme;

    // Get.defaultDialog(
    //     barrierDismissible: false,
    //     radius: 8,
    //     title: "Should the car arrive at this address ?",
    //     titlePadding: EdgeInsets.only(top: 20, bottom: 10),
    //     titleStyle:
    //         textTheme.bodyText1!.copyWith(fontSize: 12.sp, color: Colors.black),
    //     content: AddressConfirmationDialog(
    //         textEditingController: whereToAriveEdtingController,
    //         focusNode: whereToAriveFocusNode));
  }

  showWhereToGoSaveAlert(context) async {
    // var colorScheme = Theme.of(context).colorScheme;
    // var textTheme = Theme.of(context).textTheme;

    // Get.defaultDialog(
    //     barrierDismissible: false,
    //     radius: 8,
    //     title: "Do you need to be delivered to this address?",
    //     titlePadding: EdgeInsets.only(top: 20, bottom: 10),
    //     titleStyle:
    //         textTheme.bodyText1!.copyWith(fontSize: 12.sp, color: Colors.black),
    //     content: AddressConfirmationDialog(
    //         textEditingController: wheretoGoController,
    //         focusNode: wheretoGoFocusNode));
  }

  filterSuggesstionName(SuggestionItem item) {
    print("ITEM : ${item.toJson()}");
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

  onSuggestionTap(dynamic item, bool isOtherAddressScreen) {
    update();
    log("suggestion called tap");
    log("isWhereToAriveFieldTapped  ${isWhereToAriveFieldTapped.toString()}");
    log("is where to  go field tapped ${isWhereToGoSelectedFromPromt.toString()}");
    log(lastFocus.toString());
    if (isWhereToAriveFieldTapped == true) {
      isWhereToAriveSelectedFromPromt = true;
      log("Where to arive ${isWhereToAriveSelectedFromPromt.toString()}");
      update();
    } else if (isWhereToGoFieldTapped) {
      isWhereToGoSelectedFromPromt = true;
      log("where to go field tapped ${isWhereToGoSelectedFromPromt.toString()}");
      update();
    }
    update();
    print(isOtherAddressScreen);
    log("log suggestions tap");
    ChooseOnMapController chooseOnMapController =
        Get.put(ChooseOnMapController());

    if (isOtherAddressScreen == true) {
      log("log other screen");
      // String displayName =
      //     item.name + ", " + "${item.street}" + ", " + "${item.houseNumber}";

      if (chooseOnMapController.isHomeAddressScreen == true) {
        SuggestionItem itemData = item;
        log(chooseOnMapController.addHomeAddressEditingController.text);
        log("log true home");
        String displayName = filterSuggesstionName(item);
        log("displayName");
        log(displayName);

        chooseOnMapController.addHomeAddressEditingController.text =
            displayName;

        cacheAddress["homeAddress"] = displayName;

        update();

        chooseOnMapController.homeAddressLocationData =
            LatLng(itemData.lat!, itemData.lon!);

        chooseOnMapController.update();
        log("saved to db");
        log(chooseOnMapController.homeAddressLocationData!.latitude.toString());
        log(chooseOnMapController.homeAddressLocationData!.longitude
            .toString());

        // arrivalAddress = MyAddress(
        //   name: displayName,
        //   // address: displayName,
        //   street: item.street,
        //   houseNo: item.houseNumber,

        //   lat: item.lat,
        //   lon: item.lon,
        //   city: currentCity!.name,
        //   cityCode: currentCity!.code,
        // );
      } else if (chooseOnMapController.isWorkAddressScreen == true) {
        SuggestionItem itemData = item;

        String displayName = filterSuggesstionName(item);

        chooseOnMapController.addWorkAddressEditingController.text =
            displayName;

        cacheAddress["workAddress"] = displayName;

        update();

        chooseOnMapController.workAddressLocationData =
            LatLng(itemData.lat!, itemData.lon!);

        chooseOnMapController.update();

        // arrivalAddress = MyAddress(
        //   name: displayName,
        //   // address: displayName,
        //   street: item.street,
        //   houseNo: item.houseNumber,

        //   lat: item.lat,
        //   lon: item.lon,
        //   city: currentCity!.name,
        //   cityCode: currentCity!.code,
        // );
      }

      return;
    }

    print("LAST FOCUS: ${lastFocus}");
    if (whereToAriveFocusNode.hasFocus || lastFocus == "whereToArrive") {
      String displayName = filterSuggesstionName(item);
      // String displayName =
      //     item.name + ", " + "${item.street}" + ", " + "${item.houseNumber}";
      print('hereitemcity  $displayName');
      whereToAriveEdtingController.text = displayName;
      tappedAriveAddress = displayName;

      arrivalAddress = MyAddress(
        name: displayName,
        // address: displayName,
        street: item.street,
        houseNo: item.houseNumber,

        lat: item.lat,
        lon: item.lon,
        city: currentCity!.name,
        cityCode: currentCity!.code,
      );
      cache['whereToArriveControllerText'] = displayName;
      print('heretariffar ${arrivalAddress.toJson()}');
      print('heretariffde ${destinationAddress.toJson()}');
      if (destinationAddress.name != null) {
        collapseSheet();

        ////MOVE TO TARIFF
        moveToTariff();
      } else {
        whereToAriveFocusNode.unfocus();
      }
    }
    if (wheretoGoFocusNode.hasFocus || lastFocus == "whereToGo") {
      log("matched where to go");

      String displayName = filterSuggesstionName(item);
      print('hereitemcity1  $displayName');
      wheretoGoController.text = displayName;
      tappedDestinationAddress = displayName;
      destinationAddress = MyAddress(
        name: displayName,
        lat: item.lat,
        lon: item.lon,
        city: currentCity!.name,
        street: item.street,
        houseNo: item.houseNumber,
        cityCode: currentCity!.code,
      );
      cache['whereToGoControllerText'] = displayName;
      print('heretariffar1 ${arrivalAddress.toJson()}');
      print('heretariffde1 ${destinationAddress.toJson()}');
      if (arrivalAddress.name != null) {
        collapseSheet();
        ////MOVE TO  TARIFF
        moveToTariff();
      } else {
        wheretoGoFocusNode.unfocus();
      }
    }
  }

  onMyLocationTap(context) async {
    print(
        'herecurrentlocation ${whereToAriveFocusNode.hasFocus} || $lastFocus || ${wheretoGoFocusNode.hasFocus} || $locationData');
    if (whereToAriveFocusNode.hasFocus || lastFocus == "whereToArrive") {
      if (locationData != null) {
        var res = "";

        if ((databaseService.getFromDisk(DatabaseKeys.defaultLatitude) !=
                    locationData!.latitude! &&
                databaseService.getFromDisk(DatabaseKeys.defaultLongitude) !=
                    locationData!.longitude!) ||
            currentAddress.isEmpty) {
          res = await decodeLocationString(
              LatLng(locationData!.latitude!, locationData!.longitude!));
          currentAddress = res;
          print('herecurrentlocation1 $res');
        } else {
          res = currentAddress;
          print('herecurrentlocation11 $res');
        }
        print('herecurrentlocation111 $res');
        if (res.runtimeType == String) {
          whereToAriveEdtingController.text = res;
          arrivalAddress = MyAddress(
            name: res,
            lat: locationData!.latitude,
            lon: locationData!.longitude,
            city: currentCity!.name,
            cityCode: currentCity!.code,
          );
          updateControllerCache();
          update();

          if (destinationAddress.name != null) {
            collapseSheet();
            moveToTariff();
          } else {
            print('herecurrentlocation4');
            whereToAriveFocusNode.unfocus();
          }
        }
      }
    }

    print(
        'herecurrentlocation2 ${whereToAriveFocusNode.hasFocus} || $lastFocus || ${wheretoGoFocusNode.hasFocus} || $locationData');

    if (wheretoGoFocusNode.hasFocus || lastFocus == "whereToGo") {
      print('herecurrentlocation3 $currentLocationString');
      wheretoGoController.text = currentLocationString ?? "";
      destinationAddress = MyAddress(
        name: currentLocationString ?? "",
        lat: locationData != null ? locationData!.latitude : 0,
        lon: locationData != null ? locationData!.longitude : 0,
        city: currentCity != null ? currentCity!.name : "",
        cityCode: currentCity != null ? currentCity!.code : "",
      );
      updateControllerCache();

      update();

      if (arrivalAddress.name != null) {
        collapseSheet();
        moveToTariff();

        ////MOVE TO TARIFF
      } else {
        whereToAriveFocusNode.unfocus();
      }
    }

    if (lastFocus == "whereToGo") {
      FocusScope.of(context).requestFocus(whereToAriveFocusNode);
      lastFocus = "whereToArrive";
    } else if (lastFocus == "whereToArrive") {
      FocusScope.of(context).requestFocus(wheretoGoFocusNode);

      lastFocus = "whereToGo";
    }
  }

  getAddressSuggestion(String searchTerm) async {
    List<MyAddress> addresses = [];
    var fetchedAddress = await mainScreenRepostory.fetchTripAddresses();
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

      return item;
    } else {
      return null;
    }
  }

  Container divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: !isBottomSheetExpanded ? 0 : 35),
      width: MediaQuery.of(context).size.width,
      height: 0.5,
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
    );
  }

  @override
  onClose() async {
    googleMapController!.dispose();

    super.onClose();
  }

  var args;

  updateCars() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      getCars();
    });
  }

  RxInt _newsCount = 0.obs;
  int get newsCount => _newsCount.value;
  set newsCount(value) => _newsCount.value = value;

  Future<void> fetchNewsCount() async {
    try {
      NewsController newsController = Get.put(NewsController());

      newsCount = await newsController.getNewsCount();
    } catch (e) {}
  }

  @override
  onInit() async {
    log("init called");
    super.onInit();
    fetchUserLocation();

    Future.delayed(Duration(seconds: 7), () {
      isMapLoading = false;
      update();
    });

    final AvailableCitiesModel selectedCity;

    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
          databaseService.getFromDisk(DatabaseKeys.selectedCity) ?? ''));
      selectCityName.value = selectedCity.name;
      selectedCityCode = selectedCity.code;
      initialCameraPosition = CameraPosition(
        target: LatLng(selectedCity.lat, selectedCity.lon),
        zoom: 3.4746,
      );

      initialCameraPosition =
          CameraPosition(target: LatLng(selectedCity.lat, selectedCity.lon));

      final DecodedAddress address = await mainScreenRepostory.reverseGeoCoding(
          latitude: selectedCity.lat,
          longitude: selectedCity.lon,
          cityCode: selectedCityCode);

      // whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

      arrivalAddress = MyAddress(
        lat: selectedCity.lat,
        lon: selectedCity.lon,
        name: filterDecodedAddress(address),
      );

      whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

      updateControllerCache();

      update();
    }



    isStartLoading = false;
    update();

    bool _status = await fl.FlLocation.isLocationServicesEnabled;
    if (_status) {
      locationServiceStatus = fl.LocationServicesStatus.enabled;
    } else {
      locationServiceStatus = fl.LocationServicesStatus.disabled;
    }

    fl.FlLocation.getLocationServicesStatusStream().listen((event) async {
      locationServiceStatus = event;
      update();
      log("event");
      print(locationServiceStatus);
    });

    fetchNewsCount();

//        if (Get.arguments.runtimeType == <String, AvailableCitiesModel>{}.runtimeType ||
//         Get.arguments.runtimeType == <String, dynamic>{}.runtimeType ||
//         Get.arguments.runtimeType == <String, Object>{}.runtimeType) {
//       args = <String, dynamic>{}.obs;
//       args(Get.arguments);
//   currentCity =  args()['currentCity'];
//       if (args()['arrivalAddress'] != null &&
//           args()['destinationAddress'] != null) {
//         arrivalAddress = args()['arrivalAddress'];
//         destinationAddress = args()['destinationAddress'];
//        whereToAriveEdtingController.text = args()['arrivalAddress'].name;
//         wheretoGoController.text= args()['destinationAddress'].name;
//         updateControllerCache();
//       }
//     } else if (Get.arguments.runtimeType == LastRouteInfo().runtimeType) {
//       args = LastRouteInfo().obs;
//       args(Get.arguments);

//       LastRouteInfo _routeInfo = args();
//   currentCity  = _routeInfo.city;
//       arrivalAddress = _routeInfo.arrivalAddress!;
//       destinationAddress = _routeInfo.destinationAddress!;
//      whereToAriveEdtingController.text = _routeInfo.arrivalAddress!.name!;
//       wheretoGoController.text = _routeInfo.destinationAddress!.name!;
//       updateControllerCache();
//     }
//     markersSet = Set<Marker>.of(mapMarkers.values);

// kGooglePlex = CameraPosition(
//       target: LatLng(currentCity!.lat, currentCity!.lon),
//       zoom: 3.4746,
//     );
//     kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(currentCity!.lat, currentCity!.lon),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414,
//     );
  }

  Future<void> updateStatus() async{
    print("updateStatus() : For Car Order");
    String order = "";
    try {
      order = databaseService.getFromDisk(DatabaseKeys.order);
    } catch (e) {
      print("updateStatus() : Execution");
    }

    if (order != "") {
      OrderModel orderModel = OrderModel.fromJson(jsonDecode(order));
      updateOrderStatus(orderModel);
    } else {
      databaseService.saveToDisk(DatabaseKeys.order, "");
      databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
      databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

      databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
      databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

      databaseService.saveToDisk(DatabaseKeys.preorder, "");

      // await updateCurrentLocationMarker();
    }
  }

  updateOrderStatus(OrderModel orderModel) async {
    // OrderModel orderModel = await tariffScreenRepository.updateOrder(
    //     cityCode: Get.find<HomeViewController>().selectedCityCode,
    //     orderId: orderModelVal.orderId!);
    print("herepreorder  ${databaseService.getFromDisk(DatabaseKeys.preorder)}");
    if (orderModel.status == "cancelled" ||orderModel.status == "completed" ||orderModel.status == null ||orderModel.status == "" ||databaseService.getFromDisk(DatabaseKeys.preorder) != "") {
      databaseService.saveToDisk(DatabaseKeys.order, "");
      databaseService.saveToDisk(DatabaseKeys.arrivalAddress, "");
      databaseService.saveToDisk(DatabaseKeys.destinationAddress, "");

      databaseService.saveToDisk(DatabaseKeys.orderArriveTime, "");
      databaseService.saveToDisk(DatabaseKeys.orderRideTime, "");

      databaseService.saveToDisk(DatabaseKeys.preorder, "");
    } else {
      databaseService.saveToDisk(DatabaseKeys.order, orderModel);

      await Get.toNamed(Routes.searchView);
    }
  }

  Future<void> repeatLastTrip(
      BuildContext context, OrderModel orderModel) async {
    Helpers.showCircularProgressDialog(context: context);
    final DecodedAddress address1 = await mainScreenRepostory.reverseGeoCoding(
        latitude: orderModel.addresses![0].lat!,
        longitude: orderModel.addresses![0].lon!,
        cityCode: selectedCityCode);

    String? arrivalAddressName = filterDecodedAddress(address1);

    arrivalAddress = MyAddress(
      lat: orderModel.addresses![0].lat!,
      lon: orderModel.addresses![0].lon!,
      name: arrivalAddressName,
    );

    whereToAriveEdtingController.text = arrivalAddressName ?? "";

    final DecodedAddress address2 = await mainScreenRepostory.reverseGeoCoding(
        latitude: orderModel.addresses![1].lat!,
        longitude: orderModel.addresses![1].lon!,
        cityCode: selectedCityCode);

    String? destinationAddressName = filterDecodedAddress(address2);

    destinationAddress = MyAddress(
      lat: orderModel.addresses![1].lat!,
      lon: orderModel.addresses![1].lon!,
      name: destinationAddressName,
    );

    wheretoGoController.text = destinationAddressName ?? "";

    update();

    Navigator.of(context).pop();

    updateControllerCache();

    Navigator.of(context).pop();

    update();

    Helpers.repeatOrderModel = orderModel;
    moveToTariffRepeat();

    isBottomSheetExpanded = true;
    scrollController.open();
  }

  Future<void> repeatLastTripBack(
      BuildContext context, OrderModel orderModel) async {
    Helpers.showCircularProgressDialog(context: context);
    final DecodedAddress address1 = await mainScreenRepostory.reverseGeoCoding(
        latitude: orderModel.addresses![1].lat!,
        longitude: orderModel.addresses![1].lon!,
        cityCode: selectedCityCode);

    String? arrivalAddressName = filterDecodedAddress(address1);

    arrivalAddress = MyAddress(
      lat: orderModel.addresses![1].lat!,
      lon: orderModel.addresses![1].lon!,
      name: arrivalAddressName,
    );

    whereToAriveEdtingController.text = arrivalAddressName ?? "";

    final DecodedAddress address2 = await mainScreenRepostory.reverseGeoCoding(
        latitude: orderModel.addresses![0].lat!,
        longitude: orderModel.addresses![0].lon!,
        cityCode: selectedCityCode);

    String? destinationAddressName = filterDecodedAddress(address2);

    destinationAddress = MyAddress(
      lat: orderModel.addresses![0].lat!,
      lon: orderModel.addresses![0].lon!,
      name: destinationAddressName,
    );

    wheretoGoController.text = destinationAddressName ?? "";

    update();

    Navigator.of(context).pop();

    updateControllerCache();

    Navigator.of(context).pop();

    update();

    Helpers.repeatOrderModel = orderModel;
    moveToTariffRepeat();

    isBottomSheetExpanded = true;
    scrollController.open();

    // Get.find<HomeViewController>()
  }

  //Food Delivery
  //change screen
  changeScreenStatus(context) async {
    databaseService.saveToDisk(DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
    Get.toNamed(Routes.foodHomeScreen);
    // Navigator.pushNamedAndRemoveUntil(
    //     context, Routes.foodHomeScreen, (route) => true);
  }
//food delivery address return
  String getDeliveryAddress() {
    var data = databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
    var deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));
    var streetAddress = "";
    streetAddress = deliverAddress.name.toString();
    return streetAddress;
  }

  checkLocationIfNeeded() async {
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      // debugPrint("--------------Here call------------");
      serviceEnabled = await location.requestService();

      locationServiceStatus = serviceEnabled
          ? fl.LocationServicesStatus.enabled
          : fl.LocationServicesStatus.disabled;
      permissionGranted = await location.hasPermission();
      update();
    }
  }

  updateLocationIfNeeded() async {
    serviceEnabled = await location.serviceEnabled();
    serviceEnabled = await location.requestService();

    locationServiceStatus = serviceEnabled
        ? fl.LocationServicesStatus.enabled
        : fl.LocationServicesStatus.disabled;
    permissionGranted = await location.hasPermission();
    update();
  }
//Delivery address
  String displayDefaultAddress(AppLocalizations language) {
    if (databaseService
        .getFromDisk(DatabaseKeys.saveDeliverAddress)
        .toString() !=
        "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress)
            .toString()
            .isNotEmpty) {
      return getDeliveryAddress();
    } else if (isLocationEnable()) {
      LocationUtil.checkAndRequestPermission().then((value) => {
        if (value) {this.updateLocationIfNeeded()}
      });
      return language.select_address_or_turn_on_gps;
    } else {
      return getCurrentLocationAddress();
    }
  }

  bool isLocationEnable() {
    return (permissionGranted != PermissionStatus.granted &&
        permissionGranted != PermissionStatus.grantedLimited) ||
        locationServiceStatus == fl.LocationServicesStatus.disabled;
  }

//get current address
  String getCurrentLocationAddress() {
    String currentAddressString = "";

    if (databaseService
        .getFromDisk(DatabaseKeys.saveCurrentAddress)
        .toString() !=
        "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.saveCurrentAddress)
            .toString()
            .isNotEmpty) {
      currentAddressString = databaseService
          .getFromDisk(DatabaseKeys.saveCurrentAddress)
          .toString();
    }

    if(currentAddressString.isEmpty){
      if(arrivalAddress != null){
        if(arrivalAddress.name?.isNotEmpty == true){
          //print("getCurrentLocationAddress-------> ${arrivalAddress.name}");
          databaseService.saveToDisk(DatabaseKeys.saveCurrentAddress, arrivalAddress.name);
          databaseService.saveToDisk(DatabaseKeys.saveCurrentObjectAddress, jsonEncode(arrivalAddress).toString());
          databaseService.saveToDisk(DatabaseKeys.saveCurrentLat, arrivalAddress.lat);
          databaseService.saveToDisk(DatabaseKeys.saveCurrentLang, arrivalAddress.lon);

          currentAddressString = databaseService.getFromDisk(DatabaseKeys.saveCurrentAddress).toString();
        }
      }
    }

    //print("getCurrentLocationAddress-------> ${currentAddressString}");

    return currentAddressString;
  }

  //get active counts
  activeCounts() async {
    var response = await mainScreenRepostory.getActiveCounts(selectedCityCode);
    print("Response-----> $response");
    Map<String,dynamic> mapData = jsonDecode(response.toString());
    var counts = mapData['count'];
    databaseService.saveToDisk(DatabaseKeys.activeOrderCounts, counts.toString());
    update();
  }

  //re call order status
  Future<OrderModel> reCallOrderStatusFetch(BuildContext context) async {
    MakeOrderResponse orderRestoreData = MakeOrderResponse.fromJson(
        jsonDecode(databaseService.getFromDisk(DatabaseKeys.deliveryOrder)));
    //order details api
    print("orderRestoreData :: ${orderRestoreData.orderId}");
    OrderModel orderModels = await orderRepository.updateOrder(
        cityCode: Get.find<HomeViewController>().selectedCityCode,
        orderId: orderRestoreData.orderId.toString());

    return orderModels;
  }

//End
}

enum pageState { Home, TariffSelection }
enum locationState {
  Uknown,
  NoPermission_NoService,
  NoPermission_Service,
  Permission_NoService,
  Permission_Service,
}
