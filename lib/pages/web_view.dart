import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewClass extends StatefulWidget {
  final String url;
  const WebViewClass({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewClassState createState() => _WebViewClassState(url: url);
}

class _WebViewClassState extends State<WebViewClass> {
  final String url;
  bool isLoading = true;

  _WebViewClassState({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter WebView"),
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
