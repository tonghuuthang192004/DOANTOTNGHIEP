import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Hàm chọn ảnh từ gallery
Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}