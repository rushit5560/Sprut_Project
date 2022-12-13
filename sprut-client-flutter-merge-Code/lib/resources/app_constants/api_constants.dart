class ApiConstants {
  /// [Sessions Apis]

  static String initSession = "/sessions";
  static String sessionConfig = "/sessions/confirmation";
  static String getCities = '/ukr/cities';

  //FOOD DELIVERY
  static String SelectedCity = "/ukrvin";

  static String getFoodCategory = '/ukrvin/delivery/categories';
  static String getByCategoryIdEstablishmentList = '/ukrvin/delivery/establishment';
  static String getAllEstablishmentList = '/ukrvin/delivery/establishments';
  static String getFoodTypesList = '/ukrvin/delivery/types';
  static String getProductList = '$SelectedCity/delivery/products';
  static String orderDelivery = '/order-delivery';
  static String orderStatusChecked = '/orders';
  static String orderActiveCounts = '$orderDelivery/activeCount';

  // https://fp-test.altertaxi.com.ua/v1/ukrvin/places/reverse?lat=23.0274709&lon=72.5246119


}
