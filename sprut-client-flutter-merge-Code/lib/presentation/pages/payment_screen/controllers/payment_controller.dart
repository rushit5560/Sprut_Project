import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/data/models/tariff_screen_model/profile_model.dart';
import 'package:sprut/data/models/tariff_screen_model/recharge_model.dart';

import '../../../../data/models/tariff_screen_model/card_model.dart';
import '../../../../data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import '../../../../resources/configs/helpers/helpers.dart';
import '../views/payment_recharge_view.dart';

class PaymentController extends GetxController {
  TariffScreenRepository tariffScreenRepository = TariffScreenRepository();
  List<Cards> cards = [];
  Profile? _profile;
  Cards? _card;

  Cards get card => _card!;
  set card(value) => _card = value;

  RxString _balance = "".obs;
  String get balance => _balance.value;
  set balance(value) => _balance.value = value;

  // RxInt _balance = 0.obs;
  // int get balance => _balance.value;
  // set balance(value) => _balance.value = value;

  //Food Delivery
  bool get isBalance => _paymentType.value.toLowerCase() == "balance";

  RxString _paymentTypeIcons = "".obs;
  String get paymentTypeIcons => _paymentTypeIcons.value;
  set paymentTypeIcons(value) => _paymentTypeIcons.value = value;

  RxString _cardNumber = "".obs;
  String get cardNumber => _cardNumber.value;
  set cardNumber(value) => _cardNumber.value = value;
  //End

  RxString _paymentType = "".obs;
  String get paymentType => _paymentType.value;
  set paymentType(value) => _paymentType.value = value;

  RxList _service = [].obs;
  List get service => _service;
  set service(value) => _service.add(value);
  set serviceRemove(value) => _service.remove(value);

  RxBool _edit = false.obs;
  bool get edit => _edit.value;
  set edit(value) => _edit.value = value;

  RxString _paymentAdd = "50".obs;
  String get paymentAdd => _paymentAdd.value;
  set paymentAdd(value) => _paymentAdd.value = value;

  RxString _webUrl = "".obs;
  String get webUrl => _webUrl.value;
  set webUrl(value) => _webUrl.value = value;

  RxBool _isPaymentChange = false.obs;
  bool get paymentChange => _isPaymentChange.value;
  set paymentChange(value) => _isPaymentChange.value = value;


  TextEditingController amountController =
      new TextEditingController(text: "15");
  FocusNode amountFocusNode = FocusNode();

  String balanceTitle = "balance";
  String cashTitle = "cash";
  String cardTitle = "card";

  getProfile() async {
    _profile = await tariffScreenRepository.fetchProfile();
    if (!paymentChange) {
      paymentType = _profile?.paymentType;

      if (paymentType.isEmpty) {
        paymentType = cashTitle;
      }
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
    cardNumber = card.cardMask.toString();
    update();
    getPaymentAsset();
  }

  updateAmountController(String type) {
    String amountText = amountController.text.trim();
    var amountVal;
    if (amountText.isNotEmpty) {
      amountVal = int.parse(amountText);
    } else {
      amountVal = 0;
    }

    if (type == "add") {
      amountVal += 5;
    } else {
      if (amountVal > 15) {
        amountVal -= 5;
      }
    }

    amountController.text = amountVal.toString();
    amountController.selection = TextSelection(
      baseOffset: amountController.text.length,
      extentOffset: amountController.text.length,
    );
  }

  updateBalance(BuildContext context) async {
    if (paymentAdd == "other") {
      String amountText = amountController.text.trim();

      if (amountText.isNotEmpty) {
        if (int.parse(amountText) < 15) {
          Helpers.showSnackBar(
              context, AppLocalizations.of(context)!.min_add_amount);
          return;
        }
      } else {
        Helpers.showSnackBar(context, "Please enter amount");
        return;
      }
    }

    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);
    RechargeModel rechargeModel = await tariffScreenRepository.rechargeBalance(
        paymentAdd == "other" ? amountController.text.trim() : paymentAdd);

    Navigator.pop(context);

    webUrl = rechargeModel.liqpay.url;

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => PaymentRechargeView(),
      ),
    )
        .then((value) {
      if (value != null) {
        if (value["status"]) {
          Helpers.showCircularProgressDialog(context: context);
          try {
            getProfile();
            getCards();
          } catch (e) {}
          Navigator.pop(context);
        }
      }
    });
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
        builder: (context) => PaymentRechargeView(),
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

  deleteCard(BuildContext context, String cardId) async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    Helpers.showCircularProgressDialog(context: context);
    try {
      dynamic data = await tariffScreenRepository.deleteCard(cardId);
    } catch (e) {}

    Navigator.pop(context);

    Helpers.showCircularProgressDialog(context: context);
    try {
      getCards();
    } catch (e) {}
    Navigator.pop(context);
  }

  updatePaymentType(BuildContext context, String titleType,
      bool isPaymentChange, Cards changeCard) async {
    bool isConnected = await Helpers.checkInternetConnectivity();

    if (!isConnected) {
      Helpers.internetDialog(context);
      return;
    }

    // print("paymentType :: $paymentType");
    // print("titleType :: $titleType");
    if (paymentType != titleType) {
      paymentType = titleType;
      if (paymentType == "card") {
        card = changeCard;
      } else {
        paymentChange = isPaymentChange;
      }

      Helpers.showCircularProgressDialog(context: context);
      // print("call profile api");
      Profile profile =
          await tariffScreenRepository.updatedProfile(paymentType);
    } else {
      paymentType = titleType;
      if (paymentType == "card") {
        card = changeCard;
      } else {
        paymentChange = isPaymentChange;
      }

      Helpers.showCircularProgressDialog(context: context);

      Profile profile =
      await tariffScreenRepository.updatedProfile(paymentType);
    }

    if (paymentType == "card" && !card.cardDefault!) {
      card = await tariffScreenRepository.defaultCard("${card.id!}");

      for (int i = 0; i < cards.length; i++) {
        if (card.id == cards[i].id) {
          cards[i] = cards[i].copyWith(cardDefault: true);
        } else {
          cards[i] = cards[i].copyWith(cardDefault: false);
        }
      }
    }

    update();
    // update();
    getPaymentAsset(); //Food delivery

    Navigator.pop(context);
  }

  //Food delivery
  getPaymentAsset() {
    debugPrint("Type is:: $paymentType");
    // if (paymentController.paymentType == "cash") {
    //   return "assets/payments/cash.svg";
    // }
    if(paymentType == "card"){
      paymentTypeIcons =  "assets/payments/card.svg";
    }

    if (isBalance) {
      paymentTypeIcons = "assets/payments/balance.svg";
    }
    update();
  }
  //End

  @override
  void onInit() async {
    super.onInit();

    getProfile();
    getCards();
    super.onInit();
  }

}
