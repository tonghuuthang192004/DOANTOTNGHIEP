
import 'package:flutter/material.dart';
import 'package:frontendtn1/widgets/bottom_navigation_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/cart/cart_service.dart';

class WebViewPaymentPage extends StatefulWidget {
  final String url;
  const WebViewPaymentPage({super.key, required this.url});

  @override
  State<WebViewPaymentPage> createState() => _WebViewPaymentPageState();
}

class _WebViewPaymentPageState extends State<WebViewPaymentPage> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool isResultSent = false; // ✅ Tránh pop 2 lần

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint("🌐 [WebView] Bắt đầu tải: $url");
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            debugPrint("✅ [WebView] Tải xong: $url");
            setState(() => isLoading = false);
          },
          onNavigationRequest: (request) async {
            debugPrint("➡️ [WebView] Điều hướng: ${request.url}");
            if (await _handlePaymentResult(request.url)) {
              return NavigationDecision.prevent; // ✅ Ngăn điều hướng sau khi xử lý
            }
            if (request.url.startsWith("momo://")) {
              debugPrint("⛔ Chặn mở app MoMo: ${request.url}");
              return NavigationDecision.prevent; // ✅ Chặn mở app MoMo
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// 📦 Xử lý kết quả thanh toán từ URL
  Future<bool> _handlePaymentResult(String url) async {
    if (isResultSent) return false;

    if (url.contains("status=0") || url.contains("success") || url.contains("errorCode=0")) {
      debugPrint("🎉 Thanh toán thành công: $url");
      isResultSent = true;
      await CartService.clearCart();

      // ✅ Điều hướng về trang Home (dùng trực tiếp widget)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNavigation()),
            (Route<dynamic> route) => false,
      );

      return true;
    }

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isResultSent) {
          Navigator.pop(context, false); // 👈 Khi bấm Back, trả về thất bại
        }
        return false; // ✅ Ngăn pop mặc định
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán MoMo'),
          backgroundColor: Colors.pink,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                  alignment: Alignment.topCenter,
                  child:      QrImageView(data: widget.url,size: 300,),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40,vertical: 40),
                  child: Text('Bạn Vui Lòng Thanh Toán Qua MoMo',style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,

                    fontSize: 30,
                  ),
                    textAlign: TextAlign.center,

                  ),
                )

              ],
            ),

          ],
        ),
      ),
    );
  }
}
