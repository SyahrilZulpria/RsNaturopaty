class Endpoint {
  static String ip = 'https://api.rsnaturopaty.com/';

  /// API Login, LogOut & Registration Customer
  static String login = '${ip}customer/login';
  static String logout = '${ip}customer/logout';
  static String registrasi = '${ip}customer/add';
  static String otp = '${ip}customer/req_otp';
  static String verifyAccount = '${ip}customer/verify/';
  // API verify customer/verify/19/2522 => 19=id , 2522 = otp
  static String forgotPass = '${ip}customer/forgot';
  static String logOut = '${ip}customer/logout';

  /// API Article

  /// API POS

  /// API ORDER

  /// API REDEEM

  /// API Product

  /// API ImageSlider
  static String imgSlider = '${ip}slider';

  /// API City & Bank
  static String city = '${ip}city/get_city_rj';
  static String bankList = '${ip}banklist';
}
