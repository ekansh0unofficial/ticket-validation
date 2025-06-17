import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String USER_TYPE = "user_type";
  static const String AUTH_TOKEN = "auth_token";

  static Future<void> setAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AUTH_TOKEN, token);
  }

  static Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN) ?? "";
  }

  static Future<void> setUserType(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_TYPE, userType);
  }

  static Future<String?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_TYPE);
  }
}
