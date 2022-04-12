import 'package:http/http.dart' as http;

class URLMapper {
  static const String baseURL = "https://api.ziedelth.fr/";

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

  Future<http.Response?> getOwn(
    String url, {
    Map<String, String>? headers,
  }) async =>
      get(baseURL + url, headers: headers);

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

  Future<http.Response?> postOwn(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async =>
      post(baseURL + url, headers: headers, body: body);
}
