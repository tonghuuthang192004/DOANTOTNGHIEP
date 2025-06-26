import 'package:flutter/material.dart';

import '../../widgets/bottom_navigation_bar.dart';

class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ❤️ Animated heart icon
          TweenAnimationBuilder(
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFE0E0),
                        Color(0xFFFFF5F5),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8A65).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Color(0xFFFF8A65),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          const Text(
            'Chưa có sản phẩm yêu thích',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Hãy thêm những sản phẩm bạn yêu thích vào đây để dễ dàng tìm kiếm sau này',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A65), Color(0xFFFF7043)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8A65).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.explore, color: Colors.white),
              label: const Text(
                'Khám phá sản phẩm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
