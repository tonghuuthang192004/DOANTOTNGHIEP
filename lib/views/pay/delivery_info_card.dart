import 'package:flutter/material.dart';
import '../../../models/address/address_model.dart';
import '../../../controllers/address/address_controller.dart';
import '../../../services/user/user_session.dart';
import '../../views/change_address/address_dialog.dart';
import '../change_address/address_list_dialog.dart';

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

  Future<void> _openAddressListDialog() async {
    final AddressModel? chosenAddress = await showDialog<AddressModel>(
      context: context,
      builder: (_) => AddressListDialog(
        selectedAddress: selectedAddress,
        onAddressSelected: (AddressModel address) {
          Navigator.pop(context, address);
        },
      ),
    );

    if (chosenAddress != null) {
      setState(() => selectedAddress = chosenAddress);
      widget.onAddressChanged(chosenAddress);
    }
  }

  Future<void> _openAddAddressDialog() async {
    final AddressModel? newAddress = await showDialog<AddressModel>(
      context: context,
      builder: (_) => AddressDialog(
        address: null,
        onSave: (AddressModel savedAddress) async {
          await AddressController().addAddress(savedAddress);
          _loadDefaultAddress();
          Navigator.pop(context, savedAddress);
        },
      ),
    );

    if (newAddress != null) {
      setState(() => selectedAddress = newAddress);
      widget.onAddressChanged(newAddress);
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
                child: GestureDetector(
                  onTap: _openAddressListDialog,
                  child: selectedAddress == null
                      ? const Text("📍 Chưa có địa chỉ. Nhấn để thêm mới.")
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${selectedAddress!.name} - ${selectedAddress!.phone}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(selectedAddress!.address),
                      Text(
                        "${selectedAddress!.ward}, ${selectedAddress!.district}, ${selectedAddress!.city}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _openAddAddressDialog,
                tooltip: "Thêm địa chỉ mới",
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
                    child: const Text("Hủy"),
                  ),
                ],
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: Text(
                  currentNote.isEmpty ? "Không có ghi chú." : currentNote,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: selectedAddress == null
                    ? null
                    : () => setState(() => isEditingNote = true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
