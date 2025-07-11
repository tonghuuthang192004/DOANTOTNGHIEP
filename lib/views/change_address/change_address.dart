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
    // Load cities initially
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
      Navigator.pop(context); // Close loading
    }
  }
// Hàm lấy tên thành phố, huyện, xã từ ID
// Hàm lấy tên Thành Phố từ mã Thành Phố
  String? getCityName(String? cityId) {
    final cities = Provider.of<ProvincesController>(context, listen: false).cities;
    // Nếu không tìm thấy thành phố, trả về một chuỗi rỗng thay vì null
    return cities.firstWhere(
            (city) => city.id.toString() == cityId,
        orElse: () => City(id: -1, name: "Không tìm thấy thành phố") // Thêm một City mặc định nếu không tìm thấy
    ).name;
  }

// Hàm lấy tên Quận/Huyện từ mã Quận/Huyện
  String? getDistrictName(String? districtId) {
    final districts = Provider.of<ProvincesController>(context, listen: false).districts;
    // Nếu không tìm thấy quận/huyện, trả về một chuỗi rỗng thay vì null
    return districts.firstWhere(
            (district) => district.id.toString() == districtId,
        orElse: () => District(id: -1, name: "Không tìm thấy quận/huyện") // Thêm một District mặc định nếu không tìm thấy
    ).name;
  }

// Hàm lấy tên Phường/Xã từ mã Phường/Xã
  String? getWardName(String? wardId) {
    final wards = Provider.of<ProvincesController>(context, listen: false).wards;
    // Nếu không tìm thấy phường/xã, trả về một chuỗi rỗng thay vì null
    return wards.firstWhere(
            (ward) => ward.id.toString() == wardId,
        orElse: () => Ward(id: -1, name: "Không tìm thấy phường/xã") // Thêm một Ward mặc định nếu không tìm thấy
    ).name;
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
        if (address.city != null) ...[
          SizedBox(height: Dimensions.height5),
          Text(address.city!, style: TextStyle(fontSize: Dimensions.font14, color: Colors.grey[600])),
        ],
        if (address.district != null) ...[
          SizedBox(height: Dimensions.height5),
          Text(address.district!, style: TextStyle(fontSize: Dimensions.font14, color: Colors.grey[600])),
        ],
        if (address.ward != null) ...[
          SizedBox(height: Dimensions.height5),
          Text(address.ward!, style: TextStyle(fontSize: Dimensions.font14, color: Colors.grey[600])),
        ],
      ],
    );
  }

  Widget _buildPopupMenu(AddressModel address) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleAddressAction(value, address),
      itemBuilder: (context) => [
        // const PopupMenuItem(value: 'edit', child: Text('Sửa')),
        if (!address.isDefault) const PopupMenuItem(value: 'default', child: Text('Đặt mặc định')),
        const PopupMenuItem(value: 'delete', child: Text('Xoá')),
      ],
    );
  }

  Future<void> _handleAddressAction(String action, AddressModel address) async {
    try {
      switch (action) {
        // case 'edit':
        //   _showAddressDialog(address: address);
        //   break;
        case 'default':
          await _showLoading(() async {
            await AddressService.setDefaultAddress(address.id);
            _showSnackBar('✅ Đặt mặc định thành công');
            await _loadAddresses();
          });
          break;
        case 'delete':
          await _showLoading(() async {
            await AddressService.deleteAddress(address.id);
            _showSnackBar('🗑️ Xoá địa chỉ thành công');
            await _loadAddresses();
          });
          break;
      }
    } catch (e) {
      _showSnackBar('❌ Lỗi: $e', isError: true);
    }
  }

  Future<void> _showAddressDialog({AddressModel? address}) async {
    final nameController = TextEditingController(text: address?.name ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final formKey = GlobalKey<FormState>();
    bool isDefault = address?.isDefault ?? false;


    String? getCityName(String? cityId) {
      final cities = Provider.of<ProvincesController>(context, listen: false).cities;
      return cities.firstWhere(
              (city) => city.id.toString() == cityId,
          orElse: () => City(id: -1, name: "Không tìm thấy thành phố") // Trả về tên thành phố
      ).name;
    }

    String? getDistrictName(String? districtId) {
      final districts = Provider.of<ProvincesController>(context, listen: false).districts;
      return districts.firstWhere(
              (district) => district.id.toString() == districtId,
          orElse: () => District(id: -1, name: "Không tìm thấy quận/huyện") // Trả về tên quận/huyện
      ).name;
    }

    String? getWardName(String? wardId) {
      final wards = Provider.of<ProvincesController>(context, listen: false).wards;
      return wards.firstWhere(
              (ward) => ward.id.toString() == wardId,
          orElse: () => Ward(id: -1, name: "Không tìm thấy phường/xã") // Trả về tên phường/xã
      ).name;
    }

    // Load city, district, and ward
    selectedCity = address?.city;
    selectedDistrict = address?.district;
    selectedWard = address?.ward;
    final userId = await UserSession.getUserId();
    if (userId == null) {
      _showSnackBar('❌ Người dùng chưa đăng nhập');
      return;
    }    showDialog(
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
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade400],  // Màu gradient từ trên xuống dưới
                      begin: Alignment.topLeft,  // Vị trí bắt đầu gradient
                      end: Alignment.bottomRight,  // Vị trí kết thúc gradient
                    ),  // Nền trắng cho dialog content
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
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
                      // City Dropdown
                      DropdownButton<String>(
                        hint: Text("Chọn Thành Phố"),
                        value: selectedCity,
                        onChanged: (cityCode) async {
                          setDialogState(() {
                            selectedCity = cityCode;
                            selectedDistrict = null;
                            selectedWard = null;
                          });
                          await Provider.of<ProvincesController>(context, listen: false).loadDistricts(cityCode!);
                        },
                        items: _buildCityDropdownItems(context),
                      ),
                      SizedBox(height: Dimensions.height15),
                      // District Dropdown


                        DropdownButton<String>(
                          hint: Text("Chọn Quận/Huyện"),
                          value: selectedDistrict,
                          onChanged: (districtCode) async {
                            setDialogState(() {
                              selectedDistrict = districtCode;
                              selectedWard = null;
                            });
                            await Provider.of<ProvincesController>(context, listen: false).loadWards(districtCode!);
                          },
                          items: _buildDistrictDropdownItems(context),
                        ),
                      SizedBox(height: Dimensions.height15),
                      // Ward Dropdown
                      if (selectedDistrict != null)
                        DropdownButton<String>(
                          hint: Text("Chọn Phường/Xã"),
                          value: selectedWard,
                          onChanged: (wardCode) {
                            setDialogState(() {
                              selectedWard = wardCode;
                            });
                          },
                          items: _buildWardDropdownItems(context),
                        ),
                      SizedBox(height: Dimensions.height15),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Mặc định', style: TextStyle(fontSize: Dimensions.font14)),
                      //     Switch(
                      //       value: isDefault,
                      //       onChanged: (value) => setDialogState(() => isDefault = value),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(fontSize: Dimensions.font14, color: Colors.orange)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final cityName = getCityName(selectedCity); // Lấy tên thành phố từ ID
                  final districtName = getDistrictName(selectedDistrict); // Lấy tên quận từ ID
                  final wardName = getWardName(selectedWard); // Lấy tên phường từ ID

                  final newAddress = AddressModel(
                    userId: userId, // Pass the userId here
                    id: address?.id ?? 0, // Make sure to pass the id here
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    address: addressController.text.trim(),
                    city: cityName,
                    district: districtName,
                    ward: wardName,
                    isDefault: isDefault,
                  );

                  try {
                    // Only create new address, no update functionality
                    await _showLoading(() async {
                      await AddressService.createAddress(newAddress);
                      _showSnackBar('✅ Địa chỉ đã được thêm thành công');
                    });
                    Navigator.pop(context);
                    await _loadAddresses();
                  } catch (e) {
                    _showSnackBar('❌ Lỗi khi thêm địa chỉ: $e', isError: true);
                  }
                },
                child: Text('Thêm', style: TextStyle(fontSize: Dimensions.font16)),
              )

            ],
          );

        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildCityDropdownItems(BuildContext context) {
    final cities = Provider.of<ProvincesController>(context).cities;
    return cities
        .map((city) => DropdownMenuItem<String>(
      value: city.id.toString(),
      child: Text(city.name),
    ))
        .toList();
  }

  List<DropdownMenuItem<String>> _buildDistrictDropdownItems(BuildContext context) {
    final districts = Provider.of<ProvincesController>(context).districts;
    return districts
        .map((district) => DropdownMenuItem<String>(
      value: district.id.toString(),
      child: Text(district.name),
    ))
        .toList();
  }

  List<DropdownMenuItem<String>> _buildWardDropdownItems(BuildContext context) {
    final wards = Provider.of<ProvincesController>(context).wards;
    return wards
        .map((ward) => DropdownMenuItem<String>(
      value: ward.id.toString(),
      child: Text(ward.name),
    ))
        .toList();
  }
  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    Color borderColor = Colors.black,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: BorderSide(color: Colors.orange, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}

