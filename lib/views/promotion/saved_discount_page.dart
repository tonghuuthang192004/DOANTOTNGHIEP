import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api/api_constants.dart';
import '../../models/discount/discount_model.dart';

class SavedDiscountPage extends StatefulWidget {
  final int userId;
  final bool isSelectionMode;
  const SavedDiscountPage({super.key, required this.userId, this.isSelectionMode = false,});

  @override
  State<SavedDiscountPage> createState() => _SavedDiscountPageState();
}

class _SavedDiscountPageState extends State<SavedDiscountPage> {
  List<DiscountModel> danhSachDaLuu = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedDiscounts();
  }

  Future<void> fetchSavedDiscounts() async {
    final url = Uri.parse('${API.getSavedDiscounts}/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        danhSachDaLuu = data.map((e) => DiscountModel.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎫 Mã đã lưu")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : danhSachDaLuu.isEmpty
          ? const Center(child: Text("😢 Bạn chưa lưu mã nào"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: danhSachDaLuu.length,
        itemBuilder: (context, index) {
          final ma = danhSachDaLuu[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () {
                // ✅ Khi bấm vào sẽ trả về mã đã chọn
                Navigator.pop(context, ma);
              },
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
                  Text("📅 HSD: ${ma.ketThuc.toLocal().toString().substring(0, 10)}"),
                ],
              ),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}
