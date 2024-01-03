import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/services.dart';
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
          if (!url.startsWith('https://calculateall.net')) {
            Navigator.pop(context);
            launchURL(url);
          }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool isClosing) async {
        if (await widget.controller.canGoBack()) {
          widget.controller.goBack();
          // widget.controller.getTitle().then((value) => print(value));
        } else {
          // If there's no history to navigate back, leave the current screen
          SystemNavigator.pop();
        }
      },
      child: Stack(
        children: [
          WebViewWidget(
            controller: widget.controller,
          ),
          if(progress < 100) 
            const Center(
              child: CircularProgressIndicator()
            )
        ],
      ),
    );
  }

  Future<void> launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}