import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provincesController/provincesController.dart';
import '../../models/address/address_model.dart';
import '../../services/address/address_service.dart';
import '../../services/user/user_session.dart';
import '../../utils/dimensions.dart';

class AddressManagementPage extends StatefulWidget {
  @override
  _AddressManagementPageState createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  List<AddressModel> addresses = [];
  bool isLoading = true;

  String? selectedCity;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    Future.delayed(Duration.zero, () {
      Provider.of<ProvincesController>(context, listen: false).loadCities();
    });
  }

  Future<void> _loadAddresses() async {
    setState(() => isLoading = true);
    try {
      final fetched = await AddressService.fetchAddresses();
      setState(() => addresses = fetched);
    } catch (e) {
      _showSnackBar('❌ Lỗi tải địa chỉ: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
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

  Future<void> _showLoading(Future<void> Function() action) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await action();
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text('Quản lý địa chỉ', style: TextStyle(fontSize: Dimensions.font18)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? Center(
        child: Text(
          '📭 Chưa có địa chỉ nào',
          style: TextStyle(fontSize: Dimensions.font16, color: Colors.grey),
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadAddresses,
        child: ListView.builder(
          padding: EdgeInsets.all(Dimensions.height20),
          itemCount: addresses.length,
          itemBuilder: (context, index) => _buildAddressCard(addresses[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressDialog(),
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white, size: Dimensions.iconSize24),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: address.isDefault ? Border.all(color: Colors.orange, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAddressInfo(address)),
            _buildPopupMenu(address),
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
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10, vertical: Dimensions.height5),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: Text(
                  'Mặc định',
                  style: TextStyle(color: Colors.white, fontSize: Dimensions.font12),
                ),
              ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Text(address.address, style: TextStyle(fontSize: Dimensions.font14, color: Colors.grey[800])),
        if (address.city != null) Text(address.city!, style: TextStyle(color: Colors.grey[600])),
        if (address.district != null) Text(address.district!, style: TextStyle(color: Colors.grey[600])),
        if (address.ward != null) Text(address.ward!, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPopupMenu(AddressModel address) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAddressAction(value, address),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Sửa')),
        if (!address.isDefault) const PopupMenuItem(value: 'default', child: Text('Đặt mặc định')),
        const PopupMenuItem(value: 'delete', child: Text('Xoá')),
      ],
    );
  }

  Future<void> _handleAddressAction(String action, AddressModel address) async {
    switch (action) {
      case 'edit':
        _showAddressDialog(address: address);
        break;
      case 'default':
        await _showLoading(() async {
          await AddressService.setDefaultAddress(address.id);
          _showSnackBar('✅ Đặt mặc định thành công');
          await _loadAddresses();
        });
        break;
      case 'delete':
        if (address.isDefault) {
          _showSnackBar('⚠️ Không thể xoá địa chỉ mặc định', isError: true);
        } else {
          await _showLoading(() async {
            await AddressService.deleteAddress(address.id);
            _showSnackBar('🗑️ Đã xoá địa chỉ thành công');
            await _loadAddresses();
          });
        }
        break;
    }
  }

  Future<void> _showAddressDialog({AddressModel? address}) async {
    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final formKey = GlobalKey<FormState>();
    bool isDefault = address?.isDefault ?? false;

    final provincesController = Provider.of<ProvincesController>(context, listen: false);

    // Map tên → ID
    selectedCity = provincesController.cities
        .firstWhere((c) => c.name == address?.city, orElse: () => City(id: -1, name: ""))
        .id
        .toString();
    if (selectedCity != '-1') {
      await provincesController.loadDistricts(selectedCity!);
    }

    selectedDistrict = provincesController.districts
        .firstWhere((d) => d.name == address?.district, orElse: () => District(id: -1, name: ""))
        .id
        .toString();
    if (selectedDistrict != '-1') {
      await provincesController.loadWards(selectedDistrict!);
    }

    selectedWard = provincesController.wards
        .firstWhere((w) => w.name == address?.ward, orElse: () => Ward(id: -1, name: ""))
        .id
        .toString();

    final userId = await UserSession.getUserId();
    if (userId == null) {
      _showSnackBar('❌ Người dùng chưa đăng nhập', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            title: Text(
              address == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ',
              style: TextStyle(fontSize: Dimensions.font18, color: Colors.orange),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _customTextField(controller: nameController, label: 'Họ tên', validator: (v) => v!.isEmpty ? '⚠️ Nhập họ tên' : null),
                    SizedBox(height: Dimensions.height15),
                    _customTextField(
                      controller: phoneController,
                      label: 'Số điện thoại',
                      type: TextInputType.phone,
                      validator: (v) => v!.isEmpty
                          ? '⚠️ Nhập số điện thoại'
                          : (RegExp(r'^[0-9]{10,11}$').hasMatch(v) ? null : '⚠️ Số không hợp lệ'),
                    ),
                    SizedBox(height: Dimensions.height15),
                    _customTextField(controller: addressController, label: 'Địa chỉ', validator: (v) => v!.isEmpty ? '⚠️ Nhập địa chỉ' : null),
                    SizedBox(height: Dimensions.height15),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Thành phố"),
                      value: selectedCity != '-1' ? selectedCity : null,
                      items: _buildCityDropdownItems(context),
                      onChanged: (value) async {
                        setDialogState(() {
                          selectedCity = value;
                          selectedDistrict = null;
                          selectedWard = null;
                        });
                        await provincesController.loadDistricts(value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height15),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Quận/Huyện"),
                      value: selectedDistrict != '-1' ? selectedDistrict : null,
                      items: _buildDistrictDropdownItems(context),
                      onChanged: (value) async {
                        setDialogState(() {
                          selectedDistrict = value;
                          selectedWard = null;
                        });
                        await provincesController.loadWards(value!);
                      },
                    ),
                    SizedBox(height: Dimensions.height15),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Phường/Xã"),
                      value: selectedWard != '-1' ? selectedWard : null,
                      items: _buildWardDropdownItems(context),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedWard = value;
                        });
                      },
                    ),
                    SizedBox(height: Dimensions.height15),

                    CheckboxListTile(
                      title: const Text('Đặt làm mặc định'),
                      value: isDefault,
                      onChanged: (value) => setDialogState(() => isDefault = value ?? false),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final newAddress = AddressModel(
                    id: address?.id ?? 0,
                    userId: userId,
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    address: addressController.text.trim(),
                    city: provincesController.cities
                        .firstWhere((c) => c.id.toString() == selectedCity, orElse: () => City(id: 0, name: ""))
                        .name,
                    district: provincesController.districts
                        .firstWhere((d) => d.id.toString() == selectedDistrict, orElse: () => District(id: 0, name: ""))
                        .name,
                    ward: provincesController.wards
                        .firstWhere((w) => w.id.toString() == selectedWard, orElse: () => Ward(id: 0, name: ""))
                        .name,
                    isDefault: isDefault,
                  );

                  try {
                    await _showLoading(() async {
                      if (address == null) {
                        await AddressService.createAddress(newAddress);
                        _showSnackBar('✅ Thêm địa chỉ thành công');
                      } else {
                        await AddressService.updateAddress(newAddress);
                        _showSnackBar('✅ Cập nhật địa chỉ thành công');
                      }
                      await _loadAddresses();
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    _showSnackBar('❌ Lỗi lưu địa chỉ: $e', isError: true);
                  }
                },
                child: Text(address == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildCityDropdownItems(BuildContext context) {
    final cities = Provider.of<ProvincesController>(context).cities;
    return cities.map((city) => DropdownMenuItem(value: city.id.toString(), child: Text(city.name))).toList();
  }

  List<DropdownMenuItem<String>> _buildDistrictDropdownItems(BuildContext context) {
    final districts = Provider.of<ProvincesController>(context).districts;
    return districts.map((district) => DropdownMenuItem(value: district.id.toString(), child: Text(district.name))).toList();
  }

  List<DropdownMenuItem<String>> _buildWardDropdownItems(BuildContext context) {
    final wards = Provider.of<ProvincesController>(context).wards;
    return wards.map((ward) => DropdownMenuItem(value: ward.id.toString(), child: Text(ward.name))).toList();
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
      ),
      validator: validator,
    );
  }
}
