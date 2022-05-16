library url;

import 'package:http/http.dart' as http;

class URL {
  Future<http.Response?> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      return await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  Future<http.Response?> post(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    try {
      return await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }
}
