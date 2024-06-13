import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:happy_soul/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class Article_Display extends StatelessWidget {

  static const String id = 'article_display';

  const Article_Display({super.key});

  @override
  Widget build(BuildContext context) {

    final text = ModalRoute.of(context)?.settings.arguments;
    var link = '';

    if (text is String) {
      link = text;
    }

    return Scaffold(
      appBar: GradientAppBar(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kSecondaryColor],
        ),
        title: const Text('Article'),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.parse(link),
          ),
      ),
    );
  }
}
