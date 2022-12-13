import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fl_location/fl_location.dart' as fl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/map_screen_models/cars_model/cars_model.dart';
import 'package:sprut/data/models/map_screen_models/decoded_address_model/decoded_address_model.dart';
import 'package:sprut/data/models/map_screen_models/last_route_model/last_route_model.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';

import 'package:sprut/data/models/map_screen_models/suggested_cities_model/suggested_cities_model.dart';
import 'package:sprut/data/repositories/map_screen_repostiory/map_screen_repostiory.dart';
import 'package:sprut/presentation/pages/choose_on_map/views/choose_on_map_bottom/choose_on_map_bottom.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/home_screen/views/home_view.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';
import 'package:sprut/resources/configs/routes/routes.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseOnMapController extends GetxController {
  LatLng? homeAddressLocationData;
  LatLng? workAddressLocationData;

  bool mapLoading = false;
  @override
  onClose() async {
    // mapcontroller = null;
    googleMapControllerTwo!.dispose();

    super.onClose();
  }

  var args;

  updateCars() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      getCars();
    });
  }

  @override
  onInit() async {
    super.onInit();

    // fetchUserLocation();
    // getCars();

    Future.delayed(Duration(seconds: 4), () async {
      await updateCurrentLocationMarker();
      update();
    });
    bool _status = await fl.FlLocation.isLocationServicesEnabled;
    if (_status) {
      locationServiceStatus = fl.LocationServicesStatus.enabled;
      log("location data");
      log(locationServiceStatus.toString());
      update();
      log(locationServiceStatus.toString());
    } else {
      locationServiceStatus = fl.LocationServicesStatus.disabled;
      update();
      log(locationServiceStatus.toString());
    }
    fl.FlLocation.getLocationServicesStatusStream().listen((event) {
      locationServiceStatus = event;
      log(locationServiceStatus.toString());
      update();
    });
    // Future.delayed(Duration(milliseconds: 800), () {
    //   animateMap();
    // });
  }

  TextEditingController addWorkAddressEditingController =
      TextEditingController();
  TextEditingController addHomeAddressEditingController =
      TextEditingController();

  bool isWorkAddressScreen = false;
  bool isHomeAddressScreen = false;
  bool isMainMapScreen = false;
  RxString userPhone = "".obs;
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

  MainScreenRepostory mainScreenRepostory = MainScreenRepostory();
  bool showSuggestions = false;
  bool isBottomSheetExpanded = false;
  Map<String, dynamic> cache = {
    "whereToGoControllerText": "",
    "whereToArriveControllerText": ""
  };

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  /// Text Editing Controllers in home view

  TextEditingController whereToAriveEdtingController =
      new TextEditingController();
  TextEditingController wheretoGoController = new TextEditingController();
  FocusNode whereToAriveFocusNode = FocusNode();
  FocusNode wheretoGoFocusNode = FocusNode();

  /// [Google Maps Fields]

  Completer<GoogleMapController> gMapCompleterr = Completer();
  GoogleMapController? googleMapControllerTwo;
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

  void animateMa() {
    googleMapControllerTwo!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: (LatLng(currentCity!.lat, currentCity!.lon)),
          zoom: 17.0,
        ),
      ),
    );
  }

  /// When Maps is created on main screen this call back will call
  onMapsCreated(GoogleMapController controller) async {
    log("on maps created");
    Get.find<HomeViewController>().selectedCityCode =
        databaseService.getFromDisk(DatabaseKeys.selectedCityCode) ?? "vin";

    AvailableCitiesModel? selectedCity;
    if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
      selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
          databaseService.getFromDisk(DatabaseKeys.selectedCity) ?? ''));
      selectCityName.value = selectedCity.name;
      currentCity = selectedCity;
      selectedCityCode = selectedCity.code;

      log("city code");
      log(selectedCityCode);
    }

    googleMapControllerTwo = controller;
    update();
    whereToAriveEdtingController.text = "";
    currentCamPosition = CameraPosition(
      target: LatLng(Get.find<HomeViewController>().locationData!.latitude!,
          Get.find<HomeViewController>().locationData!.longitude!),
    );

    var workAddressLatitude =
        databaseService.getFromDisk(DatabaseKeys.workAddressLatitude);
    log("work address latitude: " + workAddressLatitude.toString());
    var workAddressLongitude =
        databaseService.getFromDisk(DatabaseKeys.workAddressLongitude);

    var homeAddressLatitude =
        databaseService.getFromDisk(DatabaseKeys.homeAddressLatitude);
    var homeAddressLongitude =
        databaseService.getFromDisk(DatabaseKeys.homeAddressLongitude);

    if (workAddressLatitude != null) {
      workAddressLocationData =
          LatLng(workAddressLatitude, workAddressLongitude);
    }

    if (homeAddressLatitude != null) {
      homeAddressLocationData =
          LatLng(homeAddressLatitude, homeAddressLongitude);
    }

    log('workAddressLocationData');
    print(workAddressLocationData);

    log("home address location data");
    print(homeAddressLocationData);

    update();
    Future.delayed(Duration(milliseconds: 1000), () {
      mapLoading = true;
      update();
    });

    var screen;

    if (isWorkAddressScreen) {
      screen = workAddressLocationData;
    } else if (isHomeAddressScreen) {
      screen = homeAddressLocationData;
    }
    if (screen == null) {
      log("screen null");
      
      if (Get.find<HomeViewController>().locationData != null) {
        Future.delayed(Duration(microseconds: 500), () {
          googleMapControllerTwo!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                    Get.find<HomeViewController>().locationData!.latitude!,
                    Get.find<HomeViewController>().locationData!.longitude!),
                zoom: 17.0,
              ),
            ),
          );
        });

        final DecodedAddress address =
            await mainScreenRepostory.reverseGeoCoding(
                latitude:
                    Get.find<HomeViewController>().locationData!.latitude!,
                longitude:
                    Get.find<HomeViewController>().locationData!.longitude!,
                cityCode: selectedCityCode);

        whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

        arrivalAddress = MyAddress(
          lat: address.lon,
          lon: address.lat,
          name: filterDecodedAddress(address),
        );

        update();
      }

      return;
    }

    // log("maps created");
    //  locationData = await location.getLocation();
    //   initialCameraPosition = CameraPosition(
    //           target: LatLng(locationData!.latitude!, locationData!.longitude!),
    //           zoom: 17.0,
    //         );
    //         update();
    log(locationData.toString());
    // Navigator.pop(Get.context!);

    if (isWorkAddressScreen == true) {
      if (workAddressLocationData != null) {
        Future.delayed(Duration(microseconds: 500), () {
          log(workAddressLocationData!.latitude.toString());
          log(workAddressLocationData!.longitude.toString());

          Future.delayed(Duration(seconds: 2), () {
            googleMapControllerTwo!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(workAddressLocationData!.latitude,
                      workAddressLocationData!.longitude),
                  zoom: 17.0,
                ),
              ),
            );
          });
        });

        final DecodedAddress address =
            await mainScreenRepostory.reverseGeoCoding(
                latitude: workAddressLocationData!.latitude,
                longitude: workAddressLocationData!.longitude,
                cityCode: selectedCityCode);

        whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

        arrivalAddress = MyAddress(
          lat: address.lon,
          lon: address.lat,
          name: filterDecodedAddress(address),
        );
        currentCamPosition =
            CameraPosition(target: LatLng(address.lon!, address.lat!));

        update();
      }
    } else if (isHomeAddressScreen == true) {
      if (homeAddressLocationData != null) {
        Future.delayed(Duration(microseconds: 500), () {
          log(homeAddressLocationData!.latitude.toString());
          log(homeAddressLocationData!.longitude.toString());
          googleMapControllerTwo!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(homeAddressLocationData!.latitude,
                    homeAddressLocationData!.longitude),
                zoom: 17.0,
              ),
            ),
          );
        });

        final DecodedAddress address =
            await mainScreenRepostory.reverseGeoCoding(
                latitude: homeAddressLocationData!.latitude,
                longitude: homeAddressLocationData!.longitude,
                cityCode: selectedCityCode);

        whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

        arrivalAddress = MyAddress(
          lat: address.lon,
          lon: address.lat,
          name: filterDecodedAddress(address),
        );

        update();
      }
    } else {
      if (Get.find<HomeViewController>().locationData != null) {
        Future.delayed(Duration(microseconds: 500), () {
          googleMapControllerTwo!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                    Get.find<HomeViewController>().locationData!.latitude!,
                    Get.find<HomeViewController>().locationData!.longitude!),
                zoom: 17.0,
              ),
            ),
          );
        });

        final DecodedAddress address =
            await mainScreenRepostory.reverseGeoCoding(
                latitude:
                    Get.find<HomeViewController>().locationData!.latitude!,
                longitude:
                    Get.find<HomeViewController>().locationData!.longitude!,
                cityCode: selectedCityCode);

        whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

        arrivalAddress = MyAddress(
          lat: address.lon,
          lon: address.lat,
          name: filterDecodedAddress(address),
        );

        update();
      }
    }

    googleMapControllerTwo = controller;
    userPhone.value =
        databaseService.getFromDisk(DatabaseKeys.userPhoneNumber) ?? "";

    update();

    CameraPosition(target: LatLng(currentCity!.lat, currentCity!.lon));
    // animateMap();
    update();

    markersSet = Set<Marker>.of(mapMarkers.values);

    if (!gMapCompleterr.isCompleted) {
      gMapCompleterr.complete(controller);
    }

    if (LatLng(selectedCity!.lat, selectedCity.lon) != null) {
      LatLng position = locationData != null
          ? LatLng(
              locationData!.latitude!,
              locationData!.latitude!,
            )
          : LatLng(selectedCity.lat, selectedCity.lon);

      if (locationData != null) {
        MarkerId markerId = MarkerId("currentlocation");
        centerMarkerID = markerId;
        LatLng position =
            LatLng(locationData!.latitude!, locationData!.latitude!);

        Marker marker = Marker(
          markerId: markerId,
          position: position,
          icon: await Helpers.bitmapDescriptorFromSvgAsset(
              Get.context!, "assets/images/current_location.svg"),
          draggable: false,
        );

        mapMarkers[markerId] = marker;
      }

      update();

      // Future.delayed(Duration(seconds: 4), () async {
      //  googleMapControllerTwo = await gMapCompleterr.future;
      // googleMapControllerTwo!.moveCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //         target: position,
      //         zoom: 17.0,
      //       ),
      //     ),
      //   );
      //   // gMapController.animateCamera(

      //   // );
      //   update();
      // });
    }
  }

  List<Car> cars = [];

  getCars() async {
    // var req = await mainScreenRepostory.fetchCars(cityCode: selectedCityCode);
    // if (req.runtimeType == cars.runtimeType) {
    //   cars = req;
    //   // markersSet.add(value)
    //   // final Uint8List markerIcon =
    //   //     await Helpers.getBytesFromAsset('assets/icons/car.jpg', 40);
    //   BitmapDescriptor markerIcon = await Helpers.getBitmapDescriptorForSVG(
    //       Get.context!, AssetsPath.carSvg,
    //       size: Size(30, 30));
    //   //     ImageConfiguration(devicePixelRatio: 31.2, size: Size(200, 200)),
    //   //     "assets/icons/car.jpg");
    //   // cars = [];
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
    //       // icon: BitmapDescriptor.fromBytes(markerIcon),
    //       icon: markerIcon,
    //       draggable: false,
    //       rotation: car.heading != null ? car.heading!.toDouble() : 0.0,
    //     );
    //     mapMarkers[markerId] = _marker;
    //   }
    //   update();
    //   // update();
    // } else {}
  }

  fetchUserLocation() async {
    final AvailableCitiesModel selectedCity;

    // if (databaseService.getFromDisk(DatabaseKeys.selectedCity) != null) {
    //   selectedCity = AvailableCitiesModel.fromJson(jsonDecode(
    //       databaseService.getFromDisk(DatabaseKeys.selectedCity) ?? ''));
    //   selectCityName.value = selectedCity.name;
    //   selectedCityCode = selectedCity.code;
    //   initialCameraPosition = CameraPosition(
    //     target: LatLng(selectedCity.lat, selectedCity.lon),
    //     zoom: 3.4746,
    //   );
    //   final DecodedAddress address = await mainScreenRepostory.reverseGeoCoding(
    //       latitude: selectedCity.lat,
    //       longitude: selectedCity.lon,
    //       cityCode: selectedCityCode);

    //   whereToAriveEdtingController.text = filterDecodedAddress(address) ?? "";

    //   arrivalAddress = MyAddress(
    //     lat: selectedCity.lat,
    //     lon: selectedCity.lon,
    //     name: filterDecodedAddress(address),
    //   );

    //   update();
    // }

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
      // locationData = await location.getLocation();
      // // Navigator.pop(Get.context!);
      // if (locationData != null) {
      //   googleMapControllerTwo!.moveCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //         target: LatLng(locationData!.latitude!, locationData!.longitude!),
      //         zoom: 17.0,
      //       ),
      //     ),
      //   );
      // }
      {}
    }

    location.onLocationChanged.listen((LocationData currentLocation) async {
      locationData = currentLocation;

      update();
      // updateCurrentLocationString(
      //     LatLng(currentLocation.latitude!, currentLocation.longitude!));
      // currentLocationString = await decodeLocationString(
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
    // updateCurrentLocationMarker();
    await updateCurrentLocationMarker();
    getCars();
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
        } else if (lastFocus == "whereToGo") {
          wheretoGoController.text = filterDecodedAddress(request);
          arrivalAddress = MyAddress(
            lat: latLong.latitude,
            lon: latLong.longitude,
            name: filterDecodedAddress(request),
          );
        } else {
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
    cache['whereToGoControllerText'] = wheretoGoController.text;
    cache['whereToArriveControllerText'] = whereToAriveEdtingController.text;
  }

  updateCurrentLocationString(LatLng latLong) async {
    var request = await mainScreenRepostory.reverseGeoCoding(
        latitude: Get.find<HomeViewController>().locationData!.latitude!,
        longitude: Get.find<HomeViewController>().locationData!.longitude!,
        cityCode: Get.find<HomeViewController>().selectedCityCode);
    if (request.runtimeType == DecodedAddress) {
      currentLocationString = filterDecodedAddress(request);
      update();
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

  animateToCurrent() async {
    if (locationData != null) {
      googleMapControllerTwo!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                Get.find<HomeViewController>().locationData!.latitude!,
                Get.find<HomeViewController>().locationData!.longitude!),
            zoom: 17.0,
          ),
        ),
      );
    }
  }

  /// [Gps widget on home screen when we tap then it will check weather location is on or of]

  locationStatusBar(context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    if (getLocationState() == locationState.Uknown) {
      log(getLocationState().toString());
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
                  padding: EdgeInsets.all(12),
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
              margin: EdgeInsets.only(top: 2, left: 10, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xfff5f5f5),
              ),
              child: Text(
                "Turn on GPS for automatic determination of your location",
                style: textTheme.bodyText1!
                    .copyWith(color: AppThemes.dark, fontSize: 10.sp),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await fetchUserLocation();
              },
              child: Container(
                  width: 16.w,
                  height: 7.3.h,
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

  /// [Formating Address]
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

  onMyLocationTap(context) async {
    if (whereToAriveFocusNode.hasFocus || lastFocus == "whereToArrive") {
      if (locationData != null) {
        // Helpers.showStatelessLoader(context);

        var res = await decodeLocationString(
            LatLng(locationData!.latitude!, locationData!.longitude!));
        // ProgressLoader().dismiss();
        if (res.runtimeType == String) {
          whereToAriveEdtingController.text = res;
          arrivalAddress = MyAddress(
            name: res,
            // address: currentLocationString,
            lat: locationData!.latitude,
            lon: locationData!.longitude,
            city: currentCity!.name,
            cityCode: currentCity!.code,
          );
          updateControllerCache();
          update();

          if (destinationAddress.name != null) {
            ////MOVE TO TARIFF
          } else {
            whereToAriveFocusNode.unfocus();
          }
        }
      }
    }
    if (wheretoGoFocusNode.hasFocus || lastFocus == "whereToGo") {
      wheretoGoController.text = currentLocationString ?? "";
      destinationAddress = MyAddress(
        name: currentLocationString,
        // address: currentLocationString,
        lat: locationData!.latitude,
        lon: locationData!.longitude,
        city: currentCity!.name,
        cityCode: currentCity!.code,
      );
      updateControllerCache();

      update();

      if (arrivalAddress.name != null) {
        ////MOVE TO TARIFF
      } else {
        whereToAriveFocusNode.unfocus();
      }
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

  chooseOnMapBottom(context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return ChooseOnMapBottomView();
  }
}
