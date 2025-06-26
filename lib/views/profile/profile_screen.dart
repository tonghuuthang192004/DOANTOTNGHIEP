import 'package:flutter/material.dart';

import '../order_history_page/OrderHistoryPage_Screen.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Bạn đã chọn: $action'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar với gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Trang cá nhân',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange,
                      Colors.red,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Card với animation và gradient
                  // Container(
                  //   padding: const EdgeInsets.all(24),
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //       colors: [Colors.white, Color(0xFFFFF8F5)],
                  //     ),
                  //     borderRadius: BorderRadius.circular(24),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.orange.withOpacity(0.1),
                  //         blurRadius: 20,
                  //         offset: const Offset(0, 8),
                  //         spreadRadius: 2,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       // Avatar với border gradient
                  //       // Container(
                  //       //   padding: const EdgeInsets.all(4),
                  //       //   decoration: BoxDecoration(
                  //       //     shape: BoxShape.circle,
                  //       //     gradient: const LinearGradient(
                  //       //       colors: [Color(0xFFFF8A65), Color(0xFFFF5722)],
                  //       //     ),
                  //       //   ),
                  //       //   child: Container(
                  //       //     padding: const EdgeInsets.all(3),
                  //       //     decoration: const BoxDecoration(
                  //       //       color: Colors.white,
                  //       //       shape: BoxShape.circle,
                  //       //     ),
                  //       //     child: const CircleAvatar(
                  //       //       radius: 45,
                  //       //       backgroundImage: AssetImage('images/user_avatar.png'),
                  //       //       backgroundColor: Color(0xFFF5F5F5),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       const SizedBox(height: 16),
                  //       // const Text(
                  //       //   'Nguyễn Văn A',
                  //       //   style: TextStyle(
                  //       //     fontWeight: FontWeight.bold,
                  //       //     fontSize: 24,
                  //       //     color: Color(0xFF2D3748),
                  //       //   ),
                  //       // ),
                  //       // const SizedBox(height: 8),
                  //       // Container(
                  //       //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //       //   decoration: BoxDecoration(
                  //       //     color: Colors.orange.withOpacity(0.1),
                  //       //     borderRadius: BorderRadius.circular(20),
                  //       //   ),
                  //       //   child: Text(
                  //       //     'nguyenvana@gmail.com',
                  //       //     style: TextStyle(
                  //       //       color: Colors.orange[700],
                  //       //       fontSize: 14,
                  //       //       fontWeight: FontWeight.w500,
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       const SizedBox(height: 16),
                  //       // Status badge
                  //       // ss,
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 30),

                  // Menu sections
                  _buildMenuSection(
                    title: 'Quản lý tài khoản',
                    items: [
                      _MenuItemData(
                        icon: Icons.history_rounded,
                        title: 'Lịch sử đơn hàng',
                        subtitle: 'Xem các đơn hàng đã đặt',
                        color: Colors.blue,
                        onTap: () => _navigateTo(context, const OrderHistoryPage()),
                      ),
                      _MenuItemData(
                        icon: Icons.edit_rounded,
                        title: 'Cập nhật thông tin',
                        subtitle: 'Chỉnh sửa thông tin cá nhân',
                        color: Colors.green,
                        onTap: () => _navigateTo(context, const UpdateProfilePage()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildMenuSection(
                    title: 'Bảo mật',
                    items: [
                      _MenuItemData(
                        icon: Icons.lock_rounded,
                        title: 'Đổi mật khẩu',
                        subtitle: 'Cập nhật mật khẩu bảo mật',
                        color: Colors.purple,
                        onTap: () => _navigateTo(context, const ChangePasswordPage()),
                      ),
                      _MenuItemData(
                        icon: Icons.location_on_rounded,
                        title: 'Thay đổi địa chỉ',
                        subtitle: 'Quản lý địa chỉ giao hàng',
                        color: Colors.amber,
                        onTap: () => _navigateTo(context, const AddressManagementPage()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Logout button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _onTap(context, 'Đăng xuất'),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: Colors.red[600],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đăng xuất',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Thoát khỏi tài khoản',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.red[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItemData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) => _buildMenuItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItemData item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}