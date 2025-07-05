import 'package:flutter/material.dart';
import '../../controllers/user/register_controller.dart';
import '../../models/user/user_model.dart';
import '../../utils/dimensions.dart';
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
        Navigator.push(
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildField('Họ tên', _tenController),
          SizedBox(height: Dimensions.height20),
          _buildField(
            'Email',
            _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập Email';
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';
              return null;
            },
          ),
          SizedBox(height: Dimensions.height20),
          _buildField(
            'Số điện thoại',
            _soDienThoaiController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
              if (!RegExp(r'^\d{10,11}$').hasMatch(value)) return 'Số điện thoại không hợp lệ';
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
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ??
              (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập $label' : null,
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
        if (value == null || value.length < 6) {
          return 'Mật khẩu tối thiểu 6 ký tự';
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
