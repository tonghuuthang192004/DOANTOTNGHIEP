import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/dimensions.dart';

// Import class Dimensions đã tạo trước đó
// import 'dimensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize dimensions
    Dimensions.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3), // Background màu be/cream
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width25),
            child: Container(
              padding: EdgeInsets.all(Dimensions.width30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radius25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    SizedBox(height: Dimensions.height40),
                    _buildRegistrationForm(),
                    SizedBox(height: Dimensions.height30),
                    _buildSignUpButton(),
                    SizedBox(height: Dimensions.height25),
                    _buildLoginRedirect(),
                    SizedBox(height: Dimensions.height25),
                    _buildSocialLogin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: Dimensions.font26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF5722), // Orange color
          ),
        ),
        SizedBox(height: Dimensions.height12),
        Text(
          'Create an account so you can explore all the\nexisting jobs',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.font14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: Dimensions.height20),

        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Password',
          isVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: Dimensions.height20),

        _buildPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Confirm Password',
          isVisible: _isConfirmPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: Dimensions.font16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: Dimensions.font16,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: TextStyle(
        fontSize: Dimensions.font16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: Dimensions.font16,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
            size: Dimensions.iconSize20,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: Dimensions.height50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
          height: Dimensions.height20,
          width: Dimensions.width20,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(
          'Sign up',
          style: TextStyle(
            fontSize: Dimensions.font18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Text(
        'Already have an account',
        style: TextStyle(
          fontSize: Dimensions.font14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          'Or continue with',
          style: TextStyle(
            fontSize: Dimensions.font14,
            color: const Color(0xFFFF5722),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: Dimensions.height20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata,
              onPressed: () => _handleSocialLogin('Google'),
            ),
            SizedBox(width: Dimensions.width20),
            _buildSocialButton(
              icon: Icons.facebook,
              onPressed: () => _handleSocialLogin('Facebook'),
            ),
            SizedBox(width: Dimensions.width20),
            _buildSocialButton(
              icon: Icons.apple,
              onPressed: () => _handleSocialLogin('Apple'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: Dimensions.width50,
        height: Dimensions.height50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(
          icon,
          size: Dimensions.iconSize24,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate api call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically call your registration api
      // Example: await AuthService.register(userData);

      _showMessage('Account created successfully!', isSuccess: true);

      // Navigate to next screen or back to login
      Navigator.pop(context);

    } catch (e) {
      _showMessage('Failed to create account. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    try {
      // Simulate social login
      await Future.delayed(const Duration(seconds: 1));
      _showMessage('Signed up with $provider successfully!', isSuccess: true);
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Failed to sign up with $provider');
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
        ),
        margin: EdgeInsets.all(Dimensions.width15),
      ),
    );
  }
}

