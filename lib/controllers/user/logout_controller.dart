import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/user_token.dart';

class LogoutController {
  Future<void> logout() async {
    // 🧹 Xoá token
    await UserToken.clearToken();

    // 🧹 Xoá thông tin user
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    print('✅ Đã logout: xoá token và thông tin user');
  }
}
