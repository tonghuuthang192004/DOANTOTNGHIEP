// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class TestApiPage extends StatefulWidget {
//   const TestApiPage({super.key});
//
//   @override
//   State<TestApiPage> createState() => _TestApiPageState();
// }
//
// class _TestApiPageState extends State<TestApiPage> {
//   bool _isLoading = false;
//
//   Future<void> _sendRegisterRequest() async {
//     setState(() => _isLoading = true);
//
//     final url = Uri.parse('http://10.0.2.2:3000/users/dang-ky');
//     final body = jsonEncode({
//       'ten': 'Nguyen Van Test',
//       'email': 'test_${DateTime.now().millisecondsSinceEpoch}@example.com',
//       'mat_khau': '123456',
//       'so_dien_thoai': '0123456789',
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );
//
//       final data = jsonDecode(response.body);
//       final status = response.statusCode;
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('[$status] ${data['message']}'),
//           backgroundColor: status == 201 ? Colors.green : Colors.red,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Lỗi kết nối: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test API: Đăng ký'),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//           onPressed: _sendRegisterRequest,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepOrange,
//             padding: const EdgeInsets.symmetric(
//                 vertical: 14, horizontal: 28),
//           ),
//           child: const Text('Gửi yêu cầu đăng ký'),
//         ),
//       ),
//     );
//   }
// }
