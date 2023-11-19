import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'response_parser.dart';

class ApiResponseDisplay extends StatefulWidget {
  const ApiResponseDisplay({super.key});

  @override
  _ApiResponseDisplayState createState() => _ApiResponseDisplayState();
}

class _ApiResponseDisplayState extends State<ApiResponseDisplay> {
  dynamic apiResponse;
  bool isLoading = false;

  final ApiService _apiService = ApiService();

  Future<void> makeApiCall(Future<dynamic> Function() apiCall) async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await apiCall();
      if (response is http.StreamedResponse) {
        String responseBody = await response.stream.bytesToString();
        setState(() {
          apiResponse =
              jsonDecode(responseBody); // Modify as per your response handling
        });
      } else {
        setState(() {
          apiResponse = response;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Response Display'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () => makeApiCall(_apiService.fetchProducts),
                  child: const Text('Call Third API'),
                ),
                Expanded(
                  child: apiResponse != null
                      ? ResponseParser.buildDynamicResponse(apiResponse)
                      : const Center(child: Text('No data received yet.')),
                ),
              ],
            ),
    );
  }
}
