import '../../models/discount/discount_model.dart';
import '../../services/discount/discount_service.dart';


class DiscountController {
  Future<List<DiscountModel>> getSavedDiscounts(int userId) {
    return DiscountService.getSavedDiscounts(userId);
  }

  Future<Map<String, dynamic>> applySaved({
    required int userId,
    required int discountId,
    required double tongTien,
  }) {
    return DiscountService.applySavedDiscount(
      userId: userId,
      discountId: discountId,
      tongTien: tongTien,
    );
  }

  Future<void> saveDiscount({
    required int userId,
    required int discountId,
  }) {
    return DiscountService.saveDiscount(
      userId: userId,
      discountId: discountId,
    );
  }
}
