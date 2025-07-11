import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provincesController/provincesController.dart';
import '../../models/address/address_model.dart';
import '../../services/address/address_service.dart';
import '../../utils/dimensions.dart';
import '../../services/user/user_session.dart';

class AddressDialog extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel) onSave;

  const AddressDialog({Key? key, this.address, required this.onSave}) : super(key: key);

  @override
  _AddressDialogState createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late bool isDefault;
  String? selectedCity;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.address?.name ?? '');
    phoneController = TextEditingController(text: widget.address?.phone ?? '');
    addressController = TextEditingController(text: widget.address?.address ?? '');
    isDefault = widget.address?.isDefault ?? true; // Đặt mặc định là true khi tạo mới

    selectedCity = widget.address?.city;
    selectedDistrict = widget.address?.district;
    selectedWard = widget.address?.ward;
  }

  String? getCityName(String? cityId) {
    final cities = Provider.of<ProvincesController>(context, listen: false).cities;
    return cities.firstWhere(
          (city) => city.id.toString() == cityId,
      orElse: () => City(id: -1, name: "Không tìm thấy thành phố"),
    ).name;
  }

  String? getDistrictName(String? districtId) {
    final districts = Provider.of<ProvincesController>(context, listen: false).districts;
    return districts.firstWhere(
          (district) => district.id.toString() == districtId,
      orElse: () => District(id: -1, name: "Không tìm thấy quận/huyện"),
    ).name;
  }

  String? getWardName(String? wardId) {
    final wards = Provider.of<ProvincesController>(context, listen: false).wards;
    return wards.firstWhere(
          (ward) => ward.id.toString() == wardId,
      orElse: () => Ward(id: -1, name: "Không tìm thấy phường/xã"),
    ).name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      title: Text(
        widget.address == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ',
        style: TextStyle(fontSize: Dimensions.font18, color: Colors.orange),
      ),
      content: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
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
                  onChanged: (cityCode) {
                    setState(() {
                      selectedCity = cityCode;
                      selectedDistrict = null;
                      selectedWard = null;
                    });
                    Provider.of<ProvincesController>(context, listen: false).loadDistricts(cityCode!);
                  },
                  items: _buildCityDropdownItems(context),
                ),
                SizedBox(height: Dimensions.height15),
                // District Dropdown
                if (selectedCity != null)
                  DropdownButton<String>(
                    hint: Text("Chọn Quận/Huyện"),
                    value: selectedDistrict,
                    onChanged: (districtCode) {
                      setState(() {
                        selectedDistrict = districtCode;
                        selectedWard = null;
                      });
                      Provider.of<ProvincesController>(context, listen: false).loadWards(districtCode!);
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
                      setState(() {
                        selectedWard = wardCode;
                      });
                    },
                    items: _buildWardDropdownItems(context),
                  ),
                SizedBox(height: Dimensions.height15),
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
            final cityName = getCityName(selectedCity);
            final districtName = getDistrictName(selectedDistrict);
            final wardName = getWardName(selectedWard);
            final userId = await UserSession.getUserId();

            if (userId == null) {
              return;
            }

            final newAddress = AddressModel(
              userId: userId,
              id: widget.address?.id ?? 0,
              name: nameController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              city: cityName,
              district: districtName,
              ward: wardName,
              isDefault: true, // Đảm bảo địa chỉ mới là mặc định
            );

            // Đảm bảo địa chỉ cũ được cập nhật lại là không mặc định


            widget.onSave(newAddress);
            Navigator.pop(context);
          },
          child: Text(widget.address == null ? 'Thêm' : 'Cập nhật', style: TextStyle(fontSize: Dimensions.font16)),
        ),
      ],
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
