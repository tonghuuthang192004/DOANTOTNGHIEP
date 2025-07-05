import 'package:flutter/material.dart';
import '../../controllers/user/register_controller.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String matKhau;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.matKhau,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _resendLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty || code.length != 6) {
      _showMessage('⚠️ Mã xác minh phải có 6 chữ số');
      return;
    }

    setState(() => _isLoading = true);

    print('📧 Email: ${widget.email}');
    print('🔑 Password: ${widget.matKhau}');
    await RegisterController.handleEmailVerification(
      context,
      widget.email,
      code,
      widget.matKhau,
          () {
        Future.microtask(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigation()),
                (route) => false,
          );
        });
      },
    );


    setState(() => _isLoading = false);
  }

  Future<void> _resendCode() async {
    setState(() => _resendLoading = true);
    // 🔥 Gọi API resend tại đây (nếu có)
    await Future.delayed(const Duration(seconds: 2)); // giả lập
    _showMessage('📩 Mã xác minh mới đã được gửi');
    setState(() => _resendLoading = false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh Email'),
        backgroundColor: const Color(0xFFFF5722),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔐 Mã xác minh đã gửi đến ${widget.email}',
              style: TextStyle(fontSize: Dimensions.font16),
            ),
            SizedBox(height: Dimensions.height20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Nhập mã xác minh',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            SizedBox(
              width: double.infinity,
              height: Dimensions.height50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Text('Xác minh',
                        style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Center(
              child: _resendLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : TextButton(
                      onPressed: _resendCode,
                      child: const Text('Gửi lại mã',
                          style: TextStyle(color: Colors.deepOrange)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
