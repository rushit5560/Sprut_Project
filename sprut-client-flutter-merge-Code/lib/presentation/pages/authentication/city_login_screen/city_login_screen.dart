import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/presentation/widgets/circular_progress_bar/circular_progress_bar.dart';
import 'package:sprut/presentation/widgets/primary_elevated_btn/primary_elevated_btn.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprut/resources/app_themes/app_themes.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

import '../../../../resources/configs/routes/routes.dart';

class CityLogin extends StatefulWidget {
  @override
  State<CityLogin> createState() => _CityLoginState();
}

class _CityLoginState extends State<CityLogin> {
  int selectCityRadioValue = 0;

  @override
  void initState() {
    super.initState();

    Helpers.submitCity(
        city: AvailableCitiesModel(
            code: "vin",
            name: "Vinnytsia",
            localizedName: "Ukraine.Vinnytsia",
            comment: "",
            defaultZoom: 13,
            defaultZoomOnMobile: 13,
            coatOfArmsUrl: null,
            wikipediaArticleUrl:
                "https://uk.wikipedia.org/wiki/%D0%92%D1%96%D0%BD%D0%BD%D0%B8%D1%86%D1%8F",
            officialWebsiteUrl: "http://vmr.gov.ua/",
            population: 372,
            phoneAreaCode: "43",
            trivia: null,
            lat: 49.2372,
            lon: 28.46722));
  }

  AvailableCitiesModel? selectedCityName;
  @override
  Widget build(BuildContext context) {
    Helpers.systemStatusBar();

    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var language = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Platform.isIOS ? 10 : 8,
            vertical: Platform.isIOS ? 23 : 8),
        child: PrimaryElevatedBtn(
            buttonText: language.confirm,
            onPressed: () async {
              bool isConnected = await Helpers.checkInternetConnectivity();

              if (!isConnected) {
                Helpers.internetDialog(context);
                return;
              }

              if (selectedCityName != null) {
                Helpers.submitCity(city: selectedCityName!);
                if(selectedCityName?.name != "Vinnytsia") {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.homeScreen, (route) => false);
                }else {
                  Navigator.pushNamed(context, Routes.welcomeScreen);
                }
              }
            }),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
              ),
              Text(language.city,
                  style: textTheme.bodyText1!
                      .copyWith(fontSize: 15.sp, color: AppThemes.dark)),
              _sizedBox(),
              Text(language.whereLive,
                  style: textTheme.bodyText1!
                      .copyWith(fontSize: 10.sp, color: colorScheme.secondary)),
              SizedBox(
                height: 12.0,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is FetechedAvailableCities) {
                    if (state.availableCities.isNotEmpty) {
                      if (selectedCityName == null) {
                        selectedCityName = state.availableCities[0];
                      }
                      setState(() {});
                    }
                  }
                },
                builder: (context, state) {
                  if (state is FetechedAvailableCities) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemCount: state.availableCities.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            String cityName = "";

                            if (state.availableCities[index].name ==
                                "Vinnytsia") {
                              cityName = language.vinnytsia;
                            } else if (state.availableCities[index].name ==
                                "Uman") {
                              cityName = language.uman;
                            } else if (state.availableCities[index].name ==
                                "Haisyn") {
                              cityName = language.haisyn;
                            }
                            print('herecityname  $cityName');

                            return GestureDetector(
                              onTap: () {
                                selectCityRadioValue = index;
                                selectedCityName = state.availableCities[index];
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cityName,
                                            style: TextStyle(
                                                color: selectCityRadioValue !=
                                                        index
                                                    ? Colors.black
                                                    : colorScheme.primary,
                                                fontFamily:
                                                    AppConstants.fontFamily,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.sp),
                                          ),
                                          Radio(
                                            activeColor: colorScheme.primary,
                                            groupValue: index,
                                            value: selectCityRadioValue,
                                            onChanged: (value) {
                                              selectCityRadioValue = index;
                                              selectedCityName = state.availableCities[index];
                                              setState(() {});
                                            },
                                          )
                                        ]),
                                  ),
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      borderRadius: BorderRadius.circular(9)),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Center(child: SprutCircularProgressBar()),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
      backgroundColor: colorScheme.onBackground,
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 1.h,
    );
  }
}