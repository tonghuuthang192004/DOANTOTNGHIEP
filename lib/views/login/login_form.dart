import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/user/login_controller.dart';
import '../../utils/dimensions.dart';
import '../forgot_password/forgot_password.dart';
import '../register/register_screen.dart';
import '../../widgets/bottom_navigation_bar.dart'; // MainNavigation
import '../../models/user/user_token.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _clearOldSession();
  }

  Future<void> _clearOldSession() async {
    print("🧹 Đang xoá token và user cũ...");
    await UserToken.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("✅ Đã xoá session cũ");
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus(); // Ẩn bàn phím

    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      setState(() => _emailError = '⚠️ Vui lòng nhập email');
      return;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = '⚠️ Email không hợp lệ');
      return;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = '⚠️ Vui lòng nhập mật khẩu');
      return;
    }

    setState(() => _isLoading = true);

    final controller = LoginController();
    final result = await controller.login(email, password);

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Chào ${result['user']['ten']}!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
      );
    } else {
      // 👇 Phân loại lỗi từ API
      final errorMsg = result['message']?.toLowerCase() ?? '';
      if (errorMsg.contains('email')) {
        setState(() => _emailError = '⚠️ Email không tồn tại');
      } else if (errorMsg.contains('mật khẩu') || errorMsg.contains('password')) {
        setState(() => _passwordError = '⚠️ Mật khẩu không đúng');
      } else {
        setState(() => _generalError = result['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_generalError != null)
            Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height10),
              child: Text(
                _generalError!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          _buildTextField(
            Icons.email,
            'Email',
            controller: _emailController,
            errorText: _emailError,
          ),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            Icons.lock,
            'Mật khẩu',
            controller: _passwordController,
            obscureText: true,
            errorText: _passwordError,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                'Quên mật khẩu?',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),
          SizedBox(
            width: double.infinity,
            height: Dimensions.height50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
              ),
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Chưa có tài khoản? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      IconData icon,
      String hintText, {
        bool obscureText = false,
        TextEditingController? controller,
        String? errorText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText ? _obscurePassword : false,
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.deepOrange),
              border: InputBorder.none,
              hintText: hintText,
              suffixIcon: obscureText
                  ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
                  : null,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: Dimensions.height5, left: Dimensions.width5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
