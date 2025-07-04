import 'package:flutter/material.dart';
import 'package:frontendtn1/views/promotion/saved_discount_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api/api_constants.dart';
import '../../models/discount/discount_model.dart';
import '../../services/discount/discount_service.dart';

class AvailableDiscountPage extends StatefulWidget {
  final int userId;

  const AvailableDiscountPage({super.key, required this.userId});

  @override
  State<AvailableDiscountPage> createState() => _AvailableDiscountPageState();
}

class _AvailableDiscountPageState extends State<AvailableDiscountPage> {
  List<DiscountModel> danhSachMaGiamGia = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDanhSachMa();
  }

  Future<void> fetchDanhSachMa() async {
    final url = Uri.parse(API.getAllDiscounts);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        danhSachMaGiamGia =
            data.map((e) => DiscountModel.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleSave(int idMa) async {
    try {
      await DiscountService.saveDiscount(
        userId: widget.userId,
        discountId: idMa,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đã lưu mã thành công!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách khuyến mãi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_added_outlined),
            tooltip: "Mã đã lưu",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SavedDiscountPage(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : danhSachMaGiamGia.isEmpty
          ? const Center(child: Text("Không có mã giảm giá nào khả dụng"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: danhSachMaGiamGia.length,
        itemBuilder: (context, index) {
          final ma = danhSachMaGiamGia[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                ma.ten,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text("🎯 Mã: ${ma.ma}"),
                  Text(
                    ma.loai == 'percent'
                        ? "🔻 Giảm ${ma.giaTri}%"
                        : "🔻 Giảm ${ma.giaTri}đ",
                  ),
                  Text("💰 Áp dụng cho đơn từ ${ma.dieuKien}đ"),
                  Text(
                      "📅 HSD: ${ma.ketThuc.toLocal().toString().substring(0, 10)}"),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () => handleSave(ma.id),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Lưu mã"),
              ),
            ),
          );
        },
      ),
    );
  }
}
