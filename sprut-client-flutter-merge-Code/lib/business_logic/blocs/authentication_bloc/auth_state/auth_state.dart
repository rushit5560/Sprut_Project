import 'package:flutter/material.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';

import '../../../../data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import '../../../../data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import '../../../../data/models/establishments_all_screen_models/types/food_type_list_models.dart';
import '../../../../data/models/food_category_models/food_category_list_models.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class SucceedAuthUsingMobile extends AuthState {}

class FailureAuthUsingMobile extends AuthState {}

class AuthUsingMobileInProgress extends AuthState {}

///[Verify Otp States]

class AuthUsingOtp extends AuthState {}

class AuthUsingOtpProgress extends AuthState {}

class AuthUsingOtpSucceed extends AuthState {}

class AuthUsingOtpFailed extends AuthState {
  final String message;
  AuthUsingOtpFailed({required this.message});
}

///[Resend Otp]

class AuthSendSmsAgainState extends AuthState {}

class AuthSendSmsAgainProgress extends AuthState {}

class AuthSendSmsAgainSucceed extends AuthState {}

class AuthSendSmsAgainFailed extends AuthState {
  final String message;
  AuthSendSmsAgainFailed({required this.message});
}

class ChangeMobileNumber extends AuthState {}

class ChangeMobileInitiate extends AuthState {
  final String mobile;

  ChangeMobileInitiate({required this.mobile});
}

/// [Available Cities]
///
class FetchingAvailableCities extends AuthState {}

class FailedFetchAvailableCitiesState extends AuthState {}

class FetechedAvailableCities extends AuthState {
  final List<AvailableCitiesModel> availableCities;

  FetechedAvailableCities({required this.availableCities});
}

//Food Delivery
///[Food Category Data]
class FetchingFoodDeliveryCategoryProgress extends AuthState {}

class FetchingFoodDeliveryCategorySucceed extends AuthState {
  final List<FoodCategoryData>? availableCategory;

  FetchingFoodDeliveryCategorySucceed({required this.availableCategory});
}

class FetchingFoodDeliveryCategoryFailed extends AuthState {
  final String message;
  FetchingFoodDeliveryCategoryFailed({required this.message});
}

///[Establishments All List]
class FetchingEstablishmentsListProgress extends AuthState {}

class FetchingEstablishmentsListSucceed extends AuthState {
  final List<Establishments>? availableEstablishmentsList;
  FetchingEstablishmentsListSucceed(
      {required this.availableEstablishmentsList});
}

class FetchingEstablishmentsListFailed extends AuthState {
  final String message;
  FetchingEstablishmentsListFailed({required this.message});
}

///[Establishments Type List]
class FetchingFoodTypeEstablishmentsListProgress extends AuthState {}

class FetchingFoodTypeEstablishmentsListSucceed extends AuthState {
  final List<FoodType>? allFoodType;
  FetchingFoodTypeEstablishmentsListSucceed({required this.allFoodType});
}

class FetchingFoodTypeEstablishmentsListFailed extends AuthState {
  final String message;
  FetchingFoodTypeEstablishmentsListFailed({required this.message});
}

///[Establishments Product List]
class FetchingFoodEstablishmentProductListProgress extends AuthState {}

class FetchingFoodEstablishmentProductListSucceed extends AuthState {
  final List<ProductItems>? allProductList;
  FetchingFoodEstablishmentProductListSucceed({required this.allProductList});
}

class FetchingFoodEstablishmentProductListFailed extends AuthState {
  final String message;
  FetchingFoodEstablishmentProductListFailed({required this.message});
}

///[Make Order]
class FetchingMakeOrderProgress extends AuthState {}

class FetchingMakeOrderSucceed extends AuthState {
  var responseOrder;
  FetchingMakeOrderSucceed({required this.responseOrder});
}

class FetchingMakeOrderFailed extends AuthState {
  final String message;
  FetchingMakeOrderFailed({required this.message});
}

///[Order Status Checked]
class FetchingCheckedOrderStatusProgress extends AuthState {}

class FetchingCheckedOrderStatusSucceed extends AuthState {
  var responseOrder;
  FetchingCheckedOrderStatusSucceed({required this.responseOrder});
}

class FetchingCheckedOrderStatusFailed extends AuthState {
  final String message;
  FetchingCheckedOrderStatusFailed({required this.message});
}

//End
