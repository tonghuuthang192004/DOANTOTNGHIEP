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

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Center(child: Text('Đổi mật khẩu')),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSecurityNote(),
              SizedBox(height: Dimensions.height25),
              _buildPasswordForm(),
              SizedBox(height: Dimensions.height25),
              _buildPasswordTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue[600]),
          SizedBox(width: Dimensions.width12),
          Expanded(
            child: Text(
              'Mật khẩu mạnh gồm ít nhất 8 ký tự, có chữ hoa, chữ thường và số.',
              style: TextStyle(
                  color: Colors.blue[700], fontSize: Dimensions.font14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPasswordField(
            controller: _currentPasswordController,
            label: 'Mật khẩu hiện tại',
            isVisible: _showCurrentPassword,
            onToggleVisibility: () =>
                setState(() => _showCurrentPassword = !_showCurrentPassword),
            validator: (value) => value?.isEmpty == true
                ? 'Vui lòng nhập mật khẩu hiện tại'
                : null,
          ),
          SizedBox(height: Dimensions.height20),
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'Mật khẩu mới',
            isVisible: _showNewPassword,
            onToggleVisibility: () =>
                setState(() => _showNewPassword = !_showNewPassword),
            validator: (value) {
              if (value?.isEmpty == true) return 'Vui lòng nhập mật khẩu mới';
              if (value!.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                return 'Phải có chữ hoa, chữ thường và số';
              }
              return null;
            },
          ),
          SizedBox(height: Dimensions.height20),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Xác nhận mật khẩu mới',
            isVisible: _showConfirmPassword,
            onToggleVisibility: () =>
                setState(() => _showConfirmPassword = !_showConfirmPassword),
            validator: (value) {
              if (value?.isEmpty == true) return 'Vui lòng xác nhận mật khẩu';
              if (value != _newPasswordController.text)
                return 'Mật khẩu xác nhận không khớp';
              return null;
            },
          ),
          SizedBox(height: Dimensions.height30),
          SizedBox(
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
              child: Text(
                'Đổi mật khẩu',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildPasswordTips() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mẹo tạo mật khẩu mạnh:',
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: Dimensions.height12),
          _buildPasswordTip('Sử dụng ít nhất 8 ký tự'),
          _buildPasswordTip('Kết hợp chữ hoa và chữ thường'),
          _buildPasswordTip('Bao gồm số và ký tự đặc biệt'),
          _buildPasswordTip('Không dùng thông tin cá nhân'),
          _buildPasswordTip('Không lặp lại mật khẩu cũ'),
        ],
      ),
    );
  }

  Widget _buildPasswordTip(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
      child: Row(
        children: [
          Icon(Icons.check_circle,
              color: Colors.green[400], size: Dimensions.iconSize16),
          SizedBox(width: Dimensions.width8),
          Text(tip,
              style: TextStyle(
                  color: Colors.grey[600], fontSize: Dimensions.font14)),
        ],
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius12)),
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
              child:
                  const Text('Xác nhận', style: TextStyle(color: Colors.white)),
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

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Đổi mật khẩu thành công!'),
                backgroundColor: Colors.green),
          );

          // ✅ Xoá token và chuyển về LoginPage
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');

          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Đổi mật khẩu thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
