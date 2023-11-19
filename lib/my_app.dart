import 'package:any_api_handler/api_response_display.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ApiResponseDisplay(),
    );
  }
}
