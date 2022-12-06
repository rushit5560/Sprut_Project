import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';
import 'package:sprut/presentation/widgets/cart_leave_dialog/cart_leave_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../../resources/app_constants/app_constants.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';

class ProductItemUi extends GetView<EstablishmentDetailsController> {
  final ProductItems item;
  final bool isRemovable;

  ProductItemUi(this.item, this.isRemovable);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
          color: AppThemes.cashBackCardBgColor,
          borderRadius: BorderRadius.circular(8)),
      constraints: BoxConstraints(minHeight: 136),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 136, maxWidth: 121),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      child: SizedBox(
                        height: 136,
                        width: 121,
                        child: Image.network(item == null ? "": item.imgUrl ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    if (controller.storeDetailsData.cashbackPercent != 0) Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colorScheme.primary.withOpacity(0.9),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16.0),
                                      bottomLeft: Radius.circular(7.0),
                                      topRight: Radius.circular(16.0))),
                              constraints: BoxConstraints(
                                  minWidth: 88, maxHeight: 31.63),
                              padding: EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              child: Text(
                                "${controller.storeDetailsData.cashbackPercent ?? 0}% ",
                                style: textTheme.bodyText2!.copyWith(
                                    color: AppThemes.colorWhite,
                                    fontFamily: AppConstants.fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11.sp),
                              ),
                            ),
                            bottom: 0,
                          ) else SizedBox(),
                    if(item.status == "not-available")...[
                      Positioned(
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppThemes.cashBackCardBgColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(16.0))),
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
                          margin: const EdgeInsets.only(top: 8.0),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name}',
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      if (isRemovable) ...[
                        GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: colorScheme.primary,
                          ),
                          onTap: () async {
                            controller.isDeleteDialogShow = true;
                            onShowRemovingDialog(context);
                          },
                        )
                      ]
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '(${item.weight}${language.gram})',
                      style: textTheme.bodyText1!.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontFamily: AppConstants.fontFamily,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item.shortDescription?.isNotEmpty == true
                          ? '${item.shortDescription}'
                          : "",
                      style: textTheme.bodySmall!.copyWith(
                          fontSize: 10.sp,
                          color: Color(0xff838383),
                          fontFamily: AppConstants.fontFamily,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 60.w,
                    padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, right: 8.0),
                            child: Text(
                              item.price?.isNotEmpty == true
                                  ? '${item.price} ${language.currency_symbol}'
                                  : "",
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                            ),
                          ),
                          if(item.status != "not-available")...[
                            Row(
                              children: [
                                if(item.status != "not-available")...[
                                  if (item.quantity! > 0) ...[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            //Mines button click
                                            controller.update();
                                            controller.removeItemInCart(item);
                                            if (isRemovable) {
                                              if (controller.getTotalCartItem() ==
                                                  0) {
                                                print("Empty Cart!");
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: Container(
                                            constraints: BoxConstraints(
                                                minHeight: 21, minWidth: 21),
                                            decoration: BoxDecoration(
                                                color: colorScheme.primary
                                                    .withOpacity(1),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0))),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(4.0),
                                            child: Container(
                                                height: 18,
                                                width: 18,
                                                child: SvgPicture.asset(
                                                  AssetsPath.itemMinusIcon,
                                                )),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              minHeight: 18, minWidth: 28),
                                          margin: EdgeInsets.only(left: 4.0),
                                          decoration: BoxDecoration(
                                              color: AppThemes.colorWhite,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6.0))),
                                          padding: EdgeInsets.all(4.0),
                                          alignment: Alignment.center,
                                          child: Text('${item.quantity.toString()}',
                                              style: textTheme.bodyText2!.copyWith(
                                                  color: AppThemes.dark,
                                                  fontFamily:
                                                  AppConstants.fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp)),
                                        ),
                                      ],
                                    ),
                                  ],
                                  GestureDetector(
                                    onTap: () async {
                                      debugPrint("addItemInCart:::");
                                      //Item add function
                                      controller.update();
                                      controller.addItemInCart(item);
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minHeight: 21, minWidth: 21),
                                      margin: EdgeInsets.only(left: 4.0),
                                      decoration: BoxDecoration(
                                          color: colorScheme.primary.withOpacity(1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0))),
                                      padding: EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      child: Container(
                                          height: 18,
                                          width: 18,
                                          child: SvgPicture.asset(
                                            AssetsPath.itemPlusIcon,
                                          )),
                                    ),
                                  ),
                                ]
                              ],
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                  if (controller.storeDetailsData.cashbackPercent != 0)...[
                    if(controller.storeDetailsData.getCashBack(controller.getSingleItemTotal(item)) > 0.0)...[
                      Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Text(
                          '${language.cashback} ${controller.storeDetailsData.cashbackPercent ?? 0}%: ${controller.storeDetailsData.getCashBack(controller.getSingleItemTotal(item))} ${language.currency_symbol}',
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 10.sp,
                              color: colorScheme.primary,
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      )
                    ]else...[
                      Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Text(
                          '${language.cashback} ${controller.storeDetailsData.cashbackPercent ?? 0}%: ${controller.storeDetailsData.getCashBack(double.parse(item.price.toString()))} ${language.currency_symbol}',
                          style: textTheme.bodyText1!.copyWith(
                              fontSize: 10.sp,
                              color: colorScheme.primary,
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      )
                    ]
                  ]else...[
                    SizedBox()
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void onShowRemovingDialog(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => CartLeaveDialog(
        message: "",
        title: language.remove_item_alert_message,
        icons: AssetsPath.leaveCartIcon,
        okButtonText: language.yes_delete,
        closeButtonText: language.cancel,
        isSingleButton: true,
        onPositivePressed: () {
          controller.isDeleteDialogShow = false;
          Navigator.of(context).pop();
          controller.deleteItemInCart(item);
          print("Remove from cart!");
          if (controller.getTotalCartItem() == 0) {
            print("Empty Cart!");
            Navigator.of(context).pop();
          }
        },
        onNegativePressed: () {
          controller.isDeleteDialogShow = false;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
