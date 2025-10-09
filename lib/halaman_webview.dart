import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HalamanWebView extends StatefulWidget {
  final String title;
  final String url;

  const HalamanWebView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<HalamanWebView> createState() => _HalamanWebViewState();
}

class _HalamanWebViewState extends State<HalamanWebView> {
  // Controller untuk mengelola webview
  late final WebViewController _controller;
  bool _isLoading = true; // State untuk menunjukkan loading

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Hentikan loading saat halaman selesai dimuat
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Muat URL yang diberikan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
      ),
      // Gunakan Stack untuk menumpuk loading indicator di atas webview
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}