import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../api/api_constants.dart';
import '../../controllers/user/update_proflie_controller.dart';
import '../../models/user/user_token.dart';
import '../../utils/dimensions.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../profile/profile_screen.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  String selectedGender = 'Nam';
  String? avatarUrl;

  final _controller = UpdateProfileController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// 📦 Load user profile từ API
  Future<void> _loadUserProfile() async {
    final user = await _controller.getCurrentUserProfile();
    if (user != null) {
      setState(() {
        _nameController.text = user.ten;
        _emailController.text = user.email;
        _phoneController.text = user.soDienThoai;
        selectedGender = user.gioiTinh ?? 'Nam';
        _birthdayController.text = _formatDate(user.ngaySinh);
        avatarUrl = user.avatar;
      });
    }
  }

  /// 📅 Format ngày yyyy-MM-dd → dd/MM/yyyy
  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
    } catch (_) {
      return '';
    }
  }

  /// 📅 Chuyển ngày dd/MM/yyyy → yyyy-MM-dd
  String? _parseDate(String date) {
    if (date.isEmpty) return null;
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        final parsedDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        return parsedDate.toIso8601String().split('T')[0];
      }
    } catch (_) {}
    return null;
  }

  /// 📸 Chọn ảnh từ gallery
  Future<File?> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// 📤 Upload avatar mới lên server
  Future<void> _changeAvatar() async {
    final imageFile = await _pickImageFromGallery();
    if (imageFile == null) return;

    final token = await UserToken.getToken();
    final uploadUrl = Uri.parse(API.updateAvatar);

    try {
      final request = http.MultipartRequest('POST', uploadUrl);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decoded = jsonDecode(responseBody);

      if (response.statusCode == 200 && decoded['success'] == true) {
        // ✅ Cập nhật avatarUrl ngay
        setState(() {
          avatarUrl = decoded['avatar_url']; // API trả về URL mới
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Avatar đã cập nhật thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Lỗi upload avatar: ${decoded['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi kết nối upload: $e')),
      );
    }
  }

  /// 💾 Lưu profile sau khi chỉnh sửa
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn lưu thay đổi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                      (route) => false, // 👈 Xoá hết stack để về MainNavigation
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Xác nhận'),
            ),

          ],
        ),
      );

      if (confirm != true) return;

      final result = await _controller.updateProfile(
        ten: _nameController.text,
        soDienThoai: _phoneController.text,
        gioiTinh: selectedGender,
        ngaySinh: _parseDate(_birthdayController.text),
        avatar: avatarUrl,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Cập nhật thành công!'), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
              (_) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${result['message']}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// 📅 Chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.orange)),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _birthdayController.text =
      '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Center(child: Text('Cập nhật thông tin')),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatarSection(),
              SizedBox(height: Dimensions.height25),
              _buildFormFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: Dimensions.height50,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : const AssetImage('images/avatar.jpg') as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeAvatar,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.height8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: Dimensions.iconSize20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          TextButton(
            onPressed: _changeAvatar,
            child: const Text('Thay đổi ảnh đại diện', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: EdgeInsets.all(Dimensions.height25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildTextField(_nameController, 'Họ và tên', Icons.person, validator: (v) => v!.isEmpty ? 'Nhập họ tên' : null),
          SizedBox(height: Dimensions.height20),
          _buildTextField(_emailController, 'Email', Icons.email, readOnly: true),
          SizedBox(height: Dimensions.height20),
          _buildTextField(_phoneController, 'Số điện thoại', Icons.phone, validator: (v) => v!.isEmpty ? 'Nhập số điện thoại' : null),
          SizedBox(height: Dimensions.height20),
          _buildTextField(_birthdayController, 'Ngày sinh', Icons.cake, readOnly: true, onTap: () => _selectDate(context)),
          SizedBox(height: Dimensions.height20),
          _buildGenderSelector(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool readOnly = false, String? Function(String?)? validator, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới tính', style: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.font16)),
        SizedBox(height: Dimensions.height12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Nam'),
                value: 'Nam',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value!),
                activeColor: Colors.orange,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Nữ'),
                value: 'Nữ',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value!),
                activeColor: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
