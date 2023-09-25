import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoecollect/auth/data/model/verification_routing.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
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

  static saveVerificationData(VerificationParams? data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (data == null)
      sharedPreferences.setString('verification_data', "");
    else
      sharedPreferences.setString('verification_data', jsonEncode(data.toJson()));
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

  static saveAllUserInfo(AppUser userInfo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user = jsonEncode(userInfo.toJson());
    sharedPreferences.setString('user_info', user);
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

  Future<VerificationParams?> getVerificationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? res = sharedPreferences.getString('verification_data');
    if (res == null || res == "") return null;
    return VerificationParams.fromJson(json.decode(res));
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

  static Future<bool> logOutUser() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.signOut();
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      logError(["logOutUser", e]);
      return false;
    }
  }

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
    return user.uid;
  }
}
