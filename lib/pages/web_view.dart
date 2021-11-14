import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  final String url;
  final String title;

  const WebViewClass({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  _WebViewClassState createState() =>
      _WebViewClassState(title: title, url: url);
}

class _WebViewClassState extends State<WebViewClass> {
  final String url;
  final String title;
  bool isLoading = true;

  _WebViewClassState({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
