import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/user/change_password_controller.dart';
import '../../utils/dimensions.dart';
import '../login/login_screen.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _visibility = {'current': false, 'new': false, 'confirm': false};

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _securityNote(),
              SizedBox(height: Dimensions.height20),
              _passwordField(_currentPasswordController, 'Mật khẩu hiện tại', 'current',
                  validator: (v) =>
                  v!.isEmpty ? 'Vui lòng nhập mật khẩu hiện tại' : null),
              SizedBox(height: Dimensions.height15),
              _passwordField(_newPasswordController, 'Mật khẩu mới', 'new',
                  validator: _validateNewPassword),
              SizedBox(height: Dimensions.height15),
              _passwordField(_confirmPasswordController, 'Xác nhận mật khẩu mới', 'confirm',
                  validator: (v) {
                    if (v!.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                    if (v != _newPasswordController.text) return 'Mật khẩu không khớp';
                    return null;
                  }),
              SizedBox(height: Dimensions.height25),
              _changePasswordButton(),
              SizedBox(height: Dimensions.height20),
              _passwordTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _securityNote() {
    return _infoBox(
      icon: Icons.info,
      color: Colors.blue,
      text: 'Mật khẩu mạnh gồm ít nhất 8 ký tự, có chữ hoa, chữ thường và số.',
    );
  }

  Widget _passwordTips() {
    return _infoBox(
      icon: Icons.lock,
      color: Colors.grey,
      title: 'Mẹo tạo mật khẩu mạnh:',
      tips: [
        'Sử dụng ít nhất 8 ký tự',
        'Kết hợp chữ hoa và chữ thường',
        'Bao gồm số và ký tự đặc biệt',
        'Không dùng thông tin cá nhân',
        'Không lặp lại mật khẩu cũ',
      ],
    );
  }

  Widget _infoBox({
    required IconData icon,
    required Color color,
    String? text,
    String? title,
    List<String>? tips,
  }) {
    return Container(
      padding: EdgeInsets.all(Dimensions.height15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: Dimensions.width8),
              Expanded(
                child: Text(
                  text ?? title ?? '',
                  style: TextStyle(color: color, fontSize: Dimensions.font14),
                ),
              ),
            ],
          ),
          if (tips != null)
            ...tips.map((tip) => Padding(
              padding: EdgeInsets.only(top: Dimensions.height8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: Dimensions.iconSize16),
                  SizedBox(width: Dimensions.width8),
                  Expanded(
                    child: Text(tip,
                        style: TextStyle(color: Colors.grey[700], fontSize: Dimensions.font14)),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController controller, String label, String key,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: !_visibility[key]!,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
        suffixIcon: IconButton(
          icon: Icon(_visibility[key]! ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _visibility[key] = !_visibility[key]!),
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _changePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
        ),
        child: const Text('Đổi mật khẩu',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  String? _validateNewPassword(String? value) {
    if (value!.isEmpty) return 'Vui lòng nhập mật khẩu mới';
    if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Phải có chữ hoa, chữ thường và số';
    }
    return null;
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Xác nhận đổi mật khẩu'),
          content: const Text('Bạn có chắc chắn muốn đổi mật khẩu không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final controller = ChangePasswordController();
        final result = await controller.changePassword(
          oldPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        if (!mounted) return;

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Đổi mật khẩu thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? '❌ Đổi mật khẩu thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
