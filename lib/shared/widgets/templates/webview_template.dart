import 'package:myapp/shared/widgets/loading_app.dart';
import 'package:myapp/shared/widgets/templates/appbar_template.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTemplate extends StatefulWidget {
  final String? title;
  final String? url;
  const WebViewTemplate({
    super.key,
    required this.title,
    this.url = "",
  });

  @override
  WebViewTemplateState createState() => WebViewTemplateState();
}

class WebViewTemplateState extends State<WebViewTemplate> {
  var isLoading = false;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return LoadingApp(
      isLoading: isLoading,
      child: AppbarTemplate(
        title: widget.title!,
        isCustom: true,
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
