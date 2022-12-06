import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';
import 'package:sprut/presentation/pages/delivery_home/views/establishment_details_view/item_details_ui.dart';
import 'package:sprut/presentation/widgets/cart_leave_dialog/cart_leave_dialog.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';
import 'package:sprut/resources/configs/routes/routes.dart';

import '../../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../resources/services/database/database_keys.dart';
import '../../../home_screen/controllers/home_controller.dart';
import '../../../no_internet/no_internet.dart';

class EstablishmentDetailsScreenView extends StatefulWidget {
  @override
  State<EstablishmentDetailsScreenView> createState() =>
      _EstablishmentDetailsScreenViewState();
}

class _EstablishmentDetailsScreenViewState
    extends State<EstablishmentDetailsScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EstablishmentDetailsController _establishmentDetailsController =
      Get.put(EstablishmentDetailsController(), permanent: true);

  final HomeViewController _homeViewController =
      Get.put(HomeViewController(), permanent: true);

  @override
  void initState() {
    _homeViewController.checkLocationIfNeeded();
    Future.delayed(Duration.zero, () {
      setState(() {
        _establishmentDetailsController.clearData();
        // _establishmentDetailsController.fetchingSaveAddress();
        _establishmentDetailsController.storeDetailsData =
            ModalRoute.of(context)!.settings.arguments as Establishments;
        // debugPrint("Store ID:: " +
        //     _establishmentDetailsController.storeDetailsData.brandId
        //         .toString());
        // debugPrint("Image URL:: " +
        //     _establishmentDetailsController.storeDetailsData.imgUrl.toString());
        _establishmentDetailsController.fetchingItemList(
            context,
            _establishmentDetailsController.storeDetailsData.brandId
                .toString());
        _establishmentDetailsController.update();
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return GetBuilder<EstablishmentDetailsController>(
        init: EstablishmentDetailsController(),
        initState: (_) {},
        builder: (context) {
          return BlocConsumer<ConnectedBloc, ConnectedState>(
            listener: (context, state) {
              if (state is ConnectedFailureState) {
                // showDialog(
                //     context: context,
                //     builder: (context) => MyCustomDialog(
                //           message: language.networkError,
                //         ));
              }

              if (state is ConnectedInitialState) {
                debugPrint("ConnectedInitialState:::");
              }

              if(state is ConnectedSucessState){
                print("--------------Establishment details ConnectedSuccessState--------------");
                // Helpers.showCircularProgressDialog(context: context);
                // _establishmentDetailsController.fetchingItemList(
                //     context,
                //     _establishmentDetailsController.storeDetailsData.brandId
                //         .toString());
              }
            },
            builder: (context, connectionState) {
              if (connectionState is ConnectedFailureState) {
                if(_establishmentDetailsController.isDialogShow){
                  Get.back();
                }
                return NoInternetScreen(onPressed: () async {});
              }

              return BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, authState) {
                if (authState is FetchingFoodEstablishmentProductListProgress) {
                  debugPrint("Loading Progress!");
                  // Helpers.showCircularProgressDialog(context: context);
                }

                if (authState is FetchingFoodEstablishmentProductListSucceed) {
                  // Navigator.of(context).pop();
                  _establishmentDetailsController.isShowData = true;
                  if (authState.allProductList?.isNotEmpty == true) {
                    _establishmentDetailsController.productList =
                        authState.allProductList;
                    //fileter data
                    _establishmentDetailsController.filterSection();
                    _establishmentDetailsController.update();
                  }
                  debugPrint("FetchingFoodEstablishmentProductListSucceed!");
                }

                if (authState is FetchingFoodEstablishmentProductListFailed) {
                  // Navigator.of(context).pop();
                  //check is session expired
                  if (authState.message.toString() == "Session expired") {
                    Helpers.clearUser();

                    dynamic workAddress = _homeViewController.databaseService
                        .getFromDisk(DatabaseKeys.userWorkAddress);
                    dynamic homeAddress = _homeViewController.databaseService
                        .getFromDisk(DatabaseKeys.userHomeAddress);
                    _homeViewController.cacheAddress["homeAddress"] =
                        homeAddress;
                    _homeViewController.cacheAddress["workAddress"] =
                        workAddress;
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.foodHomeScreen, ModalRoute.withName('/'));
                  }
                }
              }, builder: (context, authState) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: GetBuilder<HomeViewController>(
                      builder: (_) => Scaffold(
                          resizeToAvoidBottomInset: false,
                          key: _scaffoldKey,
                          body: GetBuilder<EstablishmentDetailsController>(
                              builder: (_) =>
                                  Stack(alignment: Alignment.center, children: [
                                    Positioned(
                                        child: _establishmentDetailsController
                                                .isShowData
                                            ? StoreItemDetailsUi()
                                            : SizedBox()),
                                    Positioned(
                                      top: 10,
                                      left: 6,
                                      child: SafeArea(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_establishmentDetailsController
                                                    .cartItemList?.isNotEmpty ==
                                                true) {
                                              _establishmentDetailsController.isDialogShow = true;
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CartLeaveDialog(
                                                        message: language
                                                            .leaveEstablishmentMessage,
                                                        title: language
                                                            .leaveEstablishmentTitle,
                                                        icons: AssetsPath
                                                            .leaveCartIcon,
                                                        okButtonText:
                                                            language.no_stay,
                                                        closeButtonText:
                                                            language.yes_close,
                                                        isSingleButton: true,
                                                        onPositivePressed: () {
                                                          _establishmentDetailsController.isDialogShow = false;
                                                          debugPrint(
                                                              "OnPressed!!");
                                                          //close screen
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        onNegativePressed: () {
                                                          _establishmentDetailsController.isDialogShow = false;
                                                          debugPrint(
                                                              "OnPressed1!!");
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ));
                                            } else {
                                              _establishmentDetailsController
                                                  .clearData();
                                              //close screen
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                              size: 7.w,
                                            ),
                                            height: 5.h,
                                            width: 5.h,
                                            decoration: BoxDecoration(
                                                color: colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_establishmentDetailsController
                                            .cartItemList?.isNotEmpty ==
                                        true) ...[
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: SafeArea(
                                            child: GestureDetector(
                                              onTap: () async {
                                                Navigator.of(context).pushNamed(
                                                    Routes
                                                        .foodDeliveryShoppingCartView);
                                                // _onViewCart();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    bottom: 16.0),
                                                height: 56.0,
                                                padding: EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 12.0,
                                                    bottom: 8.0,
                                                    top: 8.0),
                                                decoration: BoxDecoration(
                                                    color: colorScheme.primary,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8.0),
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${_establishmentDetailsController.getTotalCartItem()}",
                                                            style: textTheme.bodyText1!.copyWith(
                                                                fontSize: 11.sp,
                                                                color: AppThemes
                                                                    .colorWhite,
                                                                fontFamily:
                                                                    AppConstants
                                                                        .fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Text(
                                                            " ${language.items}",
                                                            style: textTheme.bodyText1!.copyWith(
                                                                fontSize: 11.sp,
                                                                color: AppThemes
                                                                    .colorWhite
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontFamily:
                                                                    AppConstants
                                                                        .fontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          language.view_cart,
                                                          style: textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.sp,
                                                                  color: AppThemes
                                                                      .colorWhite,
                                                                  fontFamily:
                                                                      AppConstants
                                                                          .fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                    ),
                                                    SizedBox(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          color: AppThemes
                                                              .colorWhite
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                8.0),
                                                          )),
                                                      alignment:
                                                          Alignment.center,
                                                      constraints:
                                                          BoxConstraints(
                                                              minWidth: 75),
                                                      child: Text(
                                                          '${_establishmentDetailsController.getCartItemTotalAmount()} ${language.currency_symbol}',
                                                          style: textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize:
                                                                      11.sp,
                                                                  color: AppThemes
                                                                      .colorWhite,
                                                                  fontFamily:
                                                                      AppConstants
                                                                          .fontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                    if (authState
                                    is FetchingFoodEstablishmentProductListProgress) ...[
                                      Center(
                                        child: SizedBox(
                                            height: 150,
                                            width: 150,
                                            child:
                                            Lottie.asset('assets/images/loading1.json')),
                                      )
                                    ],
                                  ])),
                          backgroundColor: Colors.black)),
                );
              });
            },
          );
        });
  }
}
