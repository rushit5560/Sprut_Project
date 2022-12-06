import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_event/auth_event.dart';
import 'package:sprut/business_logic/blocs/authentication_bloc/auth_state/auth_state.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/repositories/user_auth_repository/user_auth_repository.dart';

import '../../../../data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../data/models/establishments_all_screen_models/types/food_type_list_models.dart';
import '../../../../data/models/food_category_models/food_category_list_models.dart';
import '../../../../data/repositories/food_category_screen_repostiory/FoodCategoryRepository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLoginUsingMobile) {
      yield* mapLoginToState(event.mobileNumber);
    }
    if (event is AuthSendSmsEvent) {
      yield* mapLoginToState(event.mobileNumber);
    }

    if (event is AuthVerifyOtp) {
      yield* mapLoginUsingOtpToState(event.otp);
    }
    if (event is AuthAvailableCitiesEvent) {
      yield* mapAvailableCitiesToState();
    }

    if (event is AuthSendOtpAgain) {
      yield* mapResendOtpUsingOtpToState(event.mobileNumber);
    }

    //Food Delivery
    if(event is AuthFoodDeliveryCategoryListEvent){
      log("message::::::::");
      yield* mapFoodCategoryListToState();
    }

    //establishments
    if(event is AuthAllEstablishmentsListEvent){
      yield*  mapEstablishmentsListToState(event.categoryID, event.latitude, event.longitude);
    }

    //food type
    if(event is AuthTypeEstablishmentsListEvent){
      yield* mapFoodTypeEstablishmentsListToState(event.categoryID);
    }

    //product list
    if(event is AuthEstablishmentProductListEvent){
      yield* mapFoodEstablishmentProductListToState(event.brandID);
    }

    //make order
    if(event is AuthMakeOrderEvent){
      yield* mapMakeOrderToState(event.body);
    }

    //order status checked
    if(event is AuthStatusOfOrderEvent){
      yield* mapCheckOrderStatusToState(event.oderId);
    }
    //End
  }

  @override
  AuthState get initState => InitialAuthState();

  /// For[Login]
  Stream<AuthState> mapLoginToState(String userPhoneNumber) async* {
    yield AuthUsingMobileInProgress();

    try {
      await UserAuthRepository()
          .initialzeUserSession(userPhoneNumber: userPhoneNumber);

      yield SucceedAuthUsingMobile();
    } catch (e) {
      log(e.toString());
      yield FailureAuthUsingMobile();
    }
  }

  /// [For Verify Otp]
  Stream<AuthState> mapLoginUsingOtpToState(String otp) async* {
    yield AuthUsingOtpProgress();

    try {
      await UserAuthRepository().verifyOTP(otp: otp);

      yield AuthUsingOtpSucceed();
    } catch (e) {
      log(e.toString());
      yield AuthUsingOtpFailed(message: e.toString());
    }
  }

  /// [For Resend Otp]
  Stream<AuthState> mapResendOtpUsingOtpToState(String mobileNumber) async* {
    yield AuthSendSmsAgainProgress();

    try {
      await UserAuthRepository()
          .initialzeUserSession(userPhoneNumber: mobileNumber);

      yield AuthSendSmsAgainSucceed();
    } catch (e) {
      log(e.toString());
      yield AuthSendSmsAgainFailed(message: e.toString());
    }
  }

  /// [For availableCities of user]

  
  Stream<AuthState> mapAvailableCitiesToState() async* {
    yield FetchingAvailableCities();

    try {
      List<AvailableCitiesModel> availableCities =
          await UserAuthRepository().getAvailableCities();

      yield FetechedAvailableCities(availableCities: availableCities);
    } catch (e) {
     
      yield FailedFetchAvailableCitiesState();
    }
  }

  //Food Delivery
  /// [Food Delivery Category List]
  Stream<AuthState> mapFoodCategoryListToState() async* {
    yield FetchingFoodDeliveryCategoryProgress();

    try {
      FoodCategoryListModel foodResponse = await FoodCategoryRepository().getFoodCategoryList();

      yield FetchingFoodDeliveryCategorySucceed(availableCategory: foodResponse.items);
    } catch (e) {
      log(e.toString());
      yield FetchingFoodDeliveryCategoryFailed(message: e.toString());
    }
  }

  ///[establishments all list get]
  Stream<AuthState> mapEstablishmentsListToState(String categoryID, double latitude, double longitude) async* {
    yield FetchingEstablishmentsListProgress();
    try {
      AllEstablishments foodResponse = await FoodCategoryRepository().getEstablishmentsList(categoryID, latitude, longitude);
      yield FetchingEstablishmentsListSucceed(availableEstablishmentsList: foodResponse.items);
    } catch (e) {
      log(e.toString());
      yield FetchingEstablishmentsListFailed(message: e.toString());
    }
  }

  ///[establishments food type list]
  Stream<AuthState> mapFoodTypeEstablishmentsListToState(String categoryID) async* {
    yield FetchingFoodTypeEstablishmentsListProgress();
    try {
      FoodTypeModels foodResponse = await FoodCategoryRepository().getFoodTypesList(categoryID);
      log("Food Type Response:: "+foodResponse.items.toString());
      yield FetchingFoodTypeEstablishmentsListSucceed(allFoodType: foodResponse.items);
    } catch (e) {
      log(e.toString());
      yield FetchingEstablishmentsListFailed(message: e.toString());
    }
  }

  ///[establishments product list]
  Stream<AuthState> mapFoodEstablishmentProductListToState(String brandID) async* {
    yield FetchingFoodEstablishmentProductListProgress();
    try {
      ProductListResponse productListResponse = await FoodCategoryRepository().getProductList(brandID);
      log("Product List Response:: "+productListResponse.items.toString());
      yield FetchingFoodEstablishmentProductListSucceed(allProductList: productListResponse.items);
    } catch (e) {
      log(e.toString());
      yield FetchingFoodEstablishmentProductListFailed(message: e.toString());
    }
  }

  ///[make order]
  Stream<AuthState> mapMakeOrderToState(var body) async* {
    yield FetchingMakeOrderProgress();
    try {
      var orderResponse = await FoodCategoryRepository().makeAOrder(body);
      log("Make Order :: "+orderResponse.toString());
      yield FetchingMakeOrderSucceed(responseOrder: orderResponse);
    } catch (e) {
      log(e.toString());
      yield FetchingMakeOrderFailed(message: e.toString());
    }
  }

  ///[order status]
  Stream<AuthState> mapCheckOrderStatusToState(int? oderID) async* {
    yield FetchingCheckedOrderStatusProgress();
    try {
      var orderStatusResponse = await FoodCategoryRepository().statusCheckedAOrder(oderID);
      log("Make Order :: "+orderStatusResponse.toString());
      yield FetchingCheckedOrderStatusSucceed(responseOrder: orderStatusResponse);
    } catch (e) {
      log(e.toString());
      yield FetchingCheckedOrderStatusFailed(message: e.toString());
    }
  }

//End
}
