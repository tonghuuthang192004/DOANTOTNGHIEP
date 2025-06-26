import 'package:flutter/material.dart';
import '../../controllers/user/update_proflie_controller.dart';
import '../../utils/dimensions.dart';

import '../../models/user/user_model.dart';
import '../profile/profile_screen.dart';
// Không cần import ProfilePage nếu bạn chỉ muốn pop về trang trước
// import '../profile/profile_screen.dart';

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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Center(
          child: Text('Cập nhật thông tin', style: TextStyle(fontSize: Dimensions.font18)),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text('Lưu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: Dimensions.font16)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: Dimensions.height50,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : const AssetImage('images/fried_chicken.png') as ImageProvider,
                backgroundColor: const Color(0xFFF5F5F5),
              ),
              Positioned(
                bottom: 0,
                right: 0,
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
            ],
          ),
          SizedBox(height: Dimensions.height15),
          TextButton(
            onPressed: () {
              // TODO: chọn ảnh mới (nếu có chức năng upload)
            },
            child: Text('Thay đổi ảnh đại diện', style: TextStyle(color: Colors.orange, fontSize: Dimensions.font14)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Họ và tên',
            icon: Icons.person,
            validator: (value) => value?.isEmpty == true ? 'Vui lòng nhập họ tên' : null,
          ),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
          ),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty == true ? 'Vui lòng nhập số điện thoại' : null,
          ),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            controller: _birthdayController,
            label: 'Ngày sinh',
            icon: Icons.cake,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: Dimensions.height20),
          _buildGenderSelector(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
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
        Text(
          'Giới tính',
          style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: Dimensions.height12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Nam', style: TextStyle(fontSize: Dimensions.font14)),
                value: 'Nam',
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value!),
                activeColor: Colors.orange,
              ),
            ),
            SizedBox(width: Dimensions.width12),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Nữ', style: TextStyle(fontSize: Dimensions.font14)),
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

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _birthdayController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }


  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận cập nhật'),
          content: const Text('Bạn có chắc chắn muốn lưu thay đổi không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      final result = await _controller.updateProfile(
        ten: _nameController.text,
        soDienThoai: _phoneController.text,
        gioiTinh: selectedGender,
        avatar: avatarUrl,
      );

      final success = result['success'] == true;
      final message = result['message'] ?? 'Không có phản hồi từ máy chủ';

      if (!mounted) return;

      if (success) {
        // ✅ Hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cập nhật thành công!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // ✅ Đợi hiển thị SnackBar xong
        await Future.delayed(const Duration(seconds: 2));

        // ✅ Chuyển về trang ProfilePage (xóa ngăn xếp cũ)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
                (route) => false, // Xóa toàn bộ stack cũ
          );
        }
      } else {
        // ❌ Cập nhật thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}