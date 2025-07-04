import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  // 🔐 Lưu user mới vào SharedPreferences
  static Future<void> setUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
    print("✅ [UserSession] Lưu user: $user");
  }

  // 🔑 Lấy ID người dùng
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) {
      print("⚠️ Không tìm thấy user trong SharedPreferences");
      return null;
    }

    try {
      final user = jsonDecode(userJson);
      print("🧪 User từ SharedPreferences: $user");
      return user['id_nguoi_dung'] as int;
    } catch (e) {
      print("❌ Lỗi khi parse user ID: $e");
      return null;
    }
  }

  // 🧹 Xoá user khi logout
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("🧹 [UserSession] Đã xoá user khỏi SharedPreferences");
  }

  // 🐞 Debug session
  static Future<void> debugSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      print("🧪 Debug Session: $user");
    } else {
      print("⚠️ Không tìm thấy user trong session");
    }
  }
}
