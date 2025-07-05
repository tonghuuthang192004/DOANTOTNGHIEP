import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../models/discount/discount_model.dart';
import '../../services/discount/discount_service.dart';
import 'saved_discount_page.dart';

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
    try {
      final response = await http.get(Uri.parse(API.getAllDiscounts));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          danhSachMaGiamGia =
              data.map((e) => DiscountModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Không thể tải danh sách mã giảm giá");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi: ${e.toString()}')),
      );
    }
  }

  Future<void> handleSave(int idMa) async {
    try {
      await DiscountService.saveDiscount(
        userId: widget.userId,
        discountId: idMa, // ✅ đổi từ voucherId sang discountId
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đã lưu mã thành công!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách khuyến mãi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_added_outlined, color: Colors.white),
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
          ? const Center(
        child: Text("📭 Không có mã giảm giá nào khả dụng"),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: danhSachMaGiamGia.length,
        itemBuilder: (context, index) {
          final ma = danhSachMaGiamGia[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                ma.ten,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🎯 Mã: ${ma.ma}"),
                    Text(
                      ma.loai == 'phan_tram'
                          ? "🔻 Giảm ${ma.giaTri}%"
                          : "🔻 Giảm ${ma.giaTri.toStringAsFixed(0)}đ",
                    ),
                    // Text("💰 Đơn tối thiểu: ${ma.dieuKien}đ"),
                    Text(
                      "📅 HSD: ${ma.ketThuc.toLocal().toString().substring(0, 10)}",
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () => handleSave(ma.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text("Lưu"),
              ),
            ),
          );
        },
      ),
    );
  }
}
