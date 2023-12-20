import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();
  static SharedPreferences? sharedPreferences;
  SharedPreferences get instance =>
      sharedPreferences ?? (throw Exception("Not Initialized"));

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String read(String key) {
    try {
      return sharedPreferences?.getString(key) ?? "";
    } catch (e) {
      throw Exception('There is a problem in reading $key: $e');
    }
  }

  static Future<bool> write(String key, String value) async {
    try {
      log('Token:$value');
      return sharedPreferences!.setString(key, value);
    } catch (e) {
      throw Exception('There is a problem in writing $key: $e');
    }
  }
}
