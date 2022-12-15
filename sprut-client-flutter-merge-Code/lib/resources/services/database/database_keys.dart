class DatabaseKeys {
  DatabaseKeys._privateConstructor();

  ///[Shared preference keys]
  /// Authentication

  static String sessionToken = "sessionToken";

  /// Screen after otp verify
  static String selectedCity = "selectedCity";
  static String selectedCityName = "selectedCityName";

  static String isLoggedIn = "isLoggedIn";

  static String userPhoneNumber = "userPhone";

  static String userWorkAddress = "userWorkAddress";
  static String userHomeAddress = "userHomeAddress";

  /// Using In Select City Radio Button
  static String selectedCityGroupValue = "selectedCityGroupValue";

  static String homeAddressLocationData = "homeAddressLocationData";
  static String workAddressLocationData = "workAddressLocationData";

  static String selectedCityCode = "selectedCityCode";
  static String workAddressLatitude = "workAddressLatitude";
  static String workAddressLongitude = "workAddressLongitude";
  static String homeAddressLatitude = "homeAddressLatitude";
  static String homeAddressLongitude = "homeAddressLongitude";

  static String defaultLatitude = "defaultLatitude";
  static String defaultLongitude = "defaultLongitude";

  static String services = "services";
  static String comments = "comments";

  static String order = "order";
  static String arrivalAddress = "arrival_address";
  static String destinationAddress = "destination_address";

  static String preorder = "preorder";

  static String orderArriveTime = "order_arrive_time";
  static String orderRideTime = "order_ride_time";

  static String defaultFare = "default_fare";
  static String preorderTime = "preorder_time";

  static String crashlytics = "crashlytics";

  static String readNews = "read_news";

  //private policy
  static String privacyPolicyAccepted = "privacyPolicyAccepted";

  //FOOD DELIVERY
  static String isLoginTypeSelected = "isLoginTypeSelected";
  static String isLoginTypeIn = "isLoginTypeIn";
  static String activeOrderCounts = "activeOrderCounts";

  static String recentlySearchAddress = "recentlySearchAddress";

  static String isLocationStatus = "isLocationStatus";
  static String saveDeliverAddress = "saveDeliverAddress";
  static String userDeliverAddress = "userDeliverAddress";
  static String userDeliverBuildingAddress = "userDeliverBuildingAddress";

  static String saveCurrentObjectAddress = "saveCurrentObjectAddress";
  static String saveCurrentAddress = "saveCurrentAddress";
  static String saveCurrentLat = "saveCurrentLat";
  static String saveCurrentLang = "saveCurrentLang";

  static String saveCard = "saveCard";

  static String deliveryOrder = "deliveryOrder";
  static String establishmentObject = "establishmentObject";
  static String cartObject = "cartObject";
  static String lastStatus = "lastStatus";
  static String paymentMethod = "paymentMethod";
  static String orderAmounts = "orderAmounts";
}
