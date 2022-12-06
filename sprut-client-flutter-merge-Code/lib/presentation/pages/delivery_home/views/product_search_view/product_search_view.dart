import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sizer/sizer.dart';

import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../resources/configs/routes/routes.dart';
import '../../../../widgets/primary_container/primary_container.dart';
import '../../../no_internet/no_internet.dart';
import '../../controller/establishment_details_controller.dart';
import '../establishment_details_view/product_item_ui.dart';

class ProductsSearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductsSearchStateView();
}

class ProductsSearchStateView extends State<ProductsSearchView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EstablishmentDetailsController controller =
      Get.put(EstablishmentDetailsController(), permanent: true);

  @override
  void initState() {
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
        initState: (_) {
          controller.isNoDataFound = false;
          controller.isSearchView = false;
          controller.searchProductList?.clear();
          controller.searchEstablishmentEditingController.clear();
        },
        builder: (context) {
          return BlocConsumer<ConnectedBloc, ConnectedState>(
            listener: (context, state) {
              if (state is ConnectedFailureState) {
              }

              if (state is ConnectedInitialState) {
                debugPrint("ConnectedInitialState:::");
              }
            },
            builder: (context, connectionState) {
              if (connectionState is ConnectedFailureState) {
                print("BlocConsumer 2");
                return NoInternetScreen(onPressed: () async {});
              }
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  onDrawerChanged: (isOpened) {
                    setState(() {});
                  },
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    titleSpacing: 0.0,
                    toolbarHeight: 56,
                    title: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                          color: AppThemes.foodBgColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border:
                              Border.all(color: Color(0xffA4A4A4), width: 1.5)),
                      constraints: BoxConstraints(
                        maxHeight: 5.5.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 40,
                            child: SvgPicture.asset(
                              AssetsPath.searchIcon,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // color: Colors.yellow,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0,
                                    top: 6.0,
                                    right: 4.0,
                                    bottom: 6.0),
                                child: TextField(
                                  style: textTheme.bodyText2!.copyWith(
                                      fontSize: 12.sp,
                                      color: AppThemes.colorWhite,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.none),
                                  readOnly: false,
                                  controller: controller
                                      .searchEstablishmentEditingController,
                                  onTap: () {},
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      controller.isSearchView = true;
                                    } else {
                                      controller.isSearchView = false;
                                      controller.searchEstablishmentEditingController.clear();
                                      controller.onSearchTextChanged("");
                                      controller.isNoDataFound = false;
                                      controller.update();
                                    }
                                    controller.update();
                                  },
                                  decoration: InputDecoration(
                                      hintText: language.search,
                                      hintStyle: textTheme.bodyText2!.copyWith(
                                          fontSize: 12.sp,
                                          color: AppThemes.lightGrey,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none),
                                      labelStyle: textTheme.bodyText2!.copyWith(
                                          fontSize: 12.sp,
                                          color: AppThemes.colorWhite,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 12.0),
                                      suffixIcon: controller.isSearchView
                                          ? IconButton(
                                              onPressed: () {
                                                controller
                                                    .searchEstablishmentEditingController
                                                    .clear();
                                                controller.onSearchTextChanged("");
                                                controller.isNoDataFound = false;
                                                controller.update();
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),padding: EdgeInsets.only(bottom: 0.0),)
                                          : null),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  onEndDrawerChanged: (isOpened) {
                    setState(() {});
                  },
                  key: _scaffoldKey,
                  body: GetBuilder<EstablishmentDetailsController>(
                    builder: (_) {
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 5.0, top: 20),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (controller
                                            .searchEstablishmentEditingController
                                            .text
                                            .isNotEmpty) {
                                          controller.onSearchTextChanged(controller.searchEstablishmentEditingController.text.toString());
                                          // controller.isNoDataFound = true;
                                          // controller.update();
                                        }
                                      },
                                      child: Text(
                                        language.simple_search,
                                        style: TextStyle(
                                            color: AppThemes.colorWhite,
                                            fontSize: 12.sp,
                                            fontFamily: AppConstants.fontFamily,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      style: ButtonStyle(
                                        minimumSize:
                                        MaterialStateProperty.all(Size(107.0, 6.h)),
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor: MaterialStateProperty.all(
                                            colorScheme.primary),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: AppThemes.darkGrey
                                                    .withOpacity(0.3)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Align(
                                    child: Text(
                                      language.placeholder_message_of_product_search,
                                      style: textTheme.bodyText1!.copyWith(
                                          fontSize: 10.sp,
                                          color: Helpers.secondaryTextColor(),
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                if(controller.searchProductList?.isNotEmpty == true)...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 66.0),
                                    child: GroupedListView<ProductItems, String>(
                                      shrinkWrap: true,
                                      key: Key("List"),
                                      elements: controller.searchProductList ?? [],
                                      groupBy: (element) => (element.section?.id ?? 0).toString(),
                                      groupHeaderBuilder: (item) {
                                        var count = controller.searchProductList
                                            ?.where(
                                                (element) => element.section?.id == item.section?.id)
                                            .length ??
                                            0;
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                                            child: Text(
                                              (item.section?.name ?? "") + " ($count)",
                                              style: textTheme.bodyText2!.copyWith(
                                                  color: AppThemes.colorWhite,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.left,
                                              softWrap: true,
                                              maxLines: 2,
                                            ),
                                          ),
                                        );
                                      },
                                      itemBuilder: (context, dynamic element) => Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
                                        child: GestureDetector(
                                          child: ProductItemUi(element, false),
                                          onTap: () async {
                                            print("Go To Details");
                                            controller.tempItems = element;
                                            Navigator.pushNamed(
                                                context, Routes.foodDeliveryProductItemDetailsView,
                                                arguments: element);

                                          },
                                        ),
                                      ),
                                      floatingHeader: true,
                                    ),
                                  ),
                                ]else...[
                                  if (controller.isNoDataFound) ...[
                                    Container(
                                      height: MediaQuery.of(context).size.height - 22.h,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: SvgPicture.asset(
                                                AssetsPath.saidSmileFaceWhite,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: 24.0,
                                                  right: 24.0),
                                              child: controller.textMaker(
                                                  context,
                                                  language
                                                      .empty_find_products_search,
                                                  " ${controller.searchEstablishmentEditingController.text} ",
                                                  "",
                                                  "primary"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ],
                            ),
                          ),
                          if (controller
                              .cartItemList?.isNotEmpty ==
                              true) ...[
                            Align(
                                alignment: Alignment.bottomCenter,
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
                                                  "${controller.getTotalCartItem()}",
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
                                                '${controller.getCartItemTotalAmount()} ${language.currency_symbol}',
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
                        ],
                      );
                    }
                  ),
                  backgroundColor: Helpers.primaryBackgroundColor(colorScheme),
                ),
              );
            },
          );
        });
  }
}

/*

Sorry, we didn't find any orders or products that match "vbjgvhjgvtvh".
You can change the value and try again.

* */
