import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class RequestAddress {
  static Future<Map<String, dynamic>> getRequest(String url) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);
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
