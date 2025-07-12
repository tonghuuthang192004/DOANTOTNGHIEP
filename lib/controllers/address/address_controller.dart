import '../../models/address/address_model.dart';
import '../../services/address/address_service.dart';

class AddressController {
  /// 📥 Lấy danh sách địa chỉ user
  Future<List<AddressModel>> getAddresses() async {
    try {
      final addresses = await AddressService.fetchAddresses();
      return addresses;
    } catch (e) {
      print('❌ [getAddresses] Lỗi: $e');
      return []; // Trả về danh sách rỗng khi lỗi
    }
  }

  /// 🌟 Lấy địa chỉ mặc định nếu có
  Future<AddressModel?> getDefaultAddress() async {
    try {
      final addresses = await getAddresses();
      if (addresses.isEmpty) return null;

      // Ưu tiên địa chỉ mặc định
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
      rethrow; // 👈 Để UI có thể hiển thị thông báo lỗi
    }
  }

  /// ✏️ Cập nhật địa chỉ
  Future<bool> updateAddress(AddressModel address) async {
    try {
      await AddressService.updateAddress(address);
      return true;
    } catch (e) {
      print('❌ [updateAddress] Lỗi: $e');
      rethrow;
    }
  }

  /// 🗑️ Xoá địa chỉ
  Future<bool> deleteAddress(int id) async {
    try {
      await AddressService.deleteAddress(id);
      return true;
    } catch (e) {
      print('❌ [deleteAddress] Lỗi: $e');
      rethrow;
    }
  }

  /// 🌟 Đặt địa chỉ mặc định
  Future<bool> setDefaultAddress(int id) async {
    try {
      await AddressService.setDefaultAddress(id);
      return true;
    } catch (e) {
      print('❌ [setDefaultAddress] Lỗi: $e');
      rethrow;
    }
  }


}
