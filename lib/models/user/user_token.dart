import 'package:shared_preferences/shared_preferences.dart';

class UserToken {
  static const String _keyToken = 'user_token';
  static const String _keyUserId = 'user_id'; // 🆕 thêm key userId

  // Lưu token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Lấy token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Xoá token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId); // 🧹 xóa luôn userId nếu đăng xuất
    print("🧹 Token và userId đã bị xoá khỏi SharedPreferences");
  }

  // 🆕 Lưu userId
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
  }

  // 🆕 Lấy userId
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }
}
