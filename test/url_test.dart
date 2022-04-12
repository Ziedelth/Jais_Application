import 'package:flutter_test/flutter_test.dart';
import 'package:jais/mappers/url_mapper.dart';

void main() {
  group('URL Test', () {
    // Create URLMapper
    final urlMapper =  URLMapper();
    // Init var with google url
    const url = 'https://www.google.com';

    test('Get URL', () async {
      // Get URL
      final urlResult = await urlMapper.get(url);

      // Check is status code is 200
      expect(urlResult?.statusCode, 200);
    });

    test('Own Get URL', () async {
      // Get URL
      final urlResult = await urlMapper.getOwn('countries');

      // Check is status code is 200
      expect(urlResult?.statusCode, 200);
    });

    test('Post URL', () async {
      // Post URL
      final urlResult = await urlMapper.post(url);

      // Check is status code is 405
      expect(urlResult?.statusCode, 405);
    });
  });
}
