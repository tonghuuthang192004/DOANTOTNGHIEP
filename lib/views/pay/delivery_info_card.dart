import 'package:flutter/material.dart';
import '../../../models/address/address_model.dart';
import '../../../controllers/address/address_controller.dart';
import '../../../services/user/user_session.dart';

class DeliveryInfoSection extends StatefulWidget {
  final String note;
  final Function(String note) onNoteChanged;
  final Function(AddressModel address) onAddressChanged;

  const DeliveryInfoSection({
    super.key,
    required this.note,
    required this.onNoteChanged,
    required this.onAddressChanged,
  });

  @override
  State<DeliveryInfoSection> createState() => _DeliveryInfoSectionState();
}

class _DeliveryInfoSectionState extends State<DeliveryInfoSection> {
  AddressModel? selectedAddress;
  late TextEditingController noteController;
  bool isEditingNote = false;
  late String currentNote;

  @override
  void initState() {
    super.initState();
    currentNote = widget.note;
    noteController = TextEditingController(text: currentNote);
    _loadDefaultAddress();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultAddress() async {
    // Lấy userId để có thể gọi controller (nếu cần, hoặc dùng token trong service)
    final userId = await UserSession.getUserId();

    if (userId != null) {
      // Gọi getAddresses() không truyền tham số vì hàm không nhận userId
      final addresses = await AddressController().getAddresses();

      if (addresses.isNotEmpty) {
        setState(() {
          selectedAddress = addresses.firstWhere(
                (e) => e.isDefault,
            orElse: () => addresses.first,
          );
        });
        widget.onAddressChanged(selectedAddress!);
      }
    }
  }


  void _openAddressDialog({AddressModel? initial}) {
    final nameController = TextEditingController(text: initial?.name ?? '');
    final phoneController = TextEditingController(text: initial?.phone ?? '');
    final addressController = TextEditingController(text: initial?.address ?? '');
    bool makeDefault = initial?.isDefault ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(initial == null ? "Thêm địa chỉ" : "Cập nhật địa chỉ"),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Tên người nhận'),
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập tên người nhận'
                            : null,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Số điện thoại'),
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập số điện thoại'
                            : null,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Địa chỉ'),
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập địa chỉ'
                            : null,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: makeDefault,
                            onChanged: (v) => setDialogState(() {
                              makeDefault = v ?? false;
                            }),
                          ),
                          const Text("Đặt làm mặc định"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.dispose();
                    phoneController.dispose();
                    addressController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text("Huỷ"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final userId = await UserSession.getUserId();
                    if (userId == null) {
                      // Bạn có thể show snackbar báo lỗi user chưa đăng nhập
                      return;
                    }

                    final newAddress = AddressModel(
                      id: initial?.id ?? 0,
                      userId: userId,
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: addressController.text.trim(),
                      isDefault: makeDefault,
                    );

                    try {
                      if (initial == null) {
                        await AddressController().addAddress(newAddress);
                      } else {
                        await AddressController().updateAddress(newAddress);
                      }
                      Navigator.pop(context);
                      nameController.dispose();
                      phoneController.dispose();
                      addressController.dispose();
                      await _loadDefaultAddress();
                    } catch (e) {
                      // Có thể show snackbar lỗi lưu địa chỉ
                      // Ví dụ: _showSnackBar('Lỗi lưu địa chỉ: $e');
                    }
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: selectedAddress == null
                    ? const Text("Chưa có địa chỉ. Hãy thêm mới.")
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selectedAddress!.name} - ${selectedAddress!.phone}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(selectedAddress!.address),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openAddressDialog(initial: selectedAddress),
                icon: const Icon(Icons.edit, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Ghi chú:"),
          isEditingNote
              ? Column(
            children: [
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: "Nhập ghi chú..."),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentNote = noteController.text;
                        isEditingNote = false;
                      });
                      widget.onNoteChanged(currentNote);
                    },
                    child: const Text("Lưu"),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      noteController.text = currentNote;
                      setState(() => isEditingNote = false);
                    },
                    child: const Text("Huỷ"),
                  )
                ],
              )
            ],
          )
              : Row(
            children: [
              Expanded(child: Text(currentNote.isEmpty ? "Không có ghi chú." : currentNote)),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => setState(() => isEditingNote = true),
              ),
            ],
          )
        ],
      ),
    );
  }
}
