// File: api_service.dart
import 'package:http/http.dart' as http;

class ApiService {
  String token = "";
  String urlOne = '';
  String urlTwo = '';
  String urlThreee = '';
  String server_key = '';

  Future<dynamic> fetchProducts() async {
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(urlThreee));
    request.fields.addAll({'server_key': server_key});

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return response;
      } else {
        print(
            'Request failed with status: ${response.statusCode}. Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
