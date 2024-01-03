import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:calculate_all/layouts/web_content.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;
import 'package:image_picker/image_picker.dart' as image_picker;

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;
  String url = 'https://calculateall.net';
  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(
      Uri.parse(url)
    )..setJavaScriptMode(JavaScriptMode.unrestricted)..addJavaScriptChannel('SnackBar', onMessageReceived: (message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)) );
    });
    initFilePicker();
  }

  initFilePicker() async {
    if (Platform.isAndroid) {
      final androidController = (controller.platform
          as webview_flutter_android.AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  /// This method is called when the user tries to upload a file from the webview.
  /// It will open the file picker and return the selected files.
  /// If the user cancels the file picker, it will return an empty list.
  ///
  /// Returns uri's of the selected files.
  Future<List<String>> _androidFilePicker(
      webview_flutter_android.FileSelectorParams params) async {
    if (params.acceptTypes.any((type) => type == 'image/*')) {
      final picker = image_picker.ImagePicker();
      final photo =
          await picker.pickImage(source: image_picker.ImageSource.camera);

      if (photo == null) {
        return [];
      }
      return [Uri.file(photo.path).toString()];
    } else if (params.acceptTypes.any((type) => type == 'video/*')) {
      final picker = image_picker.ImagePicker();
      final vidFile = await picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
      if (vidFile == null) {
        return [];
      }
      return [Uri.file(vidFile.path).toString()];
    } else {
      try {
        if (params.mode ==
            webview_flutter_android.FileSelectorMode.openMultiple) {
          final attachments =
              await FilePicker.platform.pickFiles(allowMultiple: true);
          if (attachments == null) return [];

          return attachments.files
              .where((element) => element.path != null)
              .map((e) => File(e.path!).uri.toString())
              .toList();
        } else {
          final attachment = await FilePicker.platform.pickFiles();
          if (attachment == null) return [];
          File file = File(attachment.files.single.path!);
          return [file.uri.toString()];
        }
      } catch (e) {
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebContent(
        controller: controller,
      ),
    );
  }
}
