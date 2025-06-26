import 'package:flutter/material.dart';
import '../../controllers/user/register_controller.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bottom_navigation_bar.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String matKhau;

  const VerifyEmailScreen(
      {super.key, required this.email, required this.matKhau});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _showMessage('Vui lòng nhập mã xác minh');
      return;
    }

    setState(() => _isLoading = true);

    await RegisterController.handleEmailVerification(context, widget.email,
        code, widget.matKhau, // 👈 truyền mật khẩu để đăng nhập tự động
        () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
        (route) => false,
      );
    });

    setState(() => _isLoading = false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
              'Mã xác minh đã được gửi đến ${widget.email}',
              style: TextStyle(fontSize: Dimensions.font16),
            ),
            SizedBox(height: Dimensions.height20),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Nhập mã xác minh',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: Dimensions.height20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _verify,
                    child: const Text('Xác minh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
