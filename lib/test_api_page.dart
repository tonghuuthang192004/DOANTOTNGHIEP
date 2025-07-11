import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provincesController/provincesController.dart';

class AddressSelectionScreen extends StatefulWidget {
  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  String? selectedCity;
  String? selectedDistrict;
  String? selectedWard;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tải danh sách thành phố khi màn hình được tạo
    Future.delayed(Duration.zero, () {
      Provider.of<ProvincesController>(context, listen: false).loadCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Địa Chỉ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trường tên
            _customTextField(controller: nameController, label: 'Họ tên', validator: (v) => v!.isEmpty ? '⚠️ Nhập họ tên' : null),
            SizedBox(height: 16),
            // Trường số điện thoại
            _customTextField(
              controller: phoneController,
              label: 'Số điện thoại',
              type: TextInputType.phone,
              validator: (v) => v!.isEmpty
                  ? '⚠️ Nhập số điện thoại'
                  : (RegExp(r'^[0-9]{10,11}$').hasMatch(v) ? null : '⚠️ Số không hợp lệ'),
            ),
            SizedBox(height: 16),
            // Trường địa chỉ
            _customTextField(controller: addressController, label: 'Địa chỉ', validator: (v) => v!.isEmpty ? '⚠️ Nhập địa chỉ' : null),
            SizedBox(height: 16),
            // Thành phố
            DropdownButton<String>(
              hint: Text("Chọn Thành Phố"),
              value: selectedCity,
              onChanged: (cityCode) async {
                setState(() {
                  selectedCity = cityCode;
                  selectedDistrict = null; // Reset quận/huyện
                  selectedWard = null; // Reset phường/xã
                });
                // Tải danh sách quận/huyện khi thành phố được chọn
                await Provider.of<ProvincesController>(context, listen: false)
                    .loadDistricts(cityCode!);
              },
              items: _buildCityDropdownItems(context),
            ),
            SizedBox(height: 16),
            // Quận/Huyện
            if (selectedCity != null)
              DropdownButton<String>(
                hint: Text("Chọn Quận/Huyện"),
                value: selectedDistrict,
                onChanged: (districtCode) async {
                  setState(() {
                    selectedDistrict = districtCode;
                    selectedWard = null; // Reset phường/xã
                  });
                  // Tải danh sách phường/xã khi quận/huyện được chọn
                  await Provider.of<ProvincesController>(context, listen: false)
                      .loadWards(districtCode!);
                },
                items: _buildDistrictDropdownItems(context),
              ),
            SizedBox(height: 16),
            // Phường/Xã
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trả về địa chỉ đã chọn cho màn hình trước đó
                Navigator.pop(context, {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'address': addressController.text,
                  'city': selectedCity,
                  'district': selectedDistrict,
                  'ward': selectedWard,
                });
              },
              child: Text('Chọn Địa Chỉ'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng danh sách thành phố
  List<DropdownMenuItem<String>> _buildCityDropdownItems(BuildContext context) {
    final cities = Provider.of<ProvincesController>(context).cities;
    return cities
        .map((city) => DropdownMenuItem<String>(
      value: city.id.toString(),
      child: Text(city.name),
    ))
        .toList();
  }

  // Hàm xây dựng danh sách quận/huyện
  List<DropdownMenuItem<String>> _buildDistrictDropdownItems(BuildContext context) {
    final districts = Provider.of<ProvincesController>(context).districts;
    return districts
        .map((district) => DropdownMenuItem<String>(
      value: district.id.toString(),
      child: Text(district.name),
    ))
        .toList();
  }

  // Hàm xây dựng danh sách phường/xã
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validator,
    );
  }
}
