import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebContent extends StatefulWidget {
  const WebContent({super.key, required this.controller});
  final WebViewController controller;

  @override
  State<WebContent> createState() => _WebContentState();
}

class _WebContentState extends State<WebContent> {
  int progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            progress = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            progress = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            progress = 100;
          });
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await widget.controller.canGoBack()) {
          widget.controller.goBack();
          return false; // Consume the back press
        } else {
          SystemNavigator.pop();
          return true; // Allow leaving the current screen
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: widget.controller),
            if(progress < 100) 
              const Center(
                child: CircularProgressIndicator()
              )
          ],
        ),
      ),
    );
  }
}