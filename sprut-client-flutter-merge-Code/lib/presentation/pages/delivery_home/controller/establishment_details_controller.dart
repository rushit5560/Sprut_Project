import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';

import '../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import '../../../../data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../data/models/establishments_all_screen_models/establishment_product_list/items_cart_models.dart';
import '../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../data/models/map_screen_models/my_address_model/my_address_model.dart';
import '../../../../data/models/oder_delivery/oder_delivery_response.dart';
import '../../../../data/repositories/order_repository/order_repository.dart';
import '../../../../resources/app_constants/app_constants.dart';
import '../../../../resources/app_themes/app_themes.dart';
import '../../../../resources/assets_path/assets_path.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../../../../resources/configs/routes/routes.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../../../resources/services/database/database_keys.dart';
import '../../../widgets/custom_dialog/widget_dialog.dart';
import '../../home_screen/controllers/home_controller.dart';
import '../../order_screen/controllers/order_controller.dart';
import '../../payment_screen/controllers/payment_controller.dart';

class EstablishmentDetailsController extends GetxController {
  //cart Array
  // List<ProductItems>? cartItemList = [];

  List<ItemsCartModels>? cartItemList = [];

  //temp cart
  // List<ProductItems>? tempCartItemList = [];
  Establishments storeDetailsData = Establishments();
  bool isShowData = false;
  bool isConfirmButton = true;
  List<ProductItems>? productList = [];

  bool isDialogShow = false;
  bool isDeleteDialogShow = false;
  bool isReCallProgressBar = false;

  // List<Section> sectionData = [];
  // Map<Section, List<ProductItems>>? sections = null;

  DatabaseService databaseService = serviceLocator.get<DatabaseService>();
  OrderRepository orderRepository = OrderRepository();

  // MyAddress deliverAddress = MyAddress();
  TextEditingController numberOfApplianceController = TextEditingController();
  TextEditingController noteTextController = TextEditingController();

  //item details var
  // ProductItems? selectedItem;
  ProductItems? tempItems;
  int? selectedIndex;
  bool isShowItemDetails = false;

  //temp data
  List<ProductItems>? tempData = [];

  //for search screen
  TextEditingController searchEstablishmentEditingController = new TextEditingController();
  bool isSearchView = false;
  bool isNoDataFound = false;
  List<ProductItems>? searchProductList = [];

  RxString _deliveryOrderId = "".obs;

  String get deliveryOrderId => _deliveryOrderId.value;

  set deliveryOrderId(value) => _deliveryOrderId.value = value;

  RxString _status = "new".obs;

  String get status => _status.value;

  set status(value) => _status.value = value;

  RxString _lastSaveStatus = "".obs;

  String get lastSaveStatus => _lastSaveStatus.value;

  set lastSaveStatus(value) => _lastSaveStatus.value = value;

  MakeOrderResponse? _orderModel;

  MakeOrderResponse? get orderModel => _orderModel;

  set orderModel(value) => _orderModel = value;

  OrderModel? _orderModel1;

  OrderModel? get orderModel1 => _orderModel1;

  set orderModel1(value) => _orderModel1 = value;

  bool isPopUp = false;

  var isLoaderRunning = true.obs;

  @override
  void onInit() async {

    super.onInit();
  }

  clearData() {
    isShowData = false;
    productList?.clear();
    cartItemList?.clear();
  }

  fetchingItemList(BuildContext context, String _brandID, String _establishmentID, String _placeID) {
    context
        .read<AuthBloc>()
        .add(AuthEstablishmentProductListEvent(brandID: _brandID, establishmentId: _establishmentID, placeId: _placeID));
  }

  filterSection() {
    tempData = productList;
    if (tempData?.isNotEmpty == true) {
      var overOneDollar = tempData
          ?.where((p) => p.brandId == p.section?.brandId)
          .toList(); //prints 3.33, 4.25, 5.99
    }
  }

  //add item cart
  addItemInCart(ProductItems item) {
    debugPrint("Position :: $item");

    //check cart
    if (cartItemList?.isEmpty == true) {
      //first item add in cart
      item.quantity = 1;
      // cartItemList?.add(item);

      //add new items in cart
      cartItemList?.add(ItemsCartModels(
        id: item.id,
        name: item.name,
        nameEn: item.nameEn,
        nameUk: item.nameUk,
        nameRu: item.nameRu,
        shortDescriptionEn: item.shortDescriptionEn,
        shortDescriptionUk: item.shortDescriptionUk,
        shortDescriptionRu: item.shortDescriptionRu,
        detailedDescriptionEn: item.detailedDescriptionEn,
        detailedDescriptionUk: item.detailedDescriptionUk,
        detailedDescriptionRu: item.detailedDescriptionRu,
        weight: item.weight,
        price: item.price,
        imgUrl: item.imgUrl,
        shortDescription: item.shortDescription,
        detailedDescription: item.detailedDescription,
        status: item.status,
        removed: item.removed,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        brandId: item.brandId,
        sectionId: item.sectionId,
        quantity: item.quantity,
      ));

      update();

      debugPrint("Cart Array First :: ${item.toString()}");
    } else {
      var productsItemIndex =
      productList?.indexWhere((element) => element.id == item.id);
      // print("Exit Array Index ::" + itemIndex.toString());

      //find index
      var itemIndex =
      cartItemList?.indexWhere((element) => element.id == item.id);

      if (itemIndex!.toInt() >= 0) {
        //plus
        int? qnt = item.quantity;
        item.quantity = qnt!.toInt() + 1;
        //cart item update
        cartItemList![itemIndex.toInt()].quantity = qnt + 1;

        //change qty in produect array
        productList![productsItemIndex!.toInt()].quantity = qnt + 1;
        // newCartItemList![newItemIndex!.toInt()].quantity = qnt + 1;
        update();
        debugPrint("Cart Array Update Item :: ${cartItemList.toString()}");

      } else {
        //add item in cart array
        item.quantity = 1;
        // cartItemList?.add(item);
        cartItemList?.add(ItemsCartModels(
          id: item.id,
          name: item.name,
          nameEn: item.nameEn,
          nameUk: item.nameUk,
          nameRu: item.nameRu,
          shortDescriptionEn: item.shortDescriptionEn,
          shortDescriptionUk: item.shortDescriptionUk,
          shortDescriptionRu: item.shortDescriptionRu,
          detailedDescriptionEn: item.detailedDescriptionEn,
          detailedDescriptionUk: item.detailedDescriptionUk,
          detailedDescriptionRu: item.detailedDescriptionRu,
          weight: item.weight,
          price: item.price,
          imgUrl: item.imgUrl,
          shortDescription: item.shortDescription,
          detailedDescription: item.detailedDescription,
          status: item.status,
          removed: item.removed,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          brandId: item.brandId,
          sectionId: item.sectionId,
          quantity: item.quantity,
        ));

        update();
        debugPrint("Cart Array Second :: ${cartItemList.toString()}");
      }
    }
  }

  saveItemInCart(ProductItems item) {
    debugPrint("Position :: $item");

    //check cart
    if (cartItemList?.isEmpty == true) {
      // cartItemList?.add(item);

      cartItemList?.add(ItemsCartModels(
        id: item.id,
        name: item.name,
        nameEn: item.nameEn,
        nameUk: item.nameUk,
        nameRu: item.nameRu,
        shortDescriptionEn: item.shortDescriptionEn,
        shortDescriptionUk: item.shortDescriptionUk,
        shortDescriptionRu: item.shortDescriptionRu,
        detailedDescriptionEn: item.detailedDescriptionEn,
        detailedDescriptionUk: item.detailedDescriptionUk,
        detailedDescriptionRu: item.detailedDescriptionRu,
        weight: item.weight,
        price: item.price,
        imgUrl: item.imgUrl,
        shortDescription: item.shortDescription,
        detailedDescription: item.detailedDescription,
        status: item.status,
        removed: item.removed,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        brandId: item.brandId,
        sectionId: item.sectionId,
        quantity: item.quantity,
      ));

      update();

      debugPrint("Cart Array First :: ${item.toString()}");
    } else {
      var itemIndex =
          cartItemList?.indexWhere((element) => element.id == item.id);
      print("Exit Array Index ::" + itemIndex.toString());


      if (itemIndex!.toInt() >= 0) {
        //plus
        int? qnt = item.quantity;
        item.quantity = qnt!.toInt();
        //cart item update
        cartItemList![itemIndex.toInt()].quantity = qnt;
        update();
        debugPrint("Cart Array Update Item :: ${cartItemList.toString()}");
      } else {
        //add item in cart array
        // cartItemList?.add(item);

        cartItemList?.add(ItemsCartModels(
          id: item.id,
          name: item.name,
          nameEn: item.nameEn,
          nameUk: item.nameUk,
          nameRu: item.nameRu,
          shortDescriptionEn: item.shortDescriptionEn,
          shortDescriptionUk: item.shortDescriptionUk,
          shortDescriptionRu: item.shortDescriptionRu,
          detailedDescriptionEn: item.detailedDescriptionEn,
          detailedDescriptionUk: item.detailedDescriptionUk,
          detailedDescriptionRu: item.detailedDescriptionRu,
          weight: item.weight,
          price: item.price,
          imgUrl: item.imgUrl,
          shortDescription: item.shortDescription,
          detailedDescription: item.detailedDescription,
          status: item.status,
          removed: item.removed,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          brandId: item.brandId,
          sectionId: item.sectionId,
          quantity: item.quantity,
        ));

        update();
        debugPrint("Cart Array Second :: ${cartItemList.toString()}");
      }
    }
  }

  //add item cart
  //ProductItems old
  removeItemInCart(ProductItems item) {
    //check cart
    if (cartItemList?.isNotEmpty == true) {
      var productsItemIndex =
          productList?.indexWhere((element) => element.id == item.id);

      var itemIndex =
          cartItemList?.indexWhere((element) => element.id == item.id);
      print("Exit Array Index ::" + itemIndex.toString());


      if (itemIndex!.toInt() >= 0) {
        int? qnt = item.quantity;
        item.quantity = qnt!.toInt() - 1;
        //cart item update
        cartItemList![itemIndex.toInt()].quantity = qnt - 1;
        int? cartItemQty = cartItemList![itemIndex.toInt()].quantity;
        print("cartItemQty ::" + cartItemQty.toString());

        productList![productsItemIndex!.toInt()].quantity = qnt - 1;

        if (cartItemQty != 0) {
          //minus
          update();
          debugPrint("Cart Array Update Item :: ${cartItemList.toString()}");
        } else {
          //add item in cart array
          item.quantity = 0;

          //produect item 0
          productList![productsItemIndex.toInt()].quantity = 0;
         // ItemsCartModels obje =  ItemsCartModels(
         //    id: item.id,
         //    name: item.name,
         //    weight: item.weight,
         //    price: item.price,
         //    imgUrl: item.imgUrl,
         //    shortDescription: item.shortDescription,
         //    detailedDescription: item.detailedDescription,
         //    status: item.status,
         //    removed: item.removed,
         //    createdAt: item.createdAt,
         //    updatedAt: item.updatedAt,
         //    brandId: item.brandId,
         //    sectionId: item.sectionId,
         //    quantity: item.quantity,
         //  );

          cartItemList?.removeAt(itemIndex);

          update();
          debugPrint("removeItemInCart Second :: ${cartItemList.toString()}");
        }
      }
    }
  }

  //delete item from cart
  deleteItemInCart(ProductItems item) {
    //check cart
    if (cartItemList?.isNotEmpty == true) {
      var productItemIndex = productList?.indexWhere((element) => element.id == item.id);
      if(productItemIndex!.toInt() >= 0){
        //produect item 0
        productList![productItemIndex.toInt()].quantity = 0;
      }

      var itemIndex = cartItemList?.indexWhere((element) => element.id == item.id);
      print("Exit Index ::" + itemIndex.toString());
      if (itemIndex!.toInt() >= 0) {
        print("Delete Index");
        item.quantity = 0;
        // cartItemList?.remove(item);
        cartItemList?.removeAt(itemIndex);
        update();
      }
    }
    print("Data Into Cart :: ${cartItemList?.length.toString()}");
    update();
  }

  //Cart Items
  int getTotalCartItem() {
    if (cartItemList?.isNotEmpty == true) {
      int totalItems = 0;
      for (int c = 0; c < cartItemList!.length; c++) {
        totalItems = (totalItems + cartItemList![c].quantity!.toInt());
      }
      return totalItems;
    }
    return 0;
  }

  double getSubTotal() {
    if (cartItemList?.isNotEmpty == true) {
      double amountTotal = 0;
      for (int c = 0; c < cartItemList!.length; c++) {
        var amount;
        String prices = cartItemList![c].price!;
        amount = (cartItemList![c].quantity! * double.parse(prices));
        amountTotal = amountTotal + amount;
        // debugPrint(amountTotal.toString());
      }
      return double.parse(amountTotal.toStringAsFixed(2));
    }
    return 0;
  }

  double getCashback() {
    return storeDetailsData.getCashBack(getSubTotal());
  }

  double getTotal() {
    return getSubTotal();
  }

  //calculate free shipping
  String freeShippingAmount() {
    // debugPrint("freeShippingAmount");
    num shippingAmount = 0;
    if (double.parse(storeDetailsData.minimalPrice.toString()) >
        double.parse(getCartItemFinalTotalAmount())) {
      shippingAmount = (double.parse(storeDetailsData.minimalPrice.toString()) -
          double.parse(getCartItemFinalTotalAmount()));
    }
    // debugPrint("freeShippingAmount IS --> $shippingAmount");
    return shippingAmount.toStringAsFixed(2);
  }

  //cart item total counts
  String getCartItemTotalAmount() {
    if (cartItemList?.isNotEmpty == true) {
      num amountTotal = 0;
      for (int c = 0; c < cartItemList!.length; c++) {
        var amount;
        String prices = cartItemList![c].price!;
        amount = (cartItemList![c].quantity! * double.parse(prices));
        amountTotal = amountTotal + amount;
        debugPrint(amountTotal.toString());
      }
      return "${amountTotal.toStringAsFixed(2)}";
    }
    return "0";
  }

  //final total amount
  String getCartItemFinalTotalAmount() {
    if (cartItemList?.isNotEmpty == true) {
      num amountTotal = 0;
      for (int c = 0; c < cartItemList!.length; c++) {
        var amount;
        String prices = cartItemList![c].price!;
        amount = (cartItemList![c].quantity! * double.parse(prices));
        amountTotal = amountTotal + amount;
        //with shipping amount
        // debugPrint(amountTotal.toString());
      }
      return "${amountTotal.toStringAsFixed(2)}";
    }
    return "0";
  }

  String getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount() {
    num finalAmountTotal = 0;
    if (cartItemList?.isNotEmpty == true) {
      // if ((storeDetailsData.cashbackPercent ?? 0) > 0){
      //   finalAmountTotal = double.parse(getCartItemFinalTotalAmount()) - (getCashback());
      //   // debugPrint("$finalAmountTotal");
      //   finalAmountTotal = finalAmountTotal + double.parse(freeShippingAmount()) + storeDetailsData.calculatedPrice!.toInt();
      //   return finalAmountTotal.toStringAsFixed(2);
      // }
      finalAmountTotal = (double.parse(getCartItemFinalTotalAmount()) +
          double.parse(freeShippingAmount()) +
          storeDetailsData.calculatedPrice!.toInt());
      return finalAmountTotal.toStringAsFixed(2);
    }
    return "${finalAmountTotal.toStringAsFixed(2)}";
  }

  double getCalculateCashBackAmount(ProductItems? items) {
    num calculateAmount = 0;
    calculateAmount = (double.parse(items!.price.toString()) *
        (storeDetailsData.cashbackPercent ?? 0) /
        100);
    return double.parse(calculateAmount.toStringAsFixed(2));
  }

  //single item total
  double getSingleItemTotal(ProductItems? items) {
    num amountTotal = 0;
    var amount;
    String prices = items!.price.toString();
    // print("-----------!!!${items.price.toString()}!!!!--------------");
    // print("-----------*****${prices}****--------------");
    amount = (items.quantity! * double.parse(prices));
    amountTotal = amountTotal + amount;
    // debugPrint(amountTotal.toString());
    return amountTotal.toDouble();
  }

  onViewCart(BuildContext context) async {
    isDialogShow = true;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;

    // if (int.parse(storeDetailsData.minimalPrice
    //     .toString()) <
    //     int.parse(getCartItemFinalTotalAmount())) {
    //   await Navigator.of(context).pushNamed(Routes.foodDeliveryShoppingCartView);
    //   print("object");
    //   return;
    // }
    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: language.cart_lower_than_minimum_title,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
          TextSpan(
            text: "${storeDetailsData.minimalPrice} ${language.currency_symbol}",
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: colorScheme.primary),
          ),
          TextSpan(
            text: language.cart_lower_than_minimum_subtitle,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
          TextSpan(
            text: "${storeDetailsData.minimalPrice} ${language.currency_symbol}",
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: colorScheme.primary),
          ),
          TextSpan(
            text: '.',
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),

        ],
      ),
      textAlign: TextAlign.center,
    );

    showDialog(
        context: context,
        builder: (context) => WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.substracIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () {
                isDialogShow = false;
                //close screen
                Navigator.of(context).pop();
              },
              onNegativePressed: () {
                isDialogShow = false;
                debugPrint("OnPressed1!!");
              },
            ));
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

  //Store open close status
  Future<bool> storeStatusChecked(BuildContext context) async {
    Helpers.showCircularProgressDialog(context: context);
    var response  = await orderRepository.storeStatusChecked(
        cityCode: Get.find<HomeViewController>().selectedCityCode);
    print("Store Status :: ${response.toString()}");
    Navigator.pop(context);
    Map<String, dynamic> json = response;
    if(json["status"] == true){
      //open
      return true;
    }
    return false;
  }

  //Order api call
  makeOrder(BuildContext context) async {
    var language = AppLocalizations.of(context)!;
    var deliverAddress;
    String saveDeliveryAddress="";
    if (databaseService
                .getFromDisk(DatabaseKeys.saveDeliverAddress)
                .toString() !=
            "null" &&
        databaseService
            .getFromDisk(DatabaseKeys.saveDeliverAddress)
            .toString()
            .isNotEmpty) {
      var saveDeliveryAddress =
          databaseService.getFromDisk(DatabaseKeys.saveDeliverAddress);
      deliverAddress =
          MyAddress.fromJson(jsonDecode(saveDeliveryAddress.toString()));
    } else {
       saveDeliveryAddress =
          databaseService.getFromDisk(DatabaseKeys.saveCurrentAddress);
      // print("object------> ${saveDeliveryAddress}");
      var saveCurrentAddressObjectAddress =
          databaseService.getFromDisk(DatabaseKeys.saveCurrentObjectAddress);
      deliverAddress = MyAddress.fromJson(
          jsonDecode(saveCurrentAddressObjectAddress.toString()));
    }

    var countOfPersons = numberOfApplianceController.text.trim();
    var commentForEstablishment = noteTextController.text.trim();

    Helpers.showCircularProgressDialog(context: context);

    var requestParam = {
      // "brandId": storeDetailsData.brandId,
      "addresses": [
        {
          "description": deliverAddress.name,
          "lon": deliverAddress.lon ?? 0.0,
          "lat": deliverAddress.lat ?? 0.0,
          "houseNumber": deliverAddress.houseNo ?? "",
          "osmId": storeDetailsData.place?.osmId ?? "",
          "name": deliverAddress.name,
          "city": deliverAddress.city ?? "",
          "street": deliverAddress.street ?? ""
        }
      ],
      "tipToDriver": 0,
      "anotherClientPhone":
          "380${databaseService.getFromDisk(DatabaseKeys.userPhoneNumber) ?? ""}",
      "establishmentId": storeDetailsData.id,
      "status": 'new',
      "products": await fetchItems(),
      "countOfPersons": countOfPersons.isNotEmpty ? countOfPersons : 1,
      "commentForEstablishment": commentForEstablishment,
      "comment": "${databaseService.getFromDisk(DatabaseKeys.userDeliverBuildingAddress) ?? ""}",
      "total": double.parse(
              getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount())
          .round()
    };
    //getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount
    //call create order api
    try {
      final makeOrderResponse = await orderRepository.createOrder(
          cityCode: Get.find<HomeViewController>().selectedCityCode,
          data: requestParam);

      print("MakeOrderResponse  ${makeOrderResponse}");

      Navigator.pop(context);
      if (makeOrderResponse.orderId != null && makeOrderResponse.orderId.toString().isNotEmpty) {
        // Navigator.pop(context);
        this.orderModel = makeOrderResponse;
        deliveryOrderId = makeOrderResponse.orderId.toString();
        status = makeOrderResponse.deliveryStatus;
        lastSaveStatus = status;
        //save order
        databaseService.saveToDisk(
            DatabaseKeys.deliveryOrder, jsonEncode(makeOrderResponse.toJson()));
        //save establishment data
        databaseService.saveToDisk(
            DatabaseKeys.establishmentObject, jsonEncode(storeDetailsData.toJson()));
        //save Cart Array
        databaseService.saveToDisk(DatabaseKeys.cartObject, jsonEncode(cartItemList));

        //save price
        databaseService.saveToDisk(DatabaseKeys.orderAmounts,
            getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount());
        //getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount
        update();
        //call status update api every 10 sec
        // updateOrderTimer();
        updateOrderTimer(context);
        //show alert dialog
        onShowOrderPreparedDialog(
            context,
            language.order_processing_sub_message,
            language.order_processing_title_message,
            "",
            language.cancel,
            "",
            true,
            false,
            false,
            AssetsPath.processingTimerIcon);
      } else {
        //session expired
        Helpers.clearUser();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.foodHomeScreen, ModalRoute.withName('/'));
      }
    } catch (e) {
      Navigator.pop(context);
      var textTheme = Theme.of(context).textTheme;

      if("${e}" == "The product is not available:"){
        isPopUp = true;
        showDialog(
          context: context,
          builder: (moContext) => WidgetDialog(
            titleWidget: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${language.product_not_available}\n",
                    style: textTheme.bodyText2!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Helpers.primaryTextColor()),
                  ),
                  TextSpan(
                    text: fetchItemsName(),
                    style: textTheme.bodyText2!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Helpers.primaryTextColor()),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            icons: AssetsPath.orderCancelCartIcon,
            okButtonText: language.okay,
            closeButtonText: "",
            isSingleButton: true,
            isBothButtonHide: false,
            isCloseDialog: false,
            onPositivePressed: () {
              isPopUp = false;
              //close screen
              Navigator.of(moContext).pop();
            },
            onNegativePressed: () {
              isPopUp = false;
              Navigator.of(moContext).pop();
            },
          ),
        );
      }else {
        Map<String, dynamic> data = jsonDecode(e.toString());
        var errorMessage = data["data"]["error"];
        print("Error is -->$errorMessage");
        if(errorMessage.toString() == "establishmentIsClosed"){
          isPopUp = true;
          showDialog(
            context: context,
            builder: (moContext) => WidgetDialog(
              titleWidget: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: language.establishment_close_message,
                      style: textTheme.bodyText2!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Helpers.primaryTextColor()),
                    ),
                    TextSpan(
                      text:
                      "\n${language.working_hours} ${data["data"]["data"]["openTime"]} - ${data["data"]["data"]["closeTime"]}",
                      style: textTheme.bodyText2!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Helpers.primaryTextColor()),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              icons: AssetsPath.orderCancelCartIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () {
                isPopUp = false;
                //close screen
                Navigator.of(moContext).pop();
              },
              onNegativePressed: () {
                isPopUp = false;
                Navigator.of(moContext).pop();
              },
            ),
          );
        }else {
          isPopUp = true;
          showDialog(
            context: context,
            builder: (moContext) => WidgetDialog(
              titleWidget: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: language.product_not_available,
                      style: textTheme.bodyText2!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Helpers.primaryTextColor()),
                    ),
                    TextSpan(
                      text: fetchItemsName(),
                      style: textTheme.bodyText2!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Helpers.primaryTextColor()),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              icons: AssetsPath.orderCancelCartIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () {
                isPopUp = false;
                //close screen
                Navigator.of(moContext).pop();
              },
              onNegativePressed: () {
                isPopUp = false;
                Navigator.of(moContext).pop();
              },
            ),
          );
        }

      }
      print("MakeOrderResponse :: ${e}");
    }
  }

  //re call order status
  reCallOrderStatusFetch(BuildContext context){
    MakeOrderResponse orderRestoreData = MakeOrderResponse.fromJson(
        jsonDecode(databaseService.getFromDisk(DatabaseKeys.deliveryOrder)));
    orderModel = orderRestoreData;
    deliveryOrderId = orderModel?.orderId.toString();
    status = orderModel?.deliveryStatus;
    updateOrder(context);
    Future.delayed(Duration(seconds: 2),(){
      isLoaderRunning(false);
      update();
      updateOrderTimer(context);
    });

    update();
  }

  //Fetch products from cart
  List<Map<String, dynamic>> fetchItems() {
    List<Map<String, dynamic>> cartItems = [];
    for (int i = 0; i < cartItemList!.length; i++) {
      cartItems.add(
          {"id": cartItemList![i].id, "quantity": cartItemList![i].quantity});
    }
    print(cartItems.toString());
    return cartItems;
  }

  //Fetch products from cart only name
  String fetchItemsName() {
    List<String> result = [];
    for (int i = 0; i < cartItemList!.length; i++) {
      result.add(cartItemList![i].name.toString());
    }
    return result.join(', ');
  }

  Timer? timer;

  updateOrderTimer(BuildContext context) async {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      updateOrder(Get.context!);
    });
  }

  //fetch oder status api
  updateOrder(BuildContext context) async {
    var language = AppLocalizations.of(Get.context!)!;

    if(orderModel != null){
      OrderModel orderModels = await orderRepository.updateOrder(
          cityCode: Get.find<HomeViewController>().selectedCityCode,
          orderId: this.orderModel!.orderId.toString());

      status = orderModels.deliveryStatus;
      //save last status
      databaseService.saveToDisk(DatabaseKeys.lastStatus, lastSaveStatus);
      //save current payment type
      databaseService.saveToDisk(
          DatabaseKeys.paymentMethod, Get.find<PaymentController>().paymentType);
      this.orderModel1 = orderModels;
      print("Last Status-->${lastSaveStatus}");
      print("Status-->${status}");

      if (status == "new") {
        //create new order
        if(lastSaveStatus != status){
          onShowOrderPreparedDialog(
              context,
              language.order_processing_sub_message,
              language.order_processing_title_message,
              "",
              language.cancel,
              "",
              true,
              false,
              false,
              AssetsPath.processingTimerIcon);
        }
        lastSaveStatus = status;
      } else if (status == "canceledKitchen") {
        //cancel order from establishment
        timer?.cancel();
        if (lastSaveStatus != status) {
          onShowOrderPreparedDialog(
              context,
              language.order_cancel_message,
              language.order_cancel_title_message,
              "\n${orderModels.deliveryCancelReason.toString()}\n",
              language.okay,
              "",
              false,
              false,
              lastSaveStatus.isEmpty ? false : true,
              AssetsPath.removeCart);
        }
        lastSaveStatus = status;
      } else if (status == "accepted") {
        if (lastSaveStatus != status) {
          try {
            print("----------------Call Payment Card Api -------------");
            await orderRepository.addPaymentOrder(
                cityCode: Get.find<HomeViewController>().selectedCityCode,
                orderId: deliveryOrderId,
                paymentType: Get.find<PaymentController>().paymentType);
            //Get.find<PaymentController>().paymentType
          } catch (e) {
            print("payment error");
          }
          onShowOrderPreparedDialog(
              context,
              language.order_payment_made_message,
              language.order_payment_made_title,
              "",
              "",
              "",
              true,
              true,
              lastSaveStatus.isEmpty ? false : true,
              AssetsPath.paymentMethod);
        }
        //accepted order
        var res = await orderRepository.payOrderPaymentOrder(
            cityCode: Get.find<HomeViewController>().selectedCityCode,
            orderId: deliveryOrderId,
            price: getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount());
        //getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount(
        print("Response --- >1 ${res}");

        if (res != null) {
          Map<String, dynamic> json = res;
          if (json['status'] == "error" || json['code'] == 500 || json['code'] == 404) {
            print("IF CONDITION");
            timer?.cancel();
            onShowOrderPreparedDialog(
                context,
                language.order_payment_failed_message,//language.order_payment_failed_message
                language.order_payment_failed_title,
                "",
                language.change_payment_method,
                language.back_to_payment,
                false,
                false,
                lastSaveStatus.isEmpty ? false : true,
                AssetsPath.saidSmileFaceWhite);
          }
          else {
            print("ELSE IF CONDITION");
            // if(lastSaveStatus != status) {
            //   onShowOrderPreparedDialog(
            //       context,
            //       language.order_confirm_message,
            //       language.order_confirm_title,
            //       "",
            //       language.check_order,
            //       language.skip,
            //       false,
            //       false,
            //       lastSaveStatus.isEmpty ? false : true,
            //       AssetsPath.happySmileIcon);
            // }
          }
        }
        lastSaveStatus = status;
        //failed payment
      } else if (status == "paid") {
        print("object-------------------->${lastSaveStatus}");
        //paid screen
        timer?.cancel();
        if(lastSaveStatus != status) {
          onShowOrderPreparedDialog(
              context,
              language.order_confirm_message,
              language.order_confirm_title,
              "",
              language.check_order,
              language.skip,
              false,
              false,
              lastSaveStatus.isEmpty ? false : true,
              AssetsPath.happySmileIcon);
        }
        lastSaveStatus = status;
      } else if (status == "notAccepted") {
        //cancel order from establishment
        timer?.cancel();
        if (lastSaveStatus != status) {
          onShowOrderPreparedDialog(
              context,
              language.order_cancel_message,
              language.order_cancel_title_message,
              "\n${orderModels.deliveryCancelReason.toString()}\n",
              language.okay,
              "",
              true,
              false,
              lastSaveStatus.isEmpty ? false : true,
              AssetsPath.orderCancelCartIcon);
        }
        lastSaveStatus = status;
      } else if (status == "completed") {
        timer?.cancel();
        if (lastSaveStatus != status) {
          onShowOrderPreparedDialog(
              context,
              language.order_confirm_message,
              language.order_confirm_title,
              "",
              language.check_order,
              language.skip,
              false,
              true,
              lastSaveStatus.isEmpty ? false : true,
              AssetsPath.happySmileIcon);
        }
        lastSaveStatus = status;
      } else if (status == "cooking") {
        print("Payment Status In Cooking ----> ${orderModels.paymentStatus}");
        print("Payment Status In Cooking ----> ${orderModels.status}");

        if(orderModels.paymentStatus == "new") {
          var res = await orderRepository.payOrderPaymentOrder(
              cityCode: Get.find<HomeViewController>().selectedCityCode,
              orderId: deliveryOrderId,
              price: getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount());
          print("Routes---> ${Get.currentRoute}");
          if (res != null) {
            Map<String, dynamic> json = res;
            if (json['status'] == "error") {
              if(Get.currentRoute == Routes.foodDeliveryShoppingCartView){
                timer?.cancel();
                onShowOrderPreparedDialog(
                    context,
                    language.order_payment_failed_message,//language.order_payment_failed_message
                    language.order_payment_failed_title,
                    "",
                    language.change_payment_method,
                    language.back_to_payment,
                    false,
                    false,
                    lastSaveStatus.isEmpty ? false : true,
                    AssetsPath.saidSmileFaceWhite);
              }
            }
          }
        } else {
          timer?.cancel();
          if (orderModel?.car != null) {
            Get.find<OrderController>().orderCurrentStatus = Helpers
                .getOrderStatusByDeliveryStatusDefault(context,
                "${orderModel?.status}", language)
                .toString();
            Get.offNamed(Routes.orderMapView,
                arguments: jsonEncode({
                  "from": "orderListing",
                  "order_id":
                  "${orderModel?.orderId}"
                }));
          }else {
            if (lastSaveStatus != status){
              onShowOrderPreparedDialog(
                  context,
                  language.order_confirm_message,
                  language.order_confirm_title,
                  "",
                  language.check_order,
                  language.skip,
                  false,
                  false,
                  lastSaveStatus.isEmpty ? false : true,
                  AssetsPath.happySmileIcon);
            }
          }
        }
        //cooking
        lastSaveStatus = status;
      } else if (status == "paymentWait" || status == "readyForDelivery") {
        timer?.cancel();
        if(orderModels.paymentStatus == "new") {
          var res = await orderRepository.payOrderPaymentOrder(
              cityCode: Get.find<HomeViewController>().selectedCityCode,
              orderId: deliveryOrderId,
              price: getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount());
          print("Routes---> ${Get.currentRoute}");
          if (res != null) {
            Map<String, dynamic> json = res;
            if (json['status'] == "error") {
              if(Get.currentRoute == Routes.foodDeliveryShoppingCartView){
                onShowOrderPreparedDialog(
                    context,
                    language.order_payment_failed_message,//language.order_payment_failed_message
                    language.order_payment_failed_title,
                    "",
                    language.change_payment_method,
                    language.back_to_payment,
                    false,
                    false,
                    lastSaveStatus.isEmpty ? false : true,
                    AssetsPath.saidSmileFaceWhite);
              }
            }
          }
        } else {

          if (orderModel?.car != null) {
            timer?.cancel();
            Get.find<OrderController>().orderCurrentStatus = Helpers
                .getOrderStatusByDeliveryStatusDefault(context,
                "${orderModel?.status}", language)
                .toString();
            Get.offNamed(Routes.orderMapView,
                arguments: jsonEncode({
                  "from": "orderListing",
                  "order_id":
                  "${orderModel?.orderId}"
                }));
          }else {
            if (lastSaveStatus != status && status == "paymentWait"){
              if(Get.currentRoute == Routes.foodDeliveryShoppingCartView){
                onShowOrderPreparedDialog(
                    context,
                    language.order_payment_failed_message,
                    language.order_payment_failed_title,
                    "",
                    language.change_payment_method,
                    language.back_to_payment,
                    false,
                    false,
                    lastSaveStatus.isEmpty ? false : true,
                    AssetsPath.saidSmileFaceWhite);
              }
            }
          }
        }
        //cooking
        lastSaveStatus = status;
      } else if (status == "cancelled") {
        timer?.cancel();
        databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
        status = "";
        lastSaveStatus = "";
        Navigator.pop(context);
      } else if (orderModel?.status == "completed") {
        timer?.cancel();
        databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
        status = "";
        lastSaveStatus = "";
        //open rating screen
        Get.find<OrderController>().orderCurrentStatus = 'Order delivered';
        Get.offNamed(Routes.orderCompletedScreen,
            arguments: jsonEncode({
              "from": "orderCompleted",
              "order_id": "${orderModel?.orderId}"
            }));
      }
      update();
    }
  }
  BuildContext? moContext;
  //order prepared  dialog
  onShowOrderPreparedDialog(
      BuildContext context,
      String _message,
      String _title,
      String subTitleMessage,
      String btnText,
      String cancelBtnText,
      bool isSingleBtn,
      bool isBothButton,
      bool isDialog,
      String iconPath) {
    moContext = context;
    print("Status -----> $status");
     print("Dialog Open -----> ${Get.isDialogOpen}");
    if (isPopUp) {
      Navigator.of(moContext!).pop();
    }
    isPopUp = true;
    var titleWidget = textMaker(context, _title, subTitleMessage, _message, "Gray");
    showDialog(
      context: moContext!,
      barrierDismissible: false,
      builder: (moContext) => WidgetDialog(
        titleWidget: titleWidget,
        icons: iconPath,
        okButtonText: btnText,
        closeButtonText: cancelBtnText,
        isSingleButton: isSingleBtn,
        isBothButtonHide: isBothButton,
        isCloseDialog: false,
        onPositivePressed: () async {
          isPopUp = false;
          if (status == "new") {
            timer?.cancel();
            // lastSaveStatus = "";
            Navigator.of(moContext).pop();
            cancelOrderCall(context);
          } else if (status == "canceledKitchen" || status == "notAccepted") {
            lastSaveStatus = "";
            timer?.cancel();
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            deliveryOrderId = "";
            orderModel = null;

            Navigator.of(moContext).pop();
            // Navigator.pop(moContext);
          } else if (status == "accepted" || status == "paymentWait") {
            Navigator.of(moContext).pop();
            var result = await Navigator.of(moContext).pushNamed(Routes.paymentView);
            if(status == "accepted" || status == "paymentWait" && orderModel1?.paymentStatus == "new" || orderModel1?.paymentStatus == "error"){
              try {
                print("----------------Change Payment method api call-------------");
                await orderRepository.addAgainPaymentOrder(
                    cityCode: Get.find<HomeViewController>().selectedCityCode,
                    orderId: deliveryOrderId,
                    paymentType: Get.find<PaymentController>().paymentType);
              } catch (e) {
              }
              var language = AppLocalizations.of(context)!;
              onShowOrderPreparedDialog(
                  context,
                  language.order_payment_made_message,
                  language.order_payment_made_title,
                  "",
                  "",
                  "",
                  true,
                  true,
                  false,
                  AssetsPath.paymentMethod);

              var res = await orderRepository.payOrderPaymentOrder(
                  cityCode: Get.find<HomeViewController>().selectedCityCode,
                  orderId: deliveryOrderId,
                  price: getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount());
              if (res != null) {
                Map<String, dynamic> json = res;
                if (json['status'] == "error") {
                  onShowOrderPreparedDialog(
                      context,
                      language.order_payment_failed_message,
                      language.order_payment_failed_title,
                      "",
                      language.change_payment_method,
                      language.back_to_payment,
                      false,
                      false,
                      true,
                      AssetsPath.saidSmileFaceWhite);
                }
              }
              updateOrderTimer(context);
            }
            //change payment method screen
          } else if (status == "paid" || status == "cooking" || status == "readyForDelivery") {
            timer?.cancel();
            lastSaveStatus = "";
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            orderModel = null;
            clearData();

            databaseService.saveToDisk(
                DatabaseKeys.isLoginTypeIn, AppConstants.FOOD_APP);
            //redirect order listing
            Navigator.of(moContext).pop();
            Navigator.of(moContext).pop();
            await Get.offNamed(Routes.orderDetailsView, arguments: jsonEncode({
              "from": "shoppingCart",
              "order_id": "${deliveryOrderId}"
            }));
            // Navigator.of(moContext).pushNamed(Routes.orderDetailsView, arguments: deliveryOrderId);
          } else {
            timer?.cancel();
            lastSaveStatus = "";
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            deliveryOrderId = "";
            orderModel = null;
            Navigator.of(moContext).pop();
          }
        },
        onNegativePressed: () async {
          isPopUp = false;
          if (status == "new") {
            timer?.cancel();
            lastSaveStatus = "";
            Navigator.of(moContext).pop();
            Navigator.of(moContext).pop();
          } else if (status == "canceledKitchen" || status == "notAccepted") {
            timer?.cancel();
            lastSaveStatus = "";
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            deliveryOrderId = "";
            orderModel = null;

            Navigator.of(moContext).pop();
            Navigator.of(moContext).pop();
          } else if (status == "accepted" || status == "paymentWait") {
            //back to payment click event
            timer?.cancel();
            // lastSaveStatus = "";

            //call cancel api
            Navigator.of(moContext).pop();
            cancelOrderCall(context);
          }  else if (status == "paid" || status == "cooking" || status == "readyForDelivery") {
            timer?.cancel();
            lastSaveStatus = "";
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            deliveryOrderId = "";
            orderModel = null;

            //init state
            //Navigator.of(moContext).pop();
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.foodHomeScreen, ModalRoute.withName('/'));
          } else {
            timer?.cancel();
            lastSaveStatus = "";
            databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
            status = "new";
            deliveryOrderId = "";
            orderModel = null;
            Navigator.of(moContext).pop();
            Navigator.of(moContext).pop();
          }
        },
      ),
    );
  }

  //cancel order
  cancelOrderCall(BuildContext context) async {
    Helpers.showCircularProgressDialog(context: context);
    Future.delayed(Duration(seconds: 2), () async {
      databaseService.saveToDisk(DatabaseKeys.deliveryOrder, "");
      status = "new";
      lastSaveStatus = "";
      orderModel = null;

       await orderRepository.cancelOrder(
          cityCode: Get.find<HomeViewController>().selectedCityCode,
          orderId: deliveryOrderId, deliverySta: "canceledClient");
      Navigator.pop(context);
      //show info dialog of cancel order
       showCancelInfoDialog(context);
    });
  }

  //show cancel order info dialog
  showCancelInfoDialog(BuildContext context) {
    isPopUp = true;
    BuildContext moContext;
    moContext = context;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;

    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: language.order_cancel_message,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
    showDialog(
        context: moContext,
        builder: (moContext) => WidgetDialog(
              titleWidget: titleWidget,
              icons: AssetsPath.orderCancelCartIcon,
              okButtonText: language.okay,
              closeButtonText: "",
              isSingleButton: true,
              isBothButtonHide: false,
              isCloseDialog: false,
              onPositivePressed: () {
                isPopUp = false;
                //close screen
                Navigator.of(moContext).pop();
              },
              onNegativePressed: () {
                debugPrint("OnPressed1!!");
                isPopUp = false;
                Navigator.of(moContext).pop();
              },
            ));
  }

  //search of local
  onSearchTextChanged(String text) async {
    print("onSearchTextChanged");
    searchProductList?.clear();
    if (text.isEmpty) {
      print("Text Is Empty");
      isNoDataFound = false;
      searchProductList;
      update();
      return;
    }
    productList?.forEach((productData) {
      if (productData.name.toString().contains(text) || productData.name.toString().toLowerCase().contains(text)){
        searchProductList?.add(productData);
        isNoDataFound = true;
      }
    });
    // print("onSearchTextChanged1 ${searchListData.length}");
    if(searchProductList?.isEmpty == true){
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

/*
  {orderId: 8240811, comment: , cancelledBy: null, createdAt: 2022-08-26T12:55:10Z,
   arrivesAt: null, status: searching, countOfPersons: 0, establishmentId: 56,
    paymentStatus: new, commentForEstablishment: ,
     summary: {distanceTravelled: 0, waitingTime: 0, tripCost: 0}, isDelivery: true,
      deliveryStatus: canceledClient, isSuccessfulOrder: true, rate: {optionId: 988,
      name: Тариф для доставки (не фикс прайс), code: delivery, numberOfSeats: null, prices:
       {start: 0, moving: 1260, waiting: 0, minimum: 100, multiplier: 1}}}
  * */
}
