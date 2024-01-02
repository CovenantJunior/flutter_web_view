import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_view/layouts/splash_screen.dart';
import 'package:flutter_web_view/layouts/webview_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make the status bar transparent
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
      routes: {
        '/splash' : (context) => const SplashScreen(),
        '/view' : (context) => const WebView()
      },
    );
    }
}
