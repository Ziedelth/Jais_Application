import 'dart:convert';
import 'dart:typed_data';

import 'package:brotli/brotli.dart';

String fromUTF8(List<int> bytes) {
  return utf8.decode(bytes);
}

Uint8List fromBase64(String string) {
  return base64.decode(string);
}

String fromBrotly(String string) {
  return fromUTF8(brotli.decode(fromBase64(string.trim())));
}
