const String apiPath = "api";

class RequestConstantsEndpoints {
  static const String loginRequest = '$apiPath/auth/login';
  static const String registerRequest = '$apiPath/Register';
  static const String forgetPasswordRequest = '$apiPath/forgot-password';
  static const String changePassword = '$apiPath/auth/password/change';
  static const String home = '$apiPath/home';
  static const String orders = '$apiPath/orders/list';
  static const String finishedOrder = '$apiPath/orders/finished';
  static const String resetPassword = '$apiPath/reset-password';
  static const String otpRegister = '$apiPath/otp-register';
  static const String notifications = '$apiPath/notification/list';
  static const String addresses = '$apiPath/address/list';
  static const String addAddress = '$apiPath/address/add';
  static const String editAddress = '$apiPath/address/edit';
  static const String deleteAddress = '$apiPath/address/delete';
  static const String terms = '$apiPath/terms';
  static const String acceptTerms = '$apiPath/terms/accept';
  static const String logout = '$apiPath/logout';
  static const String deleteAccount = '$apiPath/delete/account';
  static const String cart ='$apiPath/products/list';
  static const String categories = '$apiPath/products/category-products';
  static const String categoryProducts = '$apiPath/products/list';
  static const String favorite = '$apiPath/favorite/list';
  static const String addFavorite = '$apiPath/favorite/toggle';
  static const String productDetails = '$apiPath/products/details';
  static const String addRate = '$apiPath/products/rate';
  static const String products = '$apiPath/products/list';
  static const String chats = '$apiPath/chats/list';
  static const String newChat = '$apiPath/chats/new';
  static const String sendMessage = '$apiPath/chats/message';
  static const String addOrder = '$apiPath/orders/add';
}
