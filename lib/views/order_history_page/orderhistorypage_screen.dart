import 'package:flutter/material.dart';
import 'package:frontendtn1/views/order_history_page/product_review_screen.dart';
import '../../services/user/user_session.dart';
import '../../utils/dimensions.dart';
import '../../models/order/order_model.dart';
import '../../services/order/order_service.dart';
import 'order_detail_screen.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final List<String> filters = [
    'Tất Cả',
    'Đang xử lý',
    'Xác nhận',
    'Đang chuẩn bị hàng',
    'Đang giao',
    'Đã giao',
    'Đã hủy',
  ];

  List<OrderModel> orders = [];
  bool isLoading = false;
  String selectedFilter = 'Tất Cả'; // Default filter set to "Tất Cả" (All)
  late int userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndOrders();
  }

  Future<void> _loadUserAndOrders() async {
    setState(() => isLoading = true);
    try {
      userId = await UserSession.getUserId() ?? 0;
      if (userId == 0) {
        _showSnackBar('⚠️ User ID not found! Please log in.');
        return;
      }
      await _loadOrders();
    } catch (e) {
      debugPrint('❌ Error while loading user or orders: $e');
      _showSnackBar('⚠️ Could not load user data or orders');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadOrders() async {
    setState(() => isLoading = true);
    try {
      debugPrint(
          'Loading orders for userId: $userId with filter: $selectedFilter');
      final fetched = await OrderService.fetchOrders(
        trang_thai: selectedFilter,
        userId: userId,
      );
      debugPrint('Fetched Orders: $fetched');
      setState(() => orders = fetched);
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
      _showSnackBar('⚠️ Unable to load order history');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _navigateToDetail(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
    );
  }

  void _navigateToReview(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductReviewPage(orderId: orderId)),
    );
  }

  Future<void> _cancelOrder(int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('Huỷ đơn hàng?'),
            content: const Text(
                'Bạn có chắc chắn muốn huỷ đơn hàng này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false),
                  child: const Text('Không')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true),
                  child: const Text('Huỷ')),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await OrderService.cancelOrder(orderId);
      if (success) {
        _showSnackBar('✅ Huỷ đơn thành công', color: Colors.green);
        _loadOrders();
      } else {
        _showSnackBar('❌ Huỷ đơn thất bại', color: Colors.red);
      }
    }
  }

  Future<void> _reorder(int orderId) async {
    final success = await OrderService.reorder(orderId);
    if (success) {
      _showSnackBar(
          '🛒 Các sản phẩm đã được thêm lại giỏ hàng', color: Colors.green);
    } else {
      _showSnackBar('❌ Mua lại thất bại', color: Colors.red);
    }
  }

  bool _canCancel(String status) {
    return ['Chờ xác nhận', 'Đang chuẩn bị', 'Đang giao hàng'].contains(status);
  }

  (Color, IconData) _getStatusStyle(String status) {
    final Map<String, (Color, IconData)> statusMap = {
      'Đã giao': (Colors.green, Icons.check_circle),
      'Đang giao': (Colors.blue, Icons.local_shipping),
      'Đang chuẩn bị hàng': (Colors.deepOrange, Icons.kitchen),
      'Xác nhận': (Colors.orange, Icons.access_time),
      'Đã hủy': (Colors.red, Icons.cancel),
    };
    return statusMap[status] ?? (Colors.grey, Icons.help_outline);
  }

  // The function to build filter buttons
  Widget _buildFilterButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height8),
      height: Dimensions.height50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: Dimensions.width8),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            selectedColor: Colors.orange.shade200,
            backgroundColor: Colors.grey.shade300,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            onSelected: (_) {
              setState(() {
                selectedFilter = filter; // Update filter
              });
              _loadOrders(); // Reload orders with the new filter
            },
          );
        },
      ),
    );
  }

  // Function to build the order card
  Widget _buildOrderCard(OrderModel order) {
    final (statusColor, statusIcon) = _getStatusStyle(order.status);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderCode,
                  style: TextStyle(
                      fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        order.status,
                        style: TextStyle(
                            color: statusColor, fontSize: Dimensions.font14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height8),
            // Date & Total
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14,
                    color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(order.formattedDate,
                    style: TextStyle(fontSize: Dimensions.font14)),
                const Spacer(),
                Text(
                  'Tổng: ${order.formattedPrice}đ',
                  style: TextStyle(color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font14),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  onPressed: () => _navigateToDetail(order.id),
                  icon: Icons.visibility,
                  label: 'Chi tiết',
                  color: Colors.blue,
                ),
                if (_canCancel(order.status))
                  _buildActionButton(
                    onPressed: () => _cancelOrder(order.id),
                    icon: Icons.cancel,
                    label: 'Huỷ',
                    color: Colors.red,
                  ),
                if (order.status == 'Hoàn Thành') ...[
                  // Use the correct order status
                  _buildActionButton(
                    onPressed: () => _reorder(order.id),
                    icon: Icons.shopping_cart,
                    label: 'Mua lại',
                    color: Colors.green,
                  ),
                  _buildActionButton(
                    onPressed: () => _navigateToReview(order.id),
                    icon: Icons.star,
                    label: 'Đánh giá',
                    color: Colors.orange,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }

  // Retry Button for Errors
  Widget _buildRetryButton() {
    return TextButton(
      onPressed: _loadOrders,
      child: const Text('Thử lại'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📦 Không có đơn hàng nào'),
                _buildRetryButton(),
              ],
            )
                : ListView.builder(
              padding: EdgeInsets.all(Dimensions.width15),
              itemCount: orders.length,
              itemBuilder: (_, index) => _buildOrderCard(orders[index]),
            ),
          ),
        ],
      ),
    );
  }
}
// }
// import 'package:flutter/material.dart';
// import 'package:frontendtn1/views/order_history_page/product_review_screen.dart';
// import '../../services/user/user_session.dart';
// import '../../utils/dimensions.dart';
// import '../../models/order/order_model.dart';
// import '../../services/order/order_service.dart';
// import 'order_detail_screen.dart';
//
// class OrderHistoryPage extends StatefulWidget {
//   const OrderHistoryPage({super.key});
//
//   @override
//   State<OrderHistoryPage> createState() => _OrderHistoryPageState();
// }
//
// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   final List<String> filters = [
//     'Tất Cả',
//     'Đang xử lý',
//     'Xác nhận',
//     'Đang chuẩn bị hàng',
//     'Đang giao',
//     'Đã giao',
//     'Đã hủy',
//   ];
//
//   List<OrderModel> orders = [];
//   bool isLoading = false;
//   String selectedFilter = 'Tất Cả'; // Default filter set to "Tất Cả" (All)
//   late int userId;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserAndOrders();
//   }
//
//   Future<void> _loadUserAndOrders() async {
//     setState(() => isLoading = true);
//     try {
//       userId = await UserSession.getUserId() ?? 0;
//       if (userId == 0) {
//         _showSnackBar('⚠️ User ID not found! Please log in.');
//         return;
//       }
//       await _loadOrders();
//     } catch (e) {
//       debugPrint('❌ Error while loading user or orders: $e');
//       _showSnackBar('⚠️ Could not load user data or orders');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _loadOrders() async {
//     setState(() => isLoading = true);
//     try {
//       debugPrint('Loading orders for userId: $userId with filter: $selectedFilter');
//       final fetched = await OrderService.fetchOrders(
//         trang_thai: selectedFilter,
//         userId: userId,
//       );
//       debugPrint('Fetched Orders: $fetched');
//       setState(() => orders = fetched);
//     } catch (e) {
//       debugPrint('❌ Error loading orders: $e');
//       _showSnackBar('⚠️ Unable to load order history');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _showSnackBar(String message, {Color? color}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }
//
//   void _navigateToDetail(int orderId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
//     );
//   }
//
//   void _navigateToReview(int orderId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => ProductReviewPage(orderId: orderId)),
//     );
//   }
//
//   Future<void> _cancelOrder(int orderId) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Huỷ đơn hàng?'),
//         content: const Text('Bạn có chắc chắn muốn huỷ đơn hàng này không?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
//           ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Huỷ')),
//         ],
//       ),
//     );
//
//     if (confirmed == true) {
//       final success = await OrderService.cancelOrder(orderId);
//       if (success) {
//         _showSnackBar('✅ Huỷ đơn thành công', color: Colors.green);
//         _loadOrders();
//       } else {
//         _showSnackBar('❌ Huỷ đơn thất bại', color: Colors.red);
//       }
//     }
//   }
//
//   Future<void> _reorder(int orderId) async {
//     final success = await OrderService.reorder(orderId);
//     if (success) {
//       _showSnackBar('🛒 Các sản phẩm đã được thêm lại giỏ hàng', color: Colors.green);
//     } else {
//       _showSnackBar('❌ Mua lại thất bại', color: Colors.red);
//     }
//   }
//
//   bool _canCancel(String status) {
//     return ['Chờ xác nhận', 'Đang chuẩn bị', 'Đang giao hàng'].contains(status);
//   }
//
//   (Color, IconData) _getStatusStyle(String status) {
//     final Map<String, (Color, IconData)> statusMap = {
//       'Đã giao': (Colors.green, Icons.check_circle),
//       'Đang giao': (Colors.blue, Icons.local_shipping),
//       'Đang chuẩn bị hàng': (Colors.deepOrange, Icons.kitchen),
//       'Xác nhận': (Colors.orange, Icons.access_time),
//       'Đã hủy': (Colors.red, Icons.cancel),
//     };
//     return statusMap[status] ?? (Colors.grey, Icons.help_outline);
//   }
//
//   // The function to build filter buttons
//   Widget _buildFilterButtons() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: EdgeInsets.symmetric(vertical: Dimensions.height8, horizontal: Dimensions.width10),
//       child: Row(
//         children: filters.map((filter) {
//           final isSelected = selectedFilter == filter;
//           return Padding(
//             padding: EdgeInsets.only(right: Dimensions.width8),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSelected ? Colors.orange : Colors.grey.shade300,
//                 foregroundColor: isSelected ? Colors.white : Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.radius20),
//                 ),
//               ),
//               onPressed: () {
//                 if (!isSelected) {
//                   setState(() {
//                     selectedFilter = filter;
//                   });
//                   _loadOrders();
//                 }
//               },
//               child: Text(filter),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//
//   // Function to build the order card
//   Widget _buildOrderCard(OrderModel order) {
//     final (statusColor, statusIcon) = _getStatusStyle(order.status);
//
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Dimensions.radius12),
//       ),
//       margin: EdgeInsets.only(bottom: Dimensions.height12),
//       elevation: 3,
//       child: Padding(
//         padding: EdgeInsets.all(Dimensions.width12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   order.orderCode,
//                   style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(Dimensions.radius20),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(statusIcon, size: 16, color: statusColor),
//                       const SizedBox(width: 4),
//                       Text(
//                         order.status,
//                         style: TextStyle(color: statusColor, fontSize: Dimensions.font14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.height8),
//             // Date & Total
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
//                 const SizedBox(width: 6),
//                 Text(order.formattedDate, style: TextStyle(fontSize: Dimensions.font14)),
//                 const Spacer(),
//                 Text(
//                   'Tổng: ${order.formattedPrice}đ',
//                   style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: Dimensions.font14),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.height10),
//             // Actions
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 _buildActionButton(
//                   onPressed: () => _navigateToDetail(order.id),
//                   icon: Icons.visibility,
//                   label: 'Chi tiết',
//                   color: Colors.blue,
//                 ),
//                 if (_canCancel(order.status))
//                   _buildActionButton(
//                     onPressed: () => _cancelOrder(order.id),
//                     icon: Icons.cancel,
//                     label: 'Huỷ',
//                     color: Colors.red,
//                   ),
//                 if (order.status == 'Hoàn Thành') ...[  // Use the correct order status
//                   _buildActionButton(
//                     onPressed: () => _reorder(order.id),
//                     icon: Icons.shopping_cart,
//                     label: 'Mua lại',
//                     color: Colors.green,
//                   ),
//                   _buildActionButton(
//                     onPressed: () => _navigateToReview(order.id),
//                     icon: Icons.star,
//                     label: 'Đánh giá',
//                     color: Colors.orange,
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required VoidCallback onPressed,
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return TextButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon, color: color),
//       label: Text(label, style: TextStyle(color: color)),
//     );
//   }
//
//   // Retry Button for Errors
//   Widget _buildRetryButton() {
//     return TextButton(
//       onPressed: _loadOrders,
//       child: const Text('Thử lại'),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Dimensions.init(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lịch sử đơn hàng'),
//         backgroundColor: Colors.orange,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           _buildFilterButtons(),
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : orders.isEmpty
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('📦 Không có đơn hàng nào'),
//                 _buildRetryButton(),
//               ],
//             )
//                 : ListView.builder(
//               padding: EdgeInsets.all(Dimensions.width15),
//               itemCount: orders.length,
//               itemBuilder: (_, index) => _buildOrderCard(orders[index]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
