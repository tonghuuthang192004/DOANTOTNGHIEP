import 'package:flutter/material.dart';
import '../../models/discount/discount_model.dart';
import '../../services/discount/discount_service.dart';

class SavedDiscountPage extends StatefulWidget {
  final int userId;
  final bool isSelectionMode;

  const SavedDiscountPage({
    super.key,
    required this.userId,
    this.isSelectionMode = false,
  });

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
    try {
      final data = await DiscountService.getSavedDiscounts(widget.userId);
      setState(() {
        danhSachDaLuu = data;
        isLoading = false;
      });
    } catch (e) {
      print('❌ [fetchSavedDiscounts] Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎫 Mã đã lưu"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
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
                if (widget.isSelectionMode) {
                  Navigator.pop(context, ma);
                }
              },
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                ma.ten,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text("🎯 Mã: ${ma.ma}"),
                  Text(
                    ma.loai == 'phan_tram'
                        ? "🔻 Giảm ${ma.giaTri}%"
                        : "🔻 Giảm ${ma.giaTri}đ",
                  ),
                  Text(
                    "📅 HSD: ${ma.ketThuc.toLocal().toString().substring(0, 10)}",
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
