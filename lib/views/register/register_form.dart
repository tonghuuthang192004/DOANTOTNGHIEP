import 'package:flutter/material.dart';
import '../../controllers/user/register_controller.dart';
import '../../models/user/user_model.dart';
import '../../utils/dimensions.dart';
import '../login/login_screen.dart';
import 'VerifyEmailScreen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _xacNhanMatKhauController = TextEditingController();
  final _soDienThoaiController = TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _tenController.dispose();
    _emailController.dispose();
    _matKhauController.dispose();
    _xacNhanMatKhauController.dispose();
    _soDienThoaiController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_matKhauController.text != _xacNhanMatKhauController.text) {
      _showMessage('⚠️ Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    final user = UserModel(
      ten: _tenController.text.trim(),
      email: _emailController.text.trim(),
      matKhau: _matKhauController.text,
      soDienThoai: _soDienThoaiController.text.trim(),
    );

    await RegisterController.handleRegister(
      context,
      user,
          () {
        _clearForm();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              email: user.email,
              matKhau: user.matKhau,
            ),
          ),
        );
      },
    );

    setState(() => _isLoading = false);
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _tenController.clear();
    _emailController.clear();
    _matKhauController.clear();
    _xacNhanMatKhauController.clear();
    _soDienThoaiController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimensions.width20),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
              'Họ tên', _tenController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '⚠️ Họ tên không được để trống';
                return null;
              },
            ),
            SizedBox(height: Dimensions.height20),
            _buildField(
              'Email',
              _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '⚠️ Vui lòng nhập email';
                final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                if (!emailRegex.hasMatch(value)) return '⚠️ Email không hợp lệ';
                return null;
              },
            ),
            SizedBox(height: Dimensions.height20),
            _buildField(
              'Số điện thoại',
              _soDienThoaiController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '⚠️ Vui lòng nhập số điện thoại';
                if (!RegExp(r'^0\d{9}$').hasMatch(value)) return '⚠️ Số điện thoại phải đủ 10 số và bắt đầu bằng 0';
                return null;
              },
            ),
            SizedBox(height: Dimensions.height20),
            _buildPasswordField('Mật khẩu', _matKhauController, _passwordVisible, () {
              setState(() => _passwordVisible = !_passwordVisible);
            }),
            SizedBox(height: Dimensions.height20),
            _buildPasswordField('Xác nhận mật khẩu', _xacNhanMatKhauController, _confirmVisible, () {
              setState(() => _confirmVisible = !_confirmVisible);
            }),
            SizedBox(height: Dimensions.height25),
            SizedBox(
              width: double.infinity,
              height: Dimensions.height50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                  ),
                ),
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Text('Đăng ký', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Bạn đã có tài khoản? Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ??
              (value) => (value == null || value.isEmpty) ? '⚠️ Vui lòng nhập $label' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool visible, VoidCallback toggle) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: (value) {
        if (value == null || value.isEmpty) return '⚠️ Vui lòng nhập $label';
        final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
        if (!passwordRegex.hasMatch(value)) {
          return '⚠️ Mật khẩu phải >=8 ký tự, gồm chữ hoa, chữ thường, số, ký tự đặc biệt';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height15,
        ),
      ),
    );
  }
}
