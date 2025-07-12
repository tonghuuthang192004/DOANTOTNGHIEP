import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provincesController/provincesController.dart';
import '../../models/address/address_model.dart';
import '../../services/user/user_session.dart';
import '../../utils/dimensions.dart';

class AddressDialog extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel) onSave;

  const AddressDialog({Key? key, this.address, required this.onSave}) : super(key: key);

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  bool isDefault = true;

  String? selectedCity;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.address?.name ?? '');
    phoneController = TextEditingController(text: widget.address?.phone ?? '');
    addressController = TextEditingController(text: widget.address?.address ?? '');
    isDefault = widget.address?.isDefault ?? true;

    // Nếu có địa chỉ cũ thì set selectedCity/District/Ward
    selectedCity = widget.address?.city;
    selectedDistrict = widget.address?.district;
    selectedWard = widget.address?.ward;

    Future.microtask(() {
      final provinces = Provider.of<ProvincesController>(context, listen: false);
      provinces.loadCities().then((_) {
        if (selectedCity != null) {
          final city = provinces.cities.firstWhere(
                (c) => c.name == selectedCity,
            orElse: () => provinces.cities.first,
          );
          provinces.loadDistricts(city.id.toString()).then((_) {
            if (selectedDistrict != null) {
              final district = provinces.districts.firstWhere(
                    (d) => d.name == selectedDistrict,
                orElse: () => provinces.districts.first,
              );
              provinces.loadWards(district.id.toString());
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provinces = Provider.of<ProvincesController>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius15)),
      title: Text(
        widget.address == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ',
        style: TextStyle(fontSize: Dimensions.font18, color: Colors.orange),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _customTextField(controller: nameController, label: 'Họ tên'),
            SizedBox(height: Dimensions.height10),
            _customTextField(controller: phoneController, label: 'Số điện thoại', type: TextInputType.phone),
            SizedBox(height: Dimensions.height10),
            _customTextField(controller: addressController, label: 'Địa chỉ chi tiết'),
            SizedBox(height: Dimensions.height15),

            // Dropdown Thành phố
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Thành phố"),
              value: selectedCity,
              items: provinces.cities.map((city) {
                return DropdownMenuItem(
                  value: city.name,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  selectedDistrict = null;
                  selectedWard = null;
                });
                final city = provinces.cities.firstWhere((c) => c.name == value);
                provinces.loadDistricts(city.id.toString());
              },
            ),
            SizedBox(height: Dimensions.height10),

            // Dropdown Quận/Huyện
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Quận/Huyện"),
              value: selectedDistrict,
              items: provinces.districts.map((district) {
                return DropdownMenuItem(
                  value: district.name,
                  child: Text(district.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedWard = null;
                });
                final district = provinces.districts.firstWhere((d) => d.name == value);
                provinces.loadWards(district.id.toString());
              },
            ),
            SizedBox(height: Dimensions.height10),

            // Dropdown Phường/Xã
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Phường/Xã"),
              value: selectedWard,
              items: provinces.wards.map((ward) {
                return DropdownMenuItem(
                  value: ward.name,
                  child: Text(ward.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWard = value;
                });
              },
            ),
            SizedBox(height: Dimensions.height15),

            CheckboxListTile(
              title: const Text("Đặt làm mặc định"),
              value: isDefault,
              onChanged: (val) => setState(() => isDefault = val ?? false),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Hủy", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () async {
            final userId = await UserSession.getUserId();
            if (userId == null) return;

            final newAddress = AddressModel(
              id: widget.address?.id ?? 0,
              userId: userId,
              name: nameController.text.trim(),
              phone: phoneController.text.trim(),
              address: addressController.text.trim(),
              city: selectedCity,
              district: selectedDistrict,
              ward: selectedWard,
              isDefault: isDefault,
            );
            widget.onSave(newAddress);
            Navigator.pop(context);
          },
          child: Text(widget.address == null ? 'Thêm' : 'Cập nhật'),
        ),
      ],
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius10)),
      ),
    );
  }
}
