import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatelessWidget {
  final String url;
  WebViewClass({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    return WebView(
      initialUrl: url,
    );
  }
}
