import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          onNavigationRequest: (request) {
            debugPrint("➡️ [WebView] Điều hướng: ${request.url}");
            if (_handlePaymentResult(request.url)) {
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
  bool _handlePaymentResult(String url) {
    if (isResultSent) return false; // ✅ Đã xử lý rồi thì bỏ qua

    if (url.contains("status=0") || url.contains("success") || url.contains("errorCode=0")) {
      debugPrint("🎉 Thanh toán thành công: $url");
      isResultSent = true;
      Navigator.pop(context, true); // ✅ Thành công
      return true;
    }

    if (url.contains("status=1") || url.contains("fail") || url.contains("errorCode")) {
      debugPrint("❌ Thanh toán thất bại: $url");
      isResultSent = true;
      Navigator.pop(context, false); // ❌ Thất bại
      return true;
    }

    return false; // 🟢 Chưa có kết quả, tiếp tục điều hướng
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
            WebViewWidget(controller: _controller),
            if (isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.pink)),
          ],
        ),
      ),
    );
  }
}
