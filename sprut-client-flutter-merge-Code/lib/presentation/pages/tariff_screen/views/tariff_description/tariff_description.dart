import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/assets_path/assets_path.dart';

class TariffDescription extends StatelessWidget {
  final String minumumCost;
  final String priceForkm;
  final String downTime;
  final String carPath;
  final  String numberOfSheet;
  final String carName;
  TariffDescription(
      {required this.minumumCost,
      required this.priceForkm,
      required this.downTime,
      required this.numberOfSheet,
      required this.carName,
      required this.carPath});

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
          child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 8,
            child: Center(
              child: Container(
                  width: 14.w,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: colorScheme.primary,
                  )),
            ),
          ),
          Positioned(
            top: 20,
            left: 7,
            right: 7,
            child: Column(
              children: [
                SizedBox(
                          height: 30,
                        ),
                        SvgPicture.asset(
                          carPath,
                        ),
                         SizedBox(
                          height: 8,
                        ),
                        Text(carName,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 14.sp, color: Colors.black)),
                        SizedBox(
                          height: 4,
                        ),
                         SizedBox(
                          height: 10,
                        ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                         
                        _option(textTheme, colorScheme, context,
                            language.minimumu_cost, minumumCost),
                        _option(textTheme, colorScheme, context,
                            language.price_for_km, priceForkm),
                        _option(textTheme, colorScheme, context, language.downtime,
                          downTime),
                        _option(textTheme, colorScheme, context,
                            language.no_of_seats, numberOfSheet)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(AssetsPath.infoIcon,
                            height: 7.w, color: colorScheme.primary),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Text(
                              language.minimum_price_order,
                              style: textTheme.bodyText1!.copyWith(
                                  fontSize: 9.sp, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              left: 7,
              right: 7,
              bottom: 15,
              child: PrimaryElevatedBtn(
                  buttonText: language.got_it,
                  onPressed: () {
                    Navigator.pop(context);
                  }))
        ],
      )),
    );
  }

  Widget _option(TextTheme textTheme, ColorScheme colorScheme,
      BuildContext context, leading, trailing) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(leading,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 10.sp, color: Colors.black)),
                Text(trailing,
                    style: textTheme.bodyText1!
                        .copyWith(fontSize: 10.sp, color: colorScheme.primary)),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              color: colorScheme.secondary.withOpacity(0.4),
              height: 0.7,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ));
  }
}
