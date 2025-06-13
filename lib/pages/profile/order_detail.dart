import 'package:flutter/material.dart';

final Map<String, dynamic> sampleOrder = {
  'id': 'DH123456',
  'status': 'Đã giao',
  'date': '12/06/2025',
  'total': 135000,
  'note': 'Giao trước 18h',
  'items': [
    {
      'name': 'Pizza hải sản',
      'quantity': 1,
      'price': 75000,
      'image': 'images/fried_chicken.png',
    },
    {
      'name': 'Trà sữa trân châu',
      'quantity': 2,
      'price': 30000,
      'image': 'images/fried_chicken.png',
    },
  ]
};



class OrderDetailPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailPage({super.key, required this.orderData});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    final items = widget.orderData['items'] as List<Map<String, dynamic>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mã đơn hàng & Trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mã đơn: ${widget.orderData['id']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    widget.orderData['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(widget.orderData['status']),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ngày đặt
            Text(
              'Ngày đặt: ${widget.orderData['date']}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Danh sách sản phẩm
            const Text("Sản phẩm đã đặt:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...items.map((item) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Image.asset(
                  item['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name']),
                subtitle: Text('Số lượng: ${item['quantity']}'),
                trailing: Text('${item['price']}đ'),
              ),
            )),

            const Divider(height: 32),

            // Tổng tiền
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tổng thanh toán:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.orderData['total']}đ",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Ghi chú (nếu có)
            if (widget.orderData['note'] != null &&
                widget.orderData['note'].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ghi chú:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.orderData['note']),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lý':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
