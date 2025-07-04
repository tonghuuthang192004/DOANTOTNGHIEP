import '../../models/user/user_token.dart';

class LogoutController {
  Future<void> logout() async {
    await UserToken.clearToken();
  }
}
