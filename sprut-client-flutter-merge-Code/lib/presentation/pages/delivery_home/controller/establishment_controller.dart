import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sprut/data/models/map_screen_models/my_address_model/my_address_model.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import '../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import '../../../../data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../data/models/establishments_all_screen_models/types/food_type_list_models.dart';
import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';

class EstablishmentController extends GetxController {
  List<Establishments> establishmentsData = [];
  List<Establishments> lsEstablishmentsData = [];
  List<Establishments> tempStoreEstablishmentsData = [];
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  List<Establishments> searchListData = [];
  //for search screen
  TextEditingController searchEstablishmentEditingController =
  new TextEditingController();
  bool isSearchView = false;
  bool isNoDataFound = false;

  MyAddress deliverAddress = MyAddress();

  List<FoodType> lsFoodTypeData = [];

  @override
  void onInit() async {
    super.onInit();
  }

  emptySearchData(){
    searchEstablishmentEditingController.clear();
    searchListData.clear();
    isSearchView = false;
  }

  Widget textMaker(BuildContext context, String text1, String text2,
      String text3, String secondTextColor) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    Color secondryColor = secondTextColor == "Gray"
        ? AppThemes.offWhiteColor
        : colorScheme.primary;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
          TextSpan(
            text: text2,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: secondryColor),
          ),
          TextSpan(
            text: text3,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.secondaryTextColor()),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  clearData() {
    establishmentsData.clear();
    lsEstablishmentsData.clear();
    tempStoreEstablishmentsData.clear();
    update();
  }

  fetchingSaveAddress() {
    if (databaseService
                .getFromDisk(DatabaseKeys.recentlySearchAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.recentlySearchAddress)
            .toString()
            .isNotEmpty) {
      var data = databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
      deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));
    } else {
      deliverAddress = MyAddress();
    }
  }

  fetchingItemList(BuildContext context, String catID) {
    if (databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress).toString() !="null" &&
        databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress).toString().isNotEmpty) {

      debugPrint("---------------Save Delivery Lat and Lon call---------------");

      var data = databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
      var deliverAddress = MyAddress.fromJson(jsonDecode(data.toString()));

      context.read<AuthBloc>().add(AuthAllEstablishmentsListEvent(
          categoryID: catID,
          latitude: deliverAddress.lat!,
          longitude: deliverAddress.lon!));
    } else {

      if (databaseService.getFromDisk(DatabaseKeys.saveCurrentLat) != null && databaseService.getFromDisk(DatabaseKeys.saveCurrentLat) != "null" &&
          databaseService.getFromDisk(DatabaseKeys.saveCurrentLang) != null && databaseService.getFromDisk(DatabaseKeys.saveCurrentLang) != "null") {
        debugPrint("---------------Default Lat and Lon call--------------- ${databaseService.getFromDisk(DatabaseKeys.saveCurrentLat)}");
        debugPrint("---------------Default Lat and Lon call--------------- ${databaseService.getFromDisk(DatabaseKeys.saveCurrentLang)}");
        context.read<AuthBloc>().add(AuthAllEstablishmentsListEvent(
            categoryID: catID,
            latitude: databaseService.getFromDisk(DatabaseKeys.saveCurrentLat),
            longitude: (databaseService.getFromDisk(DatabaseKeys.saveCurrentLang)!='')?databaseService.getFromDisk(DatabaseKeys.saveCurrentLang):23.59 ));
      }

      // else {
      //   debugPrint("---------------Static Lat and Lon call---------------");
      //   context.read<AuthBloc>().add(AuthAllEstablishmentsListEvent(
      //       categoryID: catID, latitude: 49.2130524, longitude: 28.3899292));
      // }
    }
  }

  filterData(String filterID) {
    if (tempStoreEstablishmentsData.isNotEmpty) {
      lsEstablishmentsData = tempStoreEstablishmentsData;
    }

    tempStoreEstablishmentsData = lsEstablishmentsData;
    //filter by type ID
    debugPrint("Before Len Filter:: ${tempStoreEstablishmentsData.length}");
    debugPrint("Before Len Filter:: ${lsEstablishmentsData.length}");
    if (lsEstablishmentsData.isNotEmpty) {
      if (filterID == "0") {
        lsEstablishmentsData = tempStoreEstablishmentsData;
        update();
        return;
      }
      List<Establishments> filteredData = [];
      for (int i = 0; i < lsEstablishmentsData.length; i++) {
        if (lsEstablishmentsData[i].types?.isNotEmpty == true) {
          for (int j = 0; j < lsEstablishmentsData[i].types!.length; j++) {
            if (lsEstablishmentsData[i].types![j].typeId.toString() == filterID) {
              filteredData.add(lsEstablishmentsData[i]);
              break;
            }
          }
        }
      }
      lsEstablishmentsData = filteredData;
      debugPrint("Len Filter:: ${filteredData.length}");
      debugPrint("Len:: ${lsEstablishmentsData.length}");
      update();
    }
  }

  String filterTypes(int index) {
    String typesOdFood = "";
    List<String> typeOfFoodArray = [];
    if (lsEstablishmentsData.isNotEmpty) {
      for (int i = 0; i < lsEstablishmentsData[index].types!.length; i++) {
        typeOfFoodArray
            .add("${lsEstablishmentsData[index].types![i].type?.name}");
      }
    }
    typesOdFood = typeOfFoodArray.join(",");
    return typesOdFood;
  }


  //search of local
  onSearchTextChanged(String text) async {
    print("onSearchTextChanged");
    searchListData.clear();
    if (text.isEmpty) {
      print("Text Is Empty");
      isNoDataFound = false;
      searchListData;
      update();
      return;
    }
    lsEstablishmentsData.forEach((establishmentData) {
      if (establishmentData.name.toString().toLowerCase().contains(text.toString().toLowerCase())){
        searchListData.add(establishmentData);
        isNoDataFound = true;
      }
    });
    // print("onSearchTextChanged1 ${searchListData.length}");
    if(searchListData.isEmpty){
      // print("onSearchTextChanged2");
      isNoDataFound = true;
    }

    update();
  }

  //check timing status
  bool isClosedStore(String startTime, String endTiming){
    DateFormat dateFormat = new DateFormat.Hm();
    DateTime open = dateFormat.parse(startTime);
    DateTime close = dateFormat.parse(endTiming);

    DateTime now = DateTime.now();
    String formattedDate = dateFormat.format(now);
    DateTime finalCurrent = dateFormat.parse(formattedDate);

    // print("startTime :: ${open}");
    // print("endTiming :: ${close}");
    // print("finalCurrent :: ${finalCurrent}");

    if(finalCurrent.isAfter(open) && finalCurrent.isBefore(close)){
      //print("Open Store");
      return true;
    }
    //print("Close Store");
    return false;
  }
}
