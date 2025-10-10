import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/shared_prefs_constants/shared_prefs_constants.dart';

/// A class defined for save the data to shared preferences
class AppSettingsPrefs {
  final SharedPreferences _sharedPreferences;


  clear() {
    _sharedPreferences.clear();
  }

  AppSettingsPrefs(this._sharedPreferences);

  // Locale
  String getLocale() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.locale)
        .pareWithDefaultLocale();
  }

  Future<void> setLocale(String locale) async {
    await _sharedPreferences.setString(SharedPrefsConstants.locale, locale);
  }

  // Locale
  String getLocalString() {
    String locale = _sharedPreferences
        .getString(SharedPrefsConstants.locale)
        .pareWithDefaultLocale();
    if (locale == 'en') {
      return ManagerStrings.englishLanguage;
    } else {
      return ManagerStrings.arabicLanguage;
    }
  }

  // OutBoarding Screen Shared Preferences
  Future<void> setOutBoardingScreenViewed() async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.outBoardingViewed, true);
  }

  bool getOutBoardingScreenViewed() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.outBoardingViewed)
        .onNull();
  }

  Future<void> removeCachedUserData() async {
    await _sharedPreferences.remove(SharedPrefsConstants.isLoggedIn);
    await _sharedPreferences.remove(SharedPrefsConstants.email);
    await _sharedPreferences.remove(SharedPrefsConstants.token);
  }

  Future<void> setUserLoggedIn() async {
    await _sharedPreferences.setBool(SharedPrefsConstants.isLoggedIn, true);
  }

  bool getUserLoggedIn() {
    return _sharedPreferences.getBool(SharedPrefsConstants.isLoggedIn).onNull();
  }

  Future<void> setEmail(String email) async {
    await _sharedPreferences.setString(SharedPrefsConstants.email, email);
  }

  String getEmail() {
    return _sharedPreferences.getString(SharedPrefsConstants.email).onNull();
  }

  Future<void> setToken(String token) async {
    await _sharedPreferences.setString(SharedPrefsConstants.token, token);
  }

  String getToken() {
    return _sharedPreferences.getString(SharedPrefsConstants.token).onNull();
  }

  Future<void> setAppTheme(String theme) async {
    await _sharedPreferences.setString(SharedPrefsConstants.theme, theme);
  }

  String getAppTheme() {
    return _sharedPreferences.getString(SharedPrefsConstants.theme).toString();
  }

  void setUserName(String name) async {
    await _sharedPreferences.setString(SharedPrefsConstants.username, name);
  }

  String getUserName() {
    return _sharedPreferences.getString(SharedPrefsConstants.username).onNull();
  }

  void setContactPhone(String phone) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactPhone, phone);
  }

  String getContactPhone() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactPhone)
        .onNull();
  }

  void setContactEmail(String email) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactEmail, email);
  }

  String getContactEmail() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactEmail)
        .onNull();
  }

  void setContactLocation(String location) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactLocation, location);
  }

  String getContactLocation() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactLocation)
        .onNull();
  }

  void setContactFacebook(String icon) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactFacebook, icon);
  }

  String getContactFacebook() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactFacebook)
        .onNull();
  }

  void setContactTwitter(String icon) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactTwitter, icon);
  }

  String getContactTwitter() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactTwitter)
        .onNull();
  }

  void setContactInstagram(String icon) async {
    await _sharedPreferences.setString(
        SharedPrefsConstants.contactInstagram, icon);
  }

  String getContactInstagram() {
    return _sharedPreferences
        .getString(SharedPrefsConstants.contactInstagram)
        .onNull();
  }

  void setUserPhone(String phone) async {
    await _sharedPreferences.setString(SharedPrefsConstants.phone, phone);
  }

  void setUserAvatar(String avatar) async {
    await _sharedPreferences.setString(SharedPrefsConstants.avatar, avatar);
  }

  String getUserAvatar() {
    return _sharedPreferences.getString(SharedPrefsConstants.avatar).onNull();
  }

  String getUserPhone() {
    return _sharedPreferences.getString(SharedPrefsConstants.phone).onNull();
  }

  Future<void> setHasProfileData() async {
    await _sharedPreferences.setBool(SharedPrefsConstants.hasProfileData, true);
  }

  bool getHasProfileData() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.hasProfileData)
        .onNull();
  }

  Future<void> setEnableNotifications(bool status) async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.enableNotification, status);
  }

  bool getEnableNotifications() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.enableNotification)
        .onNotify();
  }

  Future<void> setEmailNotificationStatus(bool status) async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.emailNotification, status);
  }

  bool getEmailNotificationStatus() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.emailNotification)
        .onNotify();
  }

  Future<void> setTwoFactorAuthStatus(bool status) async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.twoFactorAuth, status);
  }

  bool getTwoFactorAuthStatus() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.twoFactorAuth)
        .onNotify();
  }

  Future<void> setBiometricAuthStatus(bool status) async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.biometricAuth, status);
  }

  bool getBiometricAuthStatus() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.biometricAuth)
        .onNotify();
  }

  Future<void> setSecurityQuestionsStatus(bool status) async {
    await _sharedPreferences.setBool(
        SharedPrefsConstants.securityQuestions, status);
  }

  bool getSecurityQuestionsStatus() {
    return _sharedPreferences
        .getBool(SharedPrefsConstants.securityQuestions)
        .onNotify();
  }

  Future<void> setCart(List<String> ids) async {
    await _sharedPreferences.setStringList(
      SharedPrefsConstants.cart,
      ids,
    );
  }
  Future<void> setCountry(String code) async {
    await _sharedPreferences.setString(SharedPrefsConstants.countryCode, code);
  }

  /// رجّع null إذا لسا ما انحفظت دولة
  String? getCountry() {
    return _sharedPreferences.getString(SharedPrefsConstants.countryCode);
  }

  Future<void> setCartItem(String id) async {
    List<String> cart = getCart();
    cart.add(
      id,
    );
    await _sharedPreferences.setStringList(
      SharedPrefsConstants.cart,
      cart,
    );
  }

  List<String> getCart() {
    return _sharedPreferences
        .getStringList(
          SharedPrefsConstants.cart,
        )
        .onNull();
  }
}
