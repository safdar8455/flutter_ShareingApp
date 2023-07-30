import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAddress {
  static Future<Map<String, dynamic>> getRequest(String url) async {
    Uri uri = Uri.parse(url); // Convert the url string to a Uri object
    http.Response response = await http.get(uri); // Use the Uri object here
    try {
      if (response.statusCode == 200) {
        String jData = response.body;
        return jsonDecode(jData);
      } else {
        throw Exception(
            'Failed to make the request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to process the response: $e');
    }
  }
}
