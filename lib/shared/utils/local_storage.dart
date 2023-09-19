import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoecollect/models/account/user_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

class LocalPreferences {
  // ** -----------------------------**//
  // ** Saved Preferences **//
  // ** -----------------------------**//

  static saveInit(bool init) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    logI(["save init", init]);
    return sharedPreferences.setBool('init', init);
  }

  static saveNotificationToken(String n_token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    logI(["save n_token", n_token]);
    List<String>? all_notification_tokens = await sharedPreferences.getStringList('n_tokens');
    if (all_notification_tokens == null)
      sharedPreferences.setStringList('n_tokens', [n_token]);
    else
      sharedPreferences.setStringList('n_tokens', [...all_notification_tokens, n_token]);
  }

  static resetNotificationToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('n_tokens', []);
  }

  static saveAllUserInfo(String userInfo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('user_info', userInfo);
  }

  static saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
  }

  static savePin(String pin) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('pin', pin);
    logI(["save pin", pin]);
  }

  static void saveThemePreset(String preset) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('preset', preset);
  }

  // ** -----------------------------**//
  // ** Get Preferences **//
  // ** -----------------------------**//

  static Future<bool> getInit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final isInit = sharedPreferences.getBool('init');
    return isInit == null ? false : true;
  }

  static Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if (token == null || token == "") return null;
    return token;
  }

  static Future<List<String>> getNotificationTokens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? n_tokens = await sharedPreferences.getStringList('n_tokens');
    return n_tokens == null ? [] : n_tokens;
  }

  static Future<String?> getPin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? pin = sharedPreferences.getString('pin');
    return pin;
  }

  // static Future<bool> logOutUser() async {
  //   try {
  //     await FirebaseMessaging.instance.deleteToken();
  //     await saveAllUserInfo("");
  //     await saveToken('');
  //     await resetNotificationToken();
  //     return true;
  //   } catch (e) {
  //     logError(["logOutUser", e]);
  //     return false;
  //   }
  // }

  static Future<AppUser?> getAllUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? res = await sharedPreferences.getString('user_info');
    if (res == null || res == "") return null;
    AppUser user = AppUser.fromJson(json.decode(res));
    return user;
  }

  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? res = await sharedPreferences.getString('user_info');
    if (res == null || res == "") return null;
    AppUser user = AppUser.fromJson(json.decode(res));
    return user.uuid;
  }
}