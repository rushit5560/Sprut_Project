import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';
import 'package:sprut/presentation/pages/delivery_home/views/establishment_details_view/product_details/descripetion_ui.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

import '../../../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../../../resources/app_constants/app_constants.dart';
import '../../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../widgets/cash_back_dialog/cash_back_dialog.dart';
import '../../../../home_screen/controllers/home_controller.dart';
import '../../../../no_internet/no_internet.dart';

class ProductItemDetailsScreenView extends StatefulWidget {
  @override
  State<ProductItemDetailsScreenView> createState() =>
      _ProductItemDetailsScreenViewState();
}

class _ProductItemDetailsScreenViewState extends State<ProductItemDetailsScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKeys = GlobalKey<ScaffoldState>();

  EstablishmentDetailsController _controller = Get.put(EstablishmentDetailsController(), permanent: true);

  ProductItems productData = ProductItems();
  int? pastQty = 0;

  @override
  void initState() {
    print("Cart Item :: " + _controller.cartItemList.toString());
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      setState(() {
        productData =
            ModalRoute.of(context)!.settings.arguments as ProductItems;
        pastQty = productData.quantity;
        productData.quantity = 1;

        Future.delayed(Duration(microseconds: 500), () {
          _controller.isShowItemDetails = true;
          _controller.update();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar1();

    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<EstablishmentDetailsController>(
          init: EstablishmentDetailsController(),
          initState: (_) {
            _controller.isShowItemDetails = false;
          },
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

                if (state is ConnectedSucessState) {
                  _controller.isShowItemDetails = true;
                  _controller.update();
                }
              },
              builder: (context, connectionState) {
                if (connectionState is ConnectedFailureState) {
                  return NoInternetScreen(onPressed: () async {
                    _controller.isShowItemDetails = true;
                    _controller.update();
                  });
                }

                return BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, authState) {},
                    builder: (context, authState) {
                      return SafeArea(
                        top: false,
                        bottom: false,
                        child: GetBuilder<HomeViewController>(
                            builder: (_) => Scaffold(
                                resizeToAvoidBottomInset: false,
                                // drawerEnableOpenDragGesture: false,
                                // endDrawerEnableOpenDragGesture: false,
                                // onDrawerChanged: (isOpened) {
                                //   setState(() {});
                                // },
                                // onEndDrawerChanged: (isOpened) {
                                //   setState(() {});
                                // },
                                // drawer: MyDrawer(
                                //   isEnable: true,
                                // ),
                                key: _scaffoldKeys,
                                body:
                                    GetBuilder<EstablishmentDetailsController>(
                                        builder:
                                            (_) => Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      Positioned(
                                                          child: _controller.isShowItemDetails
                                                              ? Container(
                                                                  height: 65.h,
                                                                  alignment:Alignment.topCenter,
                                                                  child: Stack(
                                                                    children: [
                                                                      Column(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          mainAxisAlignment:MainAxisAlignment.start,
                                                                          children: [
                                                                      SafeArea(
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(18.0),
                                                                          child: Image.network(_controller.isShowItemDetails ? "${productData.imgUrl.toString()}" : "",
                                                                            height: 350,
                                                                            width: double.infinity,
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                          ],
                                                                        ),
                                                                      Container(
                                                                        height: 350,
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape.rectangle,
                                                                            // BoxShape.circle or BoxShape.retangle
                                                                            //color: const Color(0xFF66BB6A),
                                                                            borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: colorScheme.primary.withOpacity(0.2),
                                                                                blurRadius: 5.0,
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                      Padding(
                                                                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.09),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(color:AppThemes.foodBgColor,borderRadius: BorderRadius.circular(15)),
                                                                          margin: EdgeInsets.only(left:11,top:43.h,right: 11),
                                                                          padding: EdgeInsets.symmetric(vertical:4.0,horizontal:8.0),
                                                                          height: 66,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            '${productData.name} ${productData.weight}${language.gram}',
                                                                            //${productData.name}
                                                                            style: textTheme.bodyText2!.copyWith(
                                                                                color: AppThemes.colorWhite,
                                                                                fontSize: 14.sp),
                                                                            textAlign:TextAlign.center,
                                                                            softWrap:true,
                                                                            maxLines:2,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // Positioned(
                                                                      //   child:
                                                                      //       ,
                                                                      //   top: 43.h,
                                                                      //   left: 0,
                                                                      //   right: 0,
                                                                      // ),
                                                                      Positioned(
                                                                          right: 20,
                                                                          bottom: 125,
                                                                          child:
                                                                              Container(
                                                                            constraints:
                                                                                BoxConstraints(maxHeight: 95, maxWidth: 95),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Text("${productData.price} ${language.currency_symbol}",
                                                                                //${productData!.price}
                                                                                style: textTheme.bodyText1!.copyWith(color: AppThemes.colorWhite, fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w800, fontSize: 13.sp)),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.transparent,
                                                                                border: Border.all(color: Color(0xffffffff), width: 1.5),
                                                                                shape: BoxShape.circle),
                                                                          ))
                                                                    ],
                                                                  ),
                                                                )
                                                              : SizedBox()),
                                                      if ('${productData.detailedDescription}'
                                                          .isNotEmpty) ...[
                                                        //'${productData.detailedDescription}' != "null" &&
                                                        Container(

                                                          width: double.infinity,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
                                                            child: DescriptionUi(),
                                                          ),
                                                          margin:EdgeInsets.only(top: 52.h,bottom: 20.h),
                                                        )
                                                      ],
                                                      /*Positioned(
                                                    top: 10,
                                                    right: 6,
                                                    child: SafeArea(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          _scaffoldKeys
                                                              .currentState!
                                                              .openDrawer();
                                                        },
                                                        child: Container(
                                                          child: Icon(
                                                            Icons.menu,
                                                            color: Colors.white,
                                                            size: 7.w,
                                                          ),
                                                          height: 5.h,
                                                          width: 5.h,
                                                          decoration: BoxDecoration(
                                                              color: colorScheme
                                                                  .primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),*/
                                                      // back arrow
                                                      Positioned(
                                                        top: 10,
                                                        left: 6,
                                                        child: SafeArea(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              productData.quantity =pastQty;
                                                              _controller.update();
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              child: Icon(Icons.arrow_back,
                                                                color: Colors.white,
                                                                size: 7.w,
                                                              ),
                                                              height: 5.h,
                                                              width: 5.h,
                                                              decoration: BoxDecoration(
                                                                  color: colorScheme.primary,
                                                                  borderRadius:BorderRadius.circular(5)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      _controller .isShowItemDetails
                                                          ? Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              left: 0,
                                                              child: Align(
                                                                  alignment: Alignment.bottomCenter,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: AppThemes.foodBgColor,
                                                                        borderRadius: BorderRadius.circular(15)),
                                                                    padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0, bottom: 8.0),
                                                                    constraints: BoxConstraints(minHeight:80),
                                                                    alignment:Alignment.center,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(right: 16.0,left: 8.0),
                                                                          width: double.infinity,
                                                                          child:
                                                                              IntrinsicWidth(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: _controller.storeDetailsData.cashbackPercent! > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                if (_controller.storeDetailsData.cashbackPercent! > 0) ...[
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          // Row(
                                                                                          //   children: [
                                                                                          //     Expanded(
                                                                                          //       child: Text(
                                                                                          //         '${productData.name}',
                                                                                          //         style: textTheme.bodyText2!.copyWith(color: AppThemes.colorWhite, fontSize: 15.sp),
                                                                                          //         softWrap: true,
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //     SizedBox(width: 4),
                                                                                          //     Text(
                                                                                          //       '${productData.weight} ${language.gram}',
                                                                                          //       style: textTheme.bodyText2!.copyWith(color: Helpers.subtitleTextColor(), fontSize: 12.sp),
                                                                                          //       softWrap: true,
                                                                                          //     )
                                                                                          //   ],
                                                                                          // ),
                                                                                          // if (_controller.storeDetailsData.cashbackPercent! >
                                                                                          //     0) ...[
                                                                                          GestureDetector(
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.only(bottom: 8.0, right: 12.0),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
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
                                                                                                  Text(
                                                                                                    "${language.cashback} ${_controller.storeDetailsData.cashbackPercent}%: ${_controller.storeDetailsData.getCashBack(_controller.getSingleItemTotal(productData))} ${language.currency_symbol}",
                                                                                                    style: textTheme.bodyText2!.copyWith(color: AppThemes.primary, fontSize: 11.sp),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              debugPrint("click caseback");
                                                                                              showDialog(
                                                                                                  context: context,
                                                                                                  builder: (context) => CashBackDialog(
                                                                                                        message: language.networkError,
                                                                                                      ));
                                                                                            },
                                                                                          ),
                                                                                          // ],
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    if (productData.status == "not-available") ...[
                                                                                      Container(
                                                                                        decoration: BoxDecoration(
                                                                                            color: AppThemes.cashBackCardBgColor,
                                                                                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                                        child: GestureDetector(
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                "${language.out_of_stock}",
                                                                                                style: textTheme.bodyText2!.copyWith(color: colorScheme.error, fontSize: 11.sp),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          onTap: () {},
                                                                                        ),
                                                                                        padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
                                                                                        margin: const EdgeInsets.only(top: 0.0),
                                                                                      )
                                                                                    ] else ...[
                                                                                      if ((productData.quantity ?? 0) > 0) ...[
                                                                                        Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                //Mines button click
                                                                                                _controller.update();
                                                                                                int? qnt = productData.quantity;
                                                                                                if (qnt! >= 2) {
                                                                                                  productData.quantity = qnt.toInt() - 1;
                                                                                                }

                                                                                                // _controller.removeItemInCart(productData!);
                                                                                              },
                                                                                              child: Container(
                                                                                                constraints: BoxConstraints(minHeight: 22, minWidth: 22),
                                                                                                decoration: BoxDecoration(color: colorScheme.primary.withOpacity(1), borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                                                                                alignment: Alignment.center,
                                                                                                padding: EdgeInsets.all(4.0),
                                                                                                child: Container(
                                                                                                    height: 20,
                                                                                                    width: 20,
                                                                                                    child: SvgPicture.asset(
                                                                                                      AssetsPath.itemMinusIcon,
                                                                                                    )),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              constraints: BoxConstraints(minHeight: 22, minWidth: 30),
                                                                                              margin: EdgeInsets.only(left: 4.0),
                                                                                              decoration: BoxDecoration(color: AppThemes.colorWhite, borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                                                                              padding: EdgeInsets.all(4.0),
                                                                                              alignment: Alignment.center,
                                                                                              child: Text('${productData.quantity.toString()}', style: textTheme.bodyText2!.copyWith(color: AppThemes.dark, fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w400, fontSize: 13.sp)),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          print("add Items");
                                                                                          //Item add function
                                                                                          _controller.update();
                                                                                          if (productData != null) {
                                                                                            int? qnt = productData.quantity;
                                                                                            productData.quantity = qnt!.toInt() + 1;
                                                                                            // _controller.addItemInCart(productData!);

                                                                                          }
                                                                                        },
                                                                                        child: Container(
                                                                                          constraints: BoxConstraints(minHeight: 22, minWidth: 22),
                                                                                          margin: EdgeInsets.only(left: 4.0),
                                                                                          decoration: BoxDecoration(color: colorScheme.primary.withOpacity(1), borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                                                                          alignment: Alignment.center,
                                                                                          padding: EdgeInsets.all(4.0),
                                                                                          child: Container(
                                                                                              height: 20,
                                                                                              width: 20,
                                                                                              child: SvgPicture.asset(
                                                                                                AssetsPath.itemPlusIcon,
                                                                                              )),
                                                                                        ),
                                                                                      ),
                                                                                    ]
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (productData.status != "not-available") ...[
                                                                          SafeArea(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () async {
                                                                                //save to cart item
                                                                                int? qnt = productData.quantity;
                                                                                productData.quantity = qnt!.toInt() + pastQty!;
                                                                                _controller.saveItemInCart(productData);

                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                                                                padding: EdgeInsets.only(left: 16.0, right: 12.0, bottom: 8.0, top: 8.0),
                                                                                decoration: BoxDecoration(
                                                                                  // color: Colors.red,
                                                                                    color: colorScheme.primary,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(8.0),
                                                                                    )),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Text('${productData.quantity.toString()}', style: textTheme.bodyText1!.copyWith(fontSize: 11.sp, color: AppThemes.colorWhite, fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w400)),
                                                                                        Text(" ${language.items}", style: textTheme.bodyText1!.copyWith(fontSize: 11.sp, color: AppThemes.colorWhite.withOpacity(0.5), fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w400)),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 25,
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: Text(language.add_cart, style: textTheme.bodyText1!.copyWith(fontSize: 11.sp, color: AppThemes.colorWhite, fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                    SizedBox(),
                                                                                    // rounded btn
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(8.0),
                                                                                      decoration: BoxDecoration(
                                                                                          color: AppThemes.colorWhite.withOpacity(0.1),
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(8.0),
                                                                                          )),
                                                                                      alignment: Alignment.center,
                                                                                      constraints: BoxConstraints(minWidth: 75),
                                                                                      child: Text("${_controller.getSingleItemTotal(productData).toStringAsFixed(2)} ${language.currency_symbol}", style: textTheme.bodyText1!.copyWith(fontSize: 11.sp, color: AppThemes.colorWhite, fontFamily: AppConstants.fontFamily, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ]
                                                                      ],
                                                                    ),
                                                                  )),
                                                            )
                                                          : SizedBox()
                                                      //back button
                                                    ])),
                                backgroundColor: Colors.black)),
                      );
                    });
              },
            );
          }),
    );
  }
}
