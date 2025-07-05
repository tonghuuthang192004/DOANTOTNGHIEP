import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import '../../controllers/user/update_proflie_controller.dart';
import '../../utils/dimensions.dart';
import '../profile/profile_screen.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? avatarUrl; // URL ảnh hiện tại từ server
  File? newAvatarFile; // Ảnh mới user chọn

  final _controller = UpdateProfileController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// 🔄 Load user profile từ API
  Future<void> _loadUserProfile() async {
    final user = await _controller.getCurrentUserProfile();
    if (user != null) {
      setState(() {
        _nameController.text = user.ten;
        _phoneController.text = user.soDienThoai;
        avatarUrl = user.avatar;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<File> convertToJPG(File file) async {
    // Đọc file ảnh vào memory
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Không thể đọc file ảnh');
    }

    // Encode lại ảnh thành JPG với chất lượng 90%
    final jpg = img.encodeJpg(image, quality: 90);

    // Tạo file mới đường dẫn .jpg
    final newPath = file.path.replaceAll(RegExp(r'\.\w+$'), '.jpg');
    final newFile = File(newPath);

    // Ghi file JPG mới
    await newFile.writeAsBytes(jpg);

    return newFile;
  }

  /// 📷 Hiện bottom sheet chọn ảnh từ Camera hoặc Gallery
  Future<void> _showAvatarOptions() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.orange),
                title: const Text('Chụp ảnh mới'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    File avatarFile = File(pickedFile.path);
                    avatarFile = await convertToJPG(avatarFile);
                    setState(() {
                      newAvatarFile = avatarFile;
                    });
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.orange),
                title: const Text('Chọn từ thư viện'),
                onTap: () async {
                  Navigator.pop(context);
                  await requestGalleryPermission();
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    File avatarFile = File(pickedFile.path);
                    avatarFile = await convertToJPG(avatarFile);
                    setState(() {
                      newAvatarFile = avatarFile;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> requestGalleryPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        throw Exception('Ứng dụng cần quyền truy cập bộ nhớ để chọn ảnh.');
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
      if (!status.isGranted) {
        throw Exception('Ứng dụng cần quyền truy cập ảnh để chọn ảnh.');
      }
    }
  }


  /// 💾 Lưu thay đổi profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

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
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isLoading = true);

    try {
      // 📝 Cập nhật tên và SĐT
      final infoResult = await _controller.updateProfileInfo(
        ten: _nameController.text.trim(),
        soDienThoai: _phoneController.text.trim(),
      );

      // 📸 Nếu có avatar mới thì upload
      Map<String, dynamic> avatarResult = {'success': true};
      if (newAvatarFile != null) {
        avatarResult = await _controller.uploadAvatar(newAvatarFile!);
      }

      setState(() => isLoading = false);

      if (!mounted) return;

      bool isSuccess(dynamic value) => value == true || value == 'true';

      print('📦 [DEBUG] infoResult: $infoResult');
      print('📦 [DEBUG] avatarResult: $avatarResult');

      if (isSuccess(infoResult['success']) ||
          isSuccess(avatarResult['success'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cập nhật thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
          (_) => false,
        );
      } else {
        final errorMsg = infoResult['message'] ??
            avatarResult['message'] ??
            'Cập nhật thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMsg'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Cập nhật thông tin'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Lưu',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
    ImageProvider avatarImage;
    if (newAvatarFile != null) {
      avatarImage = FileImage(newAvatarFile!);
    } else if (avatarUrl != null) {
      avatarImage = NetworkImage(avatarUrl!);
    } else {
      avatarImage = const AssetImage('images/avatar.jpg');
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.height25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: Dimensions.height50,
                backgroundImage: avatarImage,
                onBackgroundImageError: (_, __) {
                  setState(() {
                    avatarUrl = null; // fallback về ảnh mặc định
                  });
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showAvatarOptions,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.height8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.camera_alt,
                        color: Colors.white, size: Dimensions.iconSize20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          TextButton(
            onPressed: _showAvatarOptions,
            child: const Text('Thay đổi ảnh đại diện',
                style: TextStyle(color: Colors.orange)),
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
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            _nameController,
            'Họ và tên',
            Icons.person,
            validator: (v) => v!.isEmpty ? 'Nhập họ tên' : null,
          ),
          SizedBox(height: Dimensions.height20),
          _buildTextField(
            _phoneController,
            'Số điện thoại',
            Icons.phone,
            validator: (v) => v!.isEmpty ? 'Nhập số điện thoại' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
