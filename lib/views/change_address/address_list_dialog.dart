import 'package:flutter/material.dart';
import '../../../models/address/address_model.dart';
import '../../../controllers/address/address_controller.dart';
import '../../../utils/dimensions.dart';
import 'address_dialog.dart';

class AddressListDialog extends StatefulWidget {
  final AddressModel? selectedAddress;
  final Function(AddressModel) onAddressSelected;

  const AddressListDialog({
    Key? key,
    this.selectedAddress,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  _AddressListDialogState createState() => _AddressListDialogState();
}

class _AddressListDialogState extends State<AddressListDialog> {
  List<AddressModel> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final data = await AddressController().getAddresses();
      setState(() {
        addresses = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi tải địa chỉ: $e')),
      );
    }
  }

  Future<void> _openAddAddressDialog() async {
    final AddressModel? newAddress = await showDialog<AddressModel>(
      context: context,
      builder: (_) => AddressDialog(
        address: null,
        onSave: (savedAddress) async {
          await AddressController().addAddress(savedAddress);
          _loadAddresses();
          Navigator.pop(context, savedAddress);
        },
      ),
    );

    if (newAddress != null) {
      setState(() => addresses.add(newAddress));
      widget.onAddressSelected(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      titlePadding: EdgeInsets.all(Dimensions.height15),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "📦 Chọn địa chỉ giao hàng",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: Dimensions.font16,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_location_alt, color: Colors.green, size: Dimensions.iconSize20),
            tooltip: "Thêm địa chỉ mới",
            onPressed: _openAddAddressDialog,
          ),
        ],
      ),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
        width: double.maxFinite,
        height: Dimensions.height300,
        child: addresses.isEmpty
            ? Center(
          child: Text(
            "⚠️ Không có địa chỉ nào.\nHãy thêm mới để bắt đầu.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: Dimensions.font14),
          ),
        )
            : ListView.separated(
          itemCount: addresses.length,
          separatorBuilder: (_, __) => SizedBox(height: Dimensions.height10),
          itemBuilder: (context, index) {
            final address = addresses[index];
            final bool isSelected = widget.selectedAddress?.id == address.id;

            return _buildAddressCard(address, isSelected);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Đóng',
            style: TextStyle(
              color: Colors.orange,
              fontSize: Dimensions.font14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(AddressModel address, bool isSelected) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius12),
      onTap: () => widget.onAddressSelected(address),
      child: Card(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.home, color: Colors.blue, size: Dimensions.iconSize20),
                  SizedBox(width: Dimensions.width8),
                  Expanded(
                    child: Text(
                      "${address.name} - ${address.phone}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: Colors.blue, size: Dimensions.iconSize20),
                ],
              ),
              SizedBox(height: Dimensions.height5),
              Text(
                address.address,
                style: TextStyle(color: Colors.grey[800], fontSize: Dimensions.font14),
              ),
              Text(
                "${address.ward}, ${address.district}, ${address.city}",
                style: TextStyle(color: Colors.grey[600], fontSize: Dimensions.font14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
