import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _keyUser = 'user';
  static const String _keyToken = 'user_token';

  /// 🔐 Lưu user vào SharedPreferences
  static Future<void> setUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user));
    print("✅ [UserSession] Đã lưu user: $user");
  }

  /// 🔐 Lưu token riêng
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    print("✅ [UserSession] Token đã lưu: $token");
  }

  /// 🔑 Lấy user từ SharedPreferences
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);

    if (userJson == null) {
      print("⚠️ [UserSession] Không tìm thấy user");
      return null;
    }

    try {
      final user = jsonDecode(userJson) as Map<String, dynamic>;
      print("🧪 [UserSession] User: $user");
      return user;
    } catch (e) {
      print("❌ [UserSession] Lỗi parse user: $e");
      return null;
    }
  }

  /// 🔑 Lấy token từ SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    if (token != null && token.isNotEmpty) {
      print("🔑 [UserSession] Token lấy ra: $token");
      return token;
    }
    print("⚠️ [UserSession] Không tìm thấy token");
    return null;
  }

  /// 🆔 Lấy ID người dùng (tự check cả `id` và `id_nguoi_dung`)
  static Future<int?> getUserId() async {
    final user = await getUser();
    if (user == null) return null;

    final id = user['id'] ?? user['id_nguoi_dung'];
    if (id is int) {
      print("🔑 [UserSession] User ID: $id");
      return id;
    }

    print("⚠️ [UserSession] Không tìm thấy ID trong user");
    return null;
  }

  /// 🧹 Xoá user và token khỏi SharedPreferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.remove(_keyToken);
    print("🧹 [UserSession] Đã xoá user & token");
  }

  /// 🐞 Debug toàn bộ session
  static Future<void> debugSession() async {
    final user = await getUser();
    final token = await getToken();
    print("🐞 [UserSession] Debug User: $user");
    print("🐞 [UserSession] Debug Token: $token");
  }
}
