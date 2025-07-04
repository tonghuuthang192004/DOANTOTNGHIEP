import '../../models/address/address_model.dart';
import '../../services/address/address_service.dart';

class AddressController {
  /// 📥 Lấy toàn bộ địa chỉ của người dùng
  Future<List<AddressModel>> getAddresses(int userId) async {
    try {
      return await AddressService.fetchAddresses(userId);
    } catch (e) {
      print('❌ [getAddresses] Lỗi: $e');
      return [];
    }
  }

  /// 🌟 Lấy địa chỉ mặc định nếu có
  Future<AddressModel?> getDefaultAddress(int userId) async {
    try {
      final addresses = await getAddresses(userId);
      if (addresses.isEmpty) return null;
      return addresses.firstWhere(
            (addr) => addr.isDefault,
        orElse: () => addresses.first,
      );
    } catch (e) {
      print('❌ [getDefaultAddress] Lỗi: $e');
      return null;
    }
  }

  /// ➕ Thêm địa chỉ mới
  Future<bool> addAddress(AddressModel address) async {
    try {
      await AddressService.createAddress(address);
      return true;
    } catch (e) {
      print('❌ [addAddress] Lỗi: $e');
      return false;
    }
  }

  /// ✏️ Cập nhật địa chỉ
  Future<bool> updateAddress(AddressModel address) async {
    try {
      await AddressService.updateAddress(address);
      return true;
    } catch (e) {
      print('❌ [updateAddress] Lỗi: $e');
      return false;
    }
  }

  /// 🗑️ Xoá địa chỉ
  Future<bool> deleteAddress(int id) async {
    try {
      await AddressService.deleteAddress(id);
      return true;
    } catch (e) {
      print('❌ [deleteAddress] Lỗi: $e');
      return false;
    }
  }

  /// 🌟 Đặt địa chỉ mặc định
  Future<bool> setDefaultAddress(int id, int userId) async {
    try {
      await AddressService.setDefaultAddress(id, userId);
      return true;
    } catch (e) {
      print('❌ [setDefaultAddress] Lỗi: $e');
      return false;
    }
  }
}
