library url;

import 'package:http/http.dart' as http;

class URL {
  Future<http.Response?> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      return http.get(Uri.parse(url), headers: headers);
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
      return http.post(Uri.parse(url), headers: headers, body: body);
    } catch (_) {
      return null;
    }
  }
}
