import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/data/models/establishments_all_screen_models/types/food_type_list_models.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_controller.dart';

import '../../../../../business_logic/blocs/authentication_bloc/auth_bloc/auth_bloc.dart';
import '../../../../../business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_bloc.dart';
import '../../../../../business_logic/blocs/connection_bloc/connection_state/connection_state.dart';
import '../../../../../data/models/food_category_models/food_category_list_models.dart';
import '../../../../../resources/app_themes/app_themes.dart';
import '../../../../../resources/assets_path/assets_path.dart';
import '../../../../../resources/configs/helpers/helpers.dart';
import '../../../../../resources/configs/routes/routes.dart';
import '../../../../../resources/services/database/database_keys.dart';
import '../../../home_screen/controllers/home_controller.dart';
import '../../../no_internet/no_internet.dart';

class ItemFilterTypeList extends StatefulWidget {
  FoodCategoryData _foodCategoryData = FoodCategoryData();

  @override
  State<StatefulWidget> createState() => _ItemFilterTypeListState();
}

class _ItemFilterTypeListState extends State<ItemFilterTypeList> {
  bool lastSelectedIndex = false;
  int selectedIndex = 0;

  EstablishmentController establishmentController =
      Get.find<EstablishmentController>();

  HomeViewController controller = Get.put(HomeViewController(), permanent: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = 0;
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        widget._foodCategoryData =
        ModalRoute.of(context)!.settings.arguments as FoodCategoryData;
        establishmentController.lsFoodTypeData.clear();
        context.read<AuthBloc>()
            .add(AuthTypeEstablishmentsListEvent(categoryID: widget._foodCategoryData.id.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
     var language = AppLocalizations.of(context)!;
    Locale appLocale = Localizations.localeOf(context);


    return BlocConsumer<ConnectedBloc, ConnectedState>(
      listener: (context, state) {
        // if (state is ConnectedFailureState) {
        //   showDialog(
        //       context: context,
        //       builder: (context) => MyCustomDialog(
        //         message: language.networkError,
        //       ));
        // }
        //
        // if (state is ConnectedInitialState) {
        //   debugPrint("ConnectedInitialState:::");
        // }
      },
      builder: (context, connectionState) {
        if (connectionState is ConnectedFailureState) {

          return NoInternetScreen(onPressed: () async {});
        }

        if (connectionState is ConnectedSucessState) {}

        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is FetchingFoodTypeEstablishmentsListProgress) {
              debugPrint("Loading Progress!");
              // Helpers.showCircularProgressDialog(context: context);
            }

            if (authState is FetchingFoodTypeEstablishmentsListSucceed) {
              // Navigator.pop(context);
              // debugPrint("Response Success!");
              if (authState.allFoodType!.isNotEmpty == true) {
                // debugPrint("List Food Type Success");
                if (establishmentController.lsFoodTypeData.isNotEmpty) {
                  establishmentController.lsFoodTypeData.clear();
                }
                //add first index all typ[e
                FoodType firstIndexAdd = FoodType(
                    id: 0,
                    name: language.all,
                    description: "",
                    imgUrl: "",
                    status: "publish",
                    isFiltered: true);

                establishmentController.lsFoodTypeData.add(firstIndexAdd);
                authState.allFoodType!.forEach((data) => {establishmentController.lsFoodTypeData.add(data)});
                // debugPrint("Length ::" + establishmentController.lsFoodTypeData.length.toString());
                setState(() {});
                establishmentController.update();
              }else{
                // debugPrint("Size Of establishment:: "+establishmentController.lsEstablishmentsData.length.toString());
                // debugPrint("Size Of type:: "+establishmentController.lsFoodTypeData.length.toString());
                setState((){});
                establishmentController.update();
              }
            }

            if (authState is FetchingFoodTypeEstablishmentsListFailed) {
              // debugPrint("FetchingFoodTypeEstablishmentsListFailed ");
              // Navigator.pop(context);
              //check is session expired
              if (authState.message.toString() == "Session expired") {
                Helpers.clearUser();

                dynamic workAddress = controller.databaseService
                    .getFromDisk(DatabaseKeys.userWorkAddress);
                dynamic homeAddress = controller.databaseService
                    .getFromDisk(DatabaseKeys.userHomeAddress);
                controller.cacheAddress["homeAddress"] = homeAddress;
                controller.cacheAddress["workAddress"] = workAddress;
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.foodHomeScreen, ModalRoute.withName('/'));
              }
            }
          },
          builder: (context, authState) {
            return establishmentController.lsFoodTypeData.isNotEmpty ? SizedBox(
              height: 105,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: establishmentController.lsFoodTypeData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? AppThemes.primary
                                        : AppThemes.foodBgColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  child:
                                      '${establishmentController.lsFoodTypeData[index].name}' == language.all
                                          ? Image.asset(
                                              AssetsPath.allTypes,
                                            )
                                          : Image.network(
                                              "${establishmentController.lsFoodTypeData[index].imgUrl}",
                                              fit: BoxFit.fill,
                                              height: 35,
                                              width: 35,
                                            ),
                                ),
                              ),
                            ),
                            // if('${lsFoodTypeData[index].name}' == "All")...[
                            //   Padding(
                            //     padding: const EdgeInsets.all(5.0),
                            //     child: Container(
                            //       width: 65,
                            //       height: 65,
                            //       decoration: BoxDecoration(
                            //           color: selectedIndex == index ? AppThemes.primary : AppThemes.foodBgColor,
                            //           borderRadius:
                            //           BorderRadius.all(Radius.circular(7))),
                            //       alignment: Alignment.center,
                            //       child: Image.asset(
                            //         AssetsPath.allTypes,
                            //       ),
                            //     ),
                            //   ),
                            // ]else...[
                            //   Padding(
                            //     padding: const EdgeInsets.all(5.0),
                            //     child: Container(
                            //       width: 65,
                            //       height: 65,
                            //       decoration: BoxDecoration(
                            //           color: selectedIndex == index ? AppThemes.primary : AppThemes.foodBgColor,
                            //           borderRadius:
                            //           BorderRadius.all(Radius.circular(7))),
                            //       alignment: Alignment.center,
                            //       child: ClipRRect(
                            //         borderRadius: BorderRadius.all(Radius.circular(7)),
                            //         child: Image.network(
                            //           "${lsFoodTypeData[index].imgUrl}",
                            //           fit: BoxFit.fill,
                            //           height: 35,
                            //           width: 35,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ],
                            Text(('${establishmentController.lsFoodTypeData[index].name}' == language.all)?'${language.all}' :
                                (appLocale==Locale('en'))? '${establishmentController.lsFoodTypeData[index].nameEn}':
                                (appLocale==Locale('uk'))?'${establishmentController.lsFoodTypeData[index].nameUk}':
                                (appLocale==Locale('ru'))?'${establishmentController.lsFoodTypeData[index].nameRu}':'${establishmentController.lsFoodTypeData[index].name}',
                                style: textTheme.bodySmall!.copyWith(
                                    fontSize: 8.sp,
                                    color: AppThemes.colorWhite))
                          ],
                        ),
                      ),
                      onTap: () {
                        debugPrint(establishmentController.lsFoodTypeData[index].id.toString());
                        //click
                        selectedIndex = index;
                        setState(() {
                          selectedIndex;
                        });
                        //filter apply
                        establishmentController
                            .filterData(establishmentController.lsFoodTypeData[index].id.toString());
                      });
                },
              ),
            ) : SizedBox();
          },
        );
      },
    );
  }
}
