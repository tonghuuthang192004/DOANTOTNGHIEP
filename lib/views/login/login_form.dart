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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _clearOldSession();
  }

  Future<void> _clearOldSession() async {
    print("🧹 [LoginPage] Đang xoá token và user cũ...");
    await UserToken.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("✅ Đã xoá sạch session cũ");
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final controller = LoginController();
    final result = await controller.login(email, password);

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chào ${result['user']['ten']}!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
            (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height10),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ),
          _buildTextField(Icons.email, 'Email', controller: _emailController),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            Icons.lock,
            'Mật khẩu',
            controller: _passwordController,
            obscureText: true,
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
                  ? const CircularProgressIndicator(color: Colors.white)
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
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(color: Colors.deepOrange),
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
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.deepOrange),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
