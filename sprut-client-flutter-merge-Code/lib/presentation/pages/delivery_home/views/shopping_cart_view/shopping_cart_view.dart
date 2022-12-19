import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';
import 'package:sprut/presentation/pages/payment_screen/controllers/payment_controller.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/routes/routes.dart';

import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../resources/services/database/database_keys.dart';
import '../../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../../widgets/common_dialog/common_dialog.dart';
import '../../../../widgets/custom_dialog/widget_dialog.dart';
import '../../../../widgets/primary_container/primary_container.dart';
import '../../../no_internet/no_internet.dart';
import '../../../payment_screen/views/payment_add_view.dart';
import '../establishment_details_view/product_item_ui.dart';

class ShoppingCartView extends StatefulWidget {
  @override
  State<ShoppingCartView> createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EstablishmentDetailsController controller =
      Get.put(EstablishmentDetailsController(), permanent: true);

  PaymentController paymentController =
      Get.put(PaymentController(), permanent: true);

  final homeController = Get.put(HomeViewController(), permanent: true);

  @override
  void initState() {
    // paymentController.getProfile();
    // paymentController.getCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<EstablishmentDetailsController>(
        init: EstablishmentDetailsController(),
        initState: (_) {
          // controller.isConfirmButton = true;
          if (controller.databaseService.getFromDisk(DatabaseKeys.deliveryOrder) !=null &&
              controller.databaseService.getFromDisk(DatabaseKeys.deliveryOrder) != "") {
            debugPrint("reCallOrderStatusFetch IF");
            controller.reCallOrderStatusFetch(context);
          } else {
            debugPrint("reCallOrderStatusFetch ELSE");
            controller.isLoaderRunning(false);
          }
          Future.delayed(Duration.zero, () {
            paymentController.getProfile();
            paymentController.getCards();
            paymentController.update();
          });
        },
        builder: (context) {
          return BlocConsumer<ConnectedBloc, ConnectedState>(
            listener: (context, state) {
              if (state is ConnectedSucessState) {
                // debugPrint("ConnectedSucessState::: call api");
                if (controller.deliveryOrderId.isNotEmpty) {
                  if (controller.lastSaveStatus.isEmpty) {
                    controller.updateOrder(context);
                  }
                }
                paymentController.getProfile();
                paymentController.getCards();
                paymentController.update();
              }
              if (state is ConnectedFailureState) {
                // print("Pop Up close1 ${controller.isPopUp}");
                if (controller.isPopUp) {
                  if (controller.deliveryOrderId.isNotEmpty) {
                    controller.lastSaveStatus = "";
                    controller.isPopUp = false;
                    Navigator.pop(context);
                  }
                }
                // print("Pop Up isDeleteDialogShow ${controller.isDeleteDialogShow}");
                if(controller.isDeleteDialogShow){
                  Navigator.pop(context);
                }
              }
            },
            builder: (context, connectionState) {
              return connectionState is ConnectedFailureState
                  ? NoInternetScreen(onPressed: () async {
                      paymentController.getProfile();
                      paymentController.getCards();
                      print("Pop Up isDeleteDialogShow ${connectionState}");
                    })
                  : WillPopScope(
                      onWillPop: () async => false,
                      child: SafeArea(
                        child: Scaffold(
                          resizeToAvoidBottomInset: true,
                          appBar: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PrimaryContainer(
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: colorScheme.background,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          key: _scaffoldKey,
                          body: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Align(
                                        child: Text(
                                          language.order_payment,
                                          style: textTheme.bodyText1!.copyWith(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.start,
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      SizedBox(height: 20),
                                      _buildHeader(),
                                      SizedBox(height: 20),
                                      _buildProductItems(language, appLocale),
                                      SizedBox(height: 10),
                                      Align(
                                        child: Text(
                                          language.number_appliances,
                                          style: textTheme.bodyText1!.copyWith(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      SizedBox(height: 20),
                                      TextField(
                                        style: TextStyle(
                                            color: Helpers.primaryTextColor()),
                                        controller: controller
                                            .numberOfApplianceController,
                                        keyboardType: TextInputType.number,
                                        cursorColor: colorScheme.primary,
                                        decoration: InputDecoration(
                                          hintText: '',
                                          hintStyle: TextStyle(
                                            color: Helpers.primaryTextColor(),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color: colorScheme.primary,
                                                width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                                color:
                                                    Helpers.primaryTextColor(),
                                                width: 1),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      _buildDeliveryTime(),
                                      SizedBox(height: 20),
                                      _buildNote(),
                                      SizedBox(height: 20),
                                      _buildPaymentMethod(),
                                    ],
                                  ),
                                ),
                                _buildFooter(),
                              ],
                            ),
                          ),
                          backgroundColor:
                              Helpers.primaryBackgroundColor(colorScheme),
                        ),
                      ),
                    );
            },
          );
        });
  }

  Widget _buildProductItems(AppLocalizations language,Locale appLocale) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.cartItemList?.length ?? 0,
      itemBuilder: (context, index) {
        // print("Image Url ----> ${controller.cartItemList![index].imgUrl}");

        ProductItems productItems = ProductItems(
          id: controller.cartItemList![index].id,
          name: controller.cartItemList![index].name,
          nameEn: controller.cartItemList![index].nameEn,
          nameUk: controller.cartItemList![index].nameUk,
          nameRu: controller.cartItemList![index].nameRu,
          shortDescriptionEn: controller.cartItemList![index].shortDescriptionEn,
          shortDescriptionUk: controller.cartItemList![index].shortDescriptionUk,
          shortDescriptionRu: controller.cartItemList![index].shortDescriptionRu,
          detailedDescriptionEn: controller.cartItemList![index].detailedDescriptionEn,
          detailedDescriptionUk: controller.cartItemList![index].detailedDescriptionUk,
          detailedDescriptionRu: controller.cartItemList![index].detailedDescriptionRu,
          weight: controller.cartItemList![index].weight,
          price: controller.cartItemList![index].price,
          imgUrl: controller.cartItemList![index].imgUrl,
          shortDescription: controller.cartItemList![index].shortDescription,
          detailedDescription: controller.cartItemList![index].detailedDescription,
          status: controller.cartItemList![index].status,
          removed: controller.cartItemList![index].removed,
          createdAt: controller.cartItemList![index].createdAt,
          updatedAt: controller.cartItemList![index].updatedAt,
          brandId: controller.cartItemList![index].brandId,
          sectionId: controller.cartItemList![index].sectionId,
          quantity: controller.cartItemList![index].quantity,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: GestureDetector(
            child: ProductItemUi(productItems, true),
            onTap: () async {
              // controller.selectedItem = controller.cartItemList![index];
              // controller.tempItems = controller.cartItemList![index];
              // Navigator.pushNamed(
              //     context, Routes.foodDeliveryProductItemDetailsView,
              //     arguments: controller.cartItemList![index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Helpers.secondaryBackground(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.primary.withOpacity(0.22)),
              child: SvgPicture.asset(
                AssetsPath.cartBox,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ('${controller.storeDetailsData.name}' ==
                        language.all)
                        ? '${language.order_in} ${language.all}'
                        : (appLocale == Locale('en'))
                        ? '${language.order_in} ${controller.storeDetailsData.nameEn}'
                        : (appLocale == Locale('uk'))
                        ? '${language.order_in} ${controller.storeDetailsData.nameUk}'
                        : (appLocale == Locale('ru'))
                        ? '${language.order_in} ${controller.storeDetailsData.nameRu}'
                        : '${language.order_in} ${controller.storeDetailsData.name}',
                    // '${language.order_in} ${controller.storeDetailsData.name}',
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${language.order_date} ${DateFormat('MMMM dd, yyyy', Helpers.getLac(context)).format(DateTime.now())}',
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 12,
                        color: Helpers.subtitleTextColor(),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${language.selected_item} ${controller.getTotalCartItem()}',
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                        color: Helpers.secondaryTextColor(),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    var language = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GetBuilder<EstablishmentDetailsController>(
        initState: (_) {},
        builder: (cc) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Helpers.secondaryBackground(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text(
                                language.products,
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Helpers.subtitleTextColor(),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getTotalCartItem()} ${language.items}",
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Helpers.primaryTextColor(),
                                ),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text(
                                language.prices,
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Helpers.subtitleTextColor(),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemTotalAmount()} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Helpers.primaryTextColor(),
                                ),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if ((controller.storeDetailsData.cashbackPercent ?? 0) >
                            0) ...[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Container(
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                      AssetsPath.icAlertFull,
                                    )),
                                SizedBox(
                                  width: 4.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //open cashback alert dialog
                                    showDialog(
                                        context: context,
                                        builder: (context) => CashBackDialog(
                                              message: "",
                                            ));
                                  },
                                  child: Text(
                                    "${language.cashback} ${controller.storeDetailsData.cashbackPercent}%:",
                                    style: textTheme.bodySmall!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: colorScheme.primary),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "${controller.getCashback()} ${language.currency_symbol}",
                                  style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Helpers.primaryTextColor(),
                                  ),
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          )
                        ],
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text(
                                language.shipping,
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Helpers.subtitleTextColor(),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.storeDetailsData.calculatedPrice} ${Helpers.priceSymbol(context)}",
                                style: textTheme.bodySmall!.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Helpers.primaryTextColor(),
                                ),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        if (double.parse(controller.freeShippingAmount()) > 0) ...[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: [
                                Text(
                                  language.free_shipping,
                                  style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Helpers.subtitleTextColor(),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Spacer(),
                                Text(
                                  "${controller.freeShippingAmount()} ${Helpers.priceSymbol(context)}",
                                  style: textTheme.bodySmall!.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Helpers.primaryTextColor()),
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          ),
                        ],
                        Divider(color: Helpers.primaryTextColor()),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text(
                                language.total,
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Helpers.primaryTextColor()),
                                textAlign: TextAlign.start,
                              ),
                              Spacer(),
                              Text(
                                "${controller.getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount()} ${language.currency_symbol}",
                                style: textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Helpers.primaryTextColor(),
                                ),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        if(cc.isLoaderRunning.value == true)...[
                          Center(
                            child: SizedBox(
                                height: 75,
                                width: 75,
                                child:
                                Lottie.asset('assets/images/loading1.json')),
                          )
                        ]else...[
                          GestureDetector(
                            onTap: () async {
                              print("ON Press...");
                              //check first payment method
                              if (paymentController.paymentType.isNotEmpty) {
                                if (paymentController.paymentType == "cash") {
                                  //show alert dialog of choose payment method
                                  onShowPaymentMethodDialog(context);
                                } else {
                                  //payment method selected
                                  ///check condition of payment bal and total amount
                                  if (paymentController.isBalance) {
                                    if (double.parse(controller
                                        .getCartItemFinalWithDiscountAndWithoutDiscountTotalAmount()) >
                                        double.parse(paymentController.balance)) {
                                      //open low bal alert dialogs
                                      onShowWalletBalanceLowDialog(context);
                                      return;
                                    }
                                  }
                                  //check address and cart view
                                  if (controller.cartItemList?.isNotEmpty == true &&
                                      controller.databaseService
                                          .getFromDisk(
                                          DatabaseKeys.saveDeliverAddress)
                                          .toString() !=
                                          "null" &&
                                      controller.databaseService
                                          .getFromDisk(
                                          DatabaseKeys.saveDeliverAddress)
                                          .toString()
                                          .isNotEmpty ||
                                      controller.databaseService
                                          .getFromDisk(
                                          DatabaseKeys.saveCurrentAddress)
                                          .toString() !=
                                          "null" &&
                                          controller.databaseService
                                              .getFromDisk(
                                              DatabaseKeys.saveCurrentAddress)
                                              .toString()
                                              .isNotEmpty) {
                                    if (!controller.isClosedStore(
                                        controller.storeDetailsData.openTime
                                            .toString(),
                                        controller.storeDetailsData.closeTime
                                            .toString())) {
                                      //open Alert Dialog
                                      onShowCloseStoreDialog(context,
                                          language.establishment_close_message, true);
                                    } else {
                                      //check alarm status
                                      //call timer check api
                                      var storeStatus =
                                      await controller.storeStatusChecked(context);
                                      if (storeStatus) {
                                        onShowCloseStoreDialog(
                                            context,
                                            language
                                                .establishment_close_air_alarm_message,
                                            false);
                                      } else {
                                        //call order api
                                        controller.makeOrder(_scaffoldKey.currentContext!);
                                      }
                                    }
                                  } else {
                                    Helpers.showSnackBar(
                                        context, "Please add delivery address");
                                  }
                                }
                              } else {
                                //show alert dialog of choose payment method
                                onShowPaymentMethodDialog(context);
                              }

                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  language.confirm_order,
                                  style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Helpers.primaryTextColor(),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  onShowCloseStoreDialog(
      BuildContext context, String message, bool workingHours) async {
    controller.isPopUp = true;

    BuildContext moContext;
    moContext = context;

    var textTheme = Theme.of(moContext).textTheme;
    var language = AppLocalizations.of(moContext)!;

    var titleWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: message,
            style: textTheme.bodyText2!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Helpers.primaryTextColor()),
          ),
          if (workingHours) ...[
            TextSpan(
              text:
                  "\n${language.working_hours} ${controller.storeDetailsData.openTime} - ${controller.storeDetailsData.closeTime}",
              style: textTheme.bodyText2!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Helpers.primaryTextColor()),
            ),
          ]
        ],
      ),
      textAlign: TextAlign.center,
    );
    showDialog(
      context: context,
      builder: (moContext) => WidgetDialog(
        titleWidget: titleWidget,
        icons: AssetsPath.orderCancelCartIcon,
        okButtonText: language.okay,
        closeButtonText: "",
        isSingleButton: true,
        isBothButtonHide: false,
        isCloseDialog: false,
        onPositivePressed: () {
          controller.isPopUp = false;
          //close screen
          Navigator.of(moContext).pop();
        },
        onNegativePressed: () {
          controller.isPopUp = false;
          Navigator.of(moContext).pop();
        },
      ),
    );
  }

  //Payment method choose alert dialog
  onShowPaymentMethodDialog(BuildContext context) {
    controller.isPopUp = true;
    var language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => CommonDialog(
        message: "",
        title: language.empty_payment_method_selection_message,
        icons: AssetsPath.paymentMethod,
        okButtonText: language.select,
        closeButtonText: "",
        isSingleButton: false,
        onPositivePressed: () {
          controller.isPopUp = false;
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(Routes.paymentView);
        },
        onNegativePressed: () {
          controller.isPopUp = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  //Low bal alert dialog
  onShowWalletBalanceLowDialog(BuildContext context) {
    controller.isPopUp = true;
    var language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => CommonDialog(
        message: "",
        title: language.balance_amount_alert_message,
        icons: AssetsPath.paymentMethod,
        okButtonText: language.top_up,
        closeButtonText: "",
        isSingleButton: false,
        onPositivePressed: () {
          controller.isPopUp = false;
          Navigator.of(context).pop();
          showCupertinoModalBottomSheet(
            expand: false,
            enableDrag: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            context: context,
            builder: (context) => PaymentAddView(),
          );
        },
        onNegativePressed: () {
          controller.isPopUp = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  //order prepared  dialog
  onShowOrderPreparedDialog(BuildContext context) {
    controller.isPopUp = true;
    var language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommonDialog(
        message: language.order_processing_sub_message,
        title: language.order_processing_title_message,
        icons: AssetsPath.processingTimerIcon,
        okButtonText: language.cancel,
        closeButtonText: "",
        isSingleButton: false,
        onPositivePressed: () {
          controller.isPopUp = false;
          controller.update();
          Navigator.of(context).pop();
        },
        onNegativePressed: () {
          controller.isPopUp = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildDeliveryTime() {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Helpers.secondaryBackground(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  AssetsPath.addressClock,
                ),
                Container(
                  height: 45,
                  child: SvgPicture.asset(
                    AssetsPath.threeDots,
                  ),
                ),
                SvgPicture.asset(
                  AssetsPath.addressPin,
                ),
              ],
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.delivery_times,
                    style: textTheme.bodySmall!.copyWith(
                        fontSize: 14,
                        color: Helpers.subtitleTextColor(),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${controller.storeDetailsData.deliveryTime?.roundToDouble().toPrecision(0).round() ?? 0} ${language.minutes}",
                    style: textTheme.bodyText1!.copyWith(
                        fontSize: 15,
                        color: Helpers.primaryTextColor(),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(Routes.foodDeliveryAddressView);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                language.your_address,
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                    color: Helpers.subtitleTextColor(),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                homeController.displayDefaultAddress(language),
                                style: textTheme.bodyText1!.copyWith(
                                    fontSize: 15,
                                    color: Helpers.primaryTextColor(),
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        // Icon(
                        //   Icons.arrow_forward_ios,
                        //   color: colorScheme.primary,
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote() {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Helpers.secondaryBackground(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language.note_to_restaurant,
              style: textTheme.bodyText1!.copyWith(
                fontSize: 15,
                color: Helpers.primaryTextColor(),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.noteTextController,
              style: textTheme.bodyText1!.copyWith(
                fontSize: 12,
                color: Helpers.primaryTextColor(),
                fontWeight: FontWeight.w400,
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              cursorColor: Helpers.primaryTextColor(),
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: language.placeholder_note_of_restaurant,
                hintStyle: TextStyle(
                  color: Helpers.subtitleTextColor(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Helpers.primaryTextColor(), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      BorderSide(color: Helpers.primaryTextColor(), width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<PaymentController>(
        initState: (_) {},
        builder: (_) {
          return Column(
            children: [
              Align(
                child: Text(
                  language.payment_methods,
                  style: textTheme.bodyText1!.copyWith(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).pushNamed(Routes.paymentView);
                  paymentController.getCards();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Helpers.secondaryBackground(),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      if (paymentController.paymentType.isNotEmpty) ...[
                        if (paymentController.paymentType != "cash") ...[
                          Obx(() => SvgPicture.asset(
                                paymentController.paymentTypeIcons,
                              )),
                          SizedBox(width: 20),
                        ]
                      ],
                      Obx(
                        () => Text(
                          paymentController.paymentType.isNotEmpty
                              ? paymentController.paymentType.capitalize ==
                                      "Cash"
                                  ? language.choose_payment_method
                                  : "${paymentController.paymentType.capitalize}" ==
                                          "Card"
                                      ? "${language.card} ${paymentController.cardNumber}"
                                      : "${language.balance}"
                              : language.choose_payment_method,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Helpers.primaryTextColor(),
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Obx(() {
                        if (paymentController.isBalance) {
                          return Expanded(
                            child: Text(
                              "(${paymentController.balance} ${Helpers.priceSymbol(context)})",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontFamily: AppConstants.fontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp),
                            ),
                          );
                        }
                        return SizedBox();
                      }),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
