import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) return null;

    final user = jsonDecode(userJson);
    return user['id'].toString(); // hoặc 'userId' tuỳ theo backend
  }
}
