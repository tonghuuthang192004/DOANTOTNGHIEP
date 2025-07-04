import 'package:flutter/material.dart';
import '../../widgets/bottom_navigation_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashLogic();
  }

  Future<void> _startSplashLogic() async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Nền ảnh mờ
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'images/fried_chicken.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Nội dung chính
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/fried_chicken.png',
                    height: screenHeight * 0.3,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Your Food Now!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Get hot & fresh food delivered to your door in minutes!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
