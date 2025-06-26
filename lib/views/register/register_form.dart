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
      _showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    final user = UserModel(
      ten: _tenController.text,
      email: _emailController.text,
      matKhau: _matKhauController.text,
      soDienThoai: _soDienThoaiController.text,
    );

    await RegisterController.handleRegister(
      context,
      user,
          () {
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
          _buildField('Email', _emailController, keyboardType: TextInputType.emailAddress),
          SizedBox(height: Dimensions.height20),
          _buildField('Số điện thoại', _soDienThoaiController, keyboardType: TextInputType.phone),
          SizedBox(height: Dimensions.height20),
          _buildPasswordField('Mật khẩu', _matKhauController, _passwordVisible, () {
            setState(() => _passwordVisible = !_passwordVisible);
          }),
          SizedBox(height: Dimensions.height20),
          _buildPasswordField('Xác nhận mật khẩu', _xacNhanMatKhauController, _confirmVisible, () {
            setState(() => _confirmVisible = !_confirmVisible);
          }),
          SizedBox(height: Dimensions.height25),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5722),
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height15,
                horizontal: Dimensions.width30,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
            ),
            child: Text('Đăng ký', style: TextStyle(fontSize: Dimensions.font16)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập $label' : null,
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
      validator: (value) => (value == null || value.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
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
