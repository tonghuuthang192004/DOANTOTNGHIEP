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

  @override
  void initState() {
    super.initState();
    _loadUserIdAndAddresses();
  }

  Future<void> _loadUserIdAndAddresses() async {
    final fetchedUserIdStr = await UserSession.getUserId();

    if (fetchedUserIdStr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy userId"), backgroundColor: Colors.red),
      );
      return;
    }

    final parsedUserId = int.tryParse(fetchedUserIdStr.toString());

    if (parsedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID người dùng không hợp lệ"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      userId = parsedUserId;
    });

    await _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    if (userId == null) return;

    try {
      final fetched = await AddressService.fetchAddresses(userId!);
      setState(() {
        addresses = fetched;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải địa chỉ: $e'), backgroundColor: Colors.red),
      );
    }
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
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(Dimensions.height20),
        itemCount: addresses.length,
        itemBuilder: (context, index) => _buildAddressCard(addresses[index], index),
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
        PopupMenuItem(value: 'edit', child: Text('Sửa')),
        if (!address.isDefault) PopupMenuItem(value: 'default', child: Text('Đặt mặc định')),
        PopupMenuItem(value: 'delete', child: Text('Xóa')),
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
          await _loadAddresses();
          break;
        case 'delete':
          await AddressService.deleteAddress(address.id, userId!);
          await _loadAddresses();
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi thao tác địa chỉ: $e'), backgroundColor: Colors.red),
      );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15)),
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
                  )
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
                  } else {
                    await AddressService.updateAddress(newAddress);
                  }
                  Navigator.pop(context);
                  await _loadAddresses();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi lưu địa chỉ: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: Text(address == null ? 'Thêm' : 'Cập nhật'),
            )
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
