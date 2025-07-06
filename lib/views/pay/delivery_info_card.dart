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
    final userId = await UserSession.getUserId();

    if (userId != null) {
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
              // Bỏ nút sửa/xóa địa chỉ ở đây
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
          ),
        ],
      ),
    );
  }
}
