import 'package:flutter/material.dart';
import '../../models/address/address_model.dart';
import '../../services/address/address_service.dart';
import '../../services/user/user_session.dart';
import '../../utils/dimensions.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  List<AddressModel> addresses = [];
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndAddresses();
  }

  Future<void> _loadUserIdAndAddresses() async {
    try {
      final fetchedUserIdStr = await UserSession.getUserId();
      if (fetchedUserIdStr == null) {
        _showSnackBar('Không tìm thấy userId', isError: true);
        return;
      }

      final parsedUserId = int.tryParse(fetchedUserIdStr.toString());
      if (parsedUserId == null) {
        _showSnackBar('ID người dùng không hợp lệ', isError: true);
        return;
      }

      userId = parsedUserId;
      await _loadAddresses();
    } catch (e) {
      _showSnackBar('Lỗi tải dữ liệu: $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadAddresses() async {
    if (userId == null) return;

    try {
      final fetched = await AddressService.fetchAddresses(userId!);
      setState(() {
        addresses = fetched;
      });
    } catch (e) {
      _showSnackBar('Lỗi tải danh sách địa chỉ: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Quản lý địa chỉ', style: TextStyle(fontSize: Dimensions.font18)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? const Center(child: Text('Chưa có địa chỉ nào'))
          : RefreshIndicator(
        onRefresh: _loadAddresses,
        child: ListView.builder(
          padding: EdgeInsets.all(Dimensions.height20),
          itemCount: addresses.length,
          itemBuilder: (context, index) =>
              _buildAddressCard(addresses[index], index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAddressDialog,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white, size: Dimensions.iconSize24),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: address.isDefault ? Border.all(color: Colors.orange, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, Dimensions.height5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAddressInfo(address)),
            _buildPopupMenu(address, index),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo(AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${address.name} | ${address.phone}',
                style: TextStyle(fontSize: Dimensions.font16, fontWeight: FontWeight.bold),
              ),
            ),
            if (address.isDefault)
              Container(
                margin: EdgeInsets.only(left: Dimensions.width10),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height5,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: Text('Mặc định',
                    style: TextStyle(color: Colors.white, fontSize: Dimensions.font12)),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Text(address.address, style: TextStyle(fontSize: Dimensions.font14)),
      ],
    );
  }

  Widget _buildPopupMenu(AddressModel address, int index) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAddressAction(value, address, index),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'edit', child: const Text('Sửa')),
        if (!address.isDefault)
          PopupMenuItem(value: 'default', child: const Text('Đặt mặc định')),
        PopupMenuItem(value: 'delete', child: const Text('Xoá')),
      ],
    );
  }

  void _handleAddressAction(String action, AddressModel address, int index) async {
    if (userId == null) return;

    try {
      switch (action) {
        case 'edit':
          _showAddressDialog(address: address, index: index);
          break;
        case 'default':
          await AddressService.setDefaultAddress(address.id, userId!);
          _showSnackBar('Đặt mặc định thành công');
          await _loadAddresses();
          break;
        case 'delete':
          await AddressService.deleteAddress(address.id);
          _showSnackBar('Xoá địa chỉ thành công');
          await _loadAddresses();
          break;
      }
    } catch (e) {
      _showSnackBar('Lỗi thao tác: $e', isError: true);
    }
  }

  void _showAddAddressDialog() {
    _showAddressDialog();
  }

  void _showAddressDialog({AddressModel? address, int? index}) {
    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final formKey = GlobalKey<FormState>();
    bool isDefault = address?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15)),
          title: Text(address == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildTextField(nameController, 'Họ tên'),
                  SizedBox(height: Dimensions.height15),
                  _buildTextField(phoneController, 'Số điện thoại', type: TextInputType.phone),
                  SizedBox(height: Dimensions.height15),
                  _buildTextField(addressController, 'Địa chỉ'),
                  SizedBox(height: Dimensions.height15),
                  CheckboxListTile(
                    title: const Text('Đặt làm địa chỉ mặc định'),
                    value: isDefault,
                    onChanged: (value) => setDialogState(() => isDefault = value ?? false),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate() || userId == null) return;

                final newAddress = AddressModel(
                  id: address?.id ?? 0,
                  userId: userId!,
                  name: nameController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                  isDefault: isDefault,
                );

                try {
                  if (address == null) {
                    await AddressService.createAddress(newAddress);
                    _showSnackBar('Thêm địa chỉ thành công');
                  } else {
                    await AddressService.updateAddress(newAddress);
                    _showSnackBar('Cập nhật địa chỉ thành công');
                  }
                  Navigator.pop(context);
                  await _loadAddresses();
                } catch (e) {
                  _showSnackBar('Lỗi lưu địa chỉ: $e', isError: true);
                }
              },
              child: Text(address == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập $label' : null,
    );
  }
}
