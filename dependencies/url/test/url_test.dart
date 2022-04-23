import 'package:flutter_test/flutter_test.dart';
import 'package:url/url.dart';

void main() {
  group('URL Test', () {
    // Create URLMapper
    final url = URL();
    // Init var with google url
    const checkUrl = 'https://www.google.com';

    test('Get URL', () async {
      // Get URL
      final urlResult = await url.get(checkUrl);

      // Check is status code is 200
      expect(urlResult?.statusCode, 200);
    });

    test('Post URL', () async {
      // Post URL
      final urlResult = await url.post(checkUrl);

      // Check is status code is 405
      expect(urlResult?.statusCode, 405);
    });
  });
}
