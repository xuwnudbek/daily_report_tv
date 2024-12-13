import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

String domain = '176.124.208.61:2000';
String addt = 'api';

String patok = 'patok';
String product = 'product';
String patokanalytics = 'patokanalytics';

String patokish = 'patokish';
String clock = 'clock';
String hourly = 'hourly';

Map<String, String>? hearders = {
  'Content-Type': 'application/json',
};

enum Result { success, error }

class HttpService {
  // GET, POST
  static Future<dynamic> get(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    try {
      // HTTP GET request
      Uri uri = Uri.http(domain, "$addt/$url/", params);

      http.Response response = await http.get(
        uri,
        headers: hearders,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          "status": Result.success,
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "status": Result.error,
          "data": null,
        };
      }
    } catch (e, s) {
      log("Error Catch [get]: $e", error: e, stackTrace: s);
      return {
        "status": Result.error,
        "data": null,
      };
    }
  }

  static Future<dynamic> post(String url, dynamic data) async {
    // HTTP POST request
    try {
      Uri uri = Uri.http(domain, "$addt/$url/");
      http.Response response = await http.post(
        uri,
        body: jsonEncode(data),
        headers: hearders,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": Result.error,
          "data": null,
        };
      }
    } catch (e) {
      log("Error [post]: $e");
      return {
        "status": Result.error,
        "data": null,
      };
    }
  }
}
