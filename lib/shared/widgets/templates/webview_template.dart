import 'dart:io';
import 'package:logistika/shared/widgets/loading_app.dart';
import 'package:logistika/shared/widgets/templates/appbar_template.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTemplate extends StatefulWidget {
  final String? title;
  final String? url;
  const WebViewTemplate({
    required this.title,
    this.url: "",
  });

  @override
  WebViewTemplateState createState() => WebViewTemplateState();
}

class WebViewTemplateState extends State<WebViewTemplate> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingApp(
      isLoading: isLoading,
      child: AppbarTemplate(
        title: widget.title!,
        isCustom: true,
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {},
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{},
          onPageStarted: (String percent) {
            print('Page started loading: $percent');
            setState(() => isLoading = true);
          },
          onPageFinished: (String percent) {
            print('Page finished loading: $percent');
            setState(() => isLoading = false);
          },
          gestureNavigationEnabled: true,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
