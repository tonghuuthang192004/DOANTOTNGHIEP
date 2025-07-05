import '../../models/discount/discount_model.dart';
import '../../services/discount/discount_service.dart';

class DiscountController {
  /// 📦 Lấy tất cả voucher đang hoạt động
  Future<List<DiscountModel>> getAllDiscounts() async {
    try {
      return await DiscountService.getAllDiscounts();
    } catch (e) {
      print('❌ [getAllDiscounts] Error: $e');
      throw Exception('Không thể tải danh sách voucher');
    }
  }

  /// 💾 Lưu voucher vào danh sách của user
  Future<void> saveDiscount({
    required int userId,
    required int discountId,
  }) async {
    try {
      await DiscountService.saveDiscount(
        userId: userId,
        discountId: discountId, // ✅ Đúng tên tham số
      );
    } catch (e) {
      print('❌ [saveDiscount] Error: $e');
      throw Exception('Không thể lưu mã giảm giá');
    }
  }


  /// 📥 Lấy danh sách voucher đã lưu của user
  Future<List<DiscountModel>> getSavedDiscounts(int userId) async {
    try {
      return await DiscountService.getSavedDiscounts(userId);
    } catch (e) {
      print('❌ [getSavedDiscounts] Error: $e');
      throw Exception('Không thể tải danh sách mã đã lưu');
    }
  }

  /// ✅ Áp dụng voucher khi thanh toán
  Future<Map<String, dynamic>> applyDiscount({
    required int userId,
    required String maGiamGia,
    required double tongGiaTri,
  }) async {
    try {
      return await DiscountService.applyDiscount(
        userId: userId,
        maGiamGia: maGiamGia,
        tongGiaTri: tongGiaTri,
      );
    } catch (e) {
      print('❌ [applyDiscount] Error: $e');
      throw Exception('Không thể áp dụng mã giảm giá');
    }
  }
}
