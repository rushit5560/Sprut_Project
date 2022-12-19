import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginUsingMobile extends AuthEvent {
  final String mobileNumber;

  AuthLoginUsingMobile({required this.mobileNumber});
}

///[Verify Otp Event]
class AuthVerifyOtp extends AuthEvent {
  final String otp;

  AuthVerifyOtp({required this.otp});
}

class AuthSendSmsEvent extends AuthEvent {
  final String mobileNumber;

  AuthSendSmsEvent({required this.mobileNumber});
}



class AuthSendOtpAgain extends AuthEvent {
  final String  mobileNumber;
  AuthSendOtpAgain({required this.mobileNumber});
}



class ChangeMobileNumberEvent extends AuthEvent {}

/// [Available Cities]
class AuthAvailableCitiesEvent extends AuthEvent {}


//Food Delivery
/// [Food Delivery Category List]
class AuthFoodDeliveryCategoryListEvent extends AuthEvent {}

///[Establishments GET ALL LIST]
class AuthAllEstablishmentsListEvent extends AuthEvent {
  final String categoryID;
  final double latitude;
  final double longitude;

  AuthAllEstablishmentsListEvent({required this.categoryID,required this.latitude,required this.longitude});
}

///[Establishments GET TYPE LIST]
class AuthTypeEstablishmentsListEvent extends AuthEvent {
  final String categoryID;
  AuthTypeEstablishmentsListEvent({required this.categoryID});
}

///[Establishments Product LIST]
class AuthEstablishmentProductListEvent extends AuthEvent {
  final String brandID;
  final String establishmentId;
  final String placeId;
  AuthEstablishmentProductListEvent({required this.brandID, required this.establishmentId, required this.placeId});
}


///[Make Order]
class AuthMakeOrderEvent extends AuthEvent {
  var body;
  AuthMakeOrderEvent({required this.body});
}

///[Order status Checked]
class AuthStatusOfOrderEvent extends AuthEvent {
  final int? oderId;
  AuthStatusOfOrderEvent({required this.oderId});
}
//End