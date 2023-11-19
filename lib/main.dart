import 'dart:io';
import 'package:any_api_handler/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
  // ... rest of your main function
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
