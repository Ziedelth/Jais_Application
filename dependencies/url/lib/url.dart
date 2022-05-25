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
    } catch (exception, stackTrace) {
      print('$exception\n$stackTrace');
      return null;
    }
  }

  Future<http.Response?> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      return await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  Future<http.Response?> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      return await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }
}
