import 'dart:convert';

import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

abstract class JMapper<T> {
  final String url;
  final T Function(Map<String, dynamic>) fromJson;
  List<T> list = <T>[];

  JMapper({
    required this.url,
    required this.fromJson,
  });

  void clear() {
    list.clear();
  }

  List<T>? stringTo(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> update() async {
    if (this.list.isNotEmpty) return;

    final response = await URL().get(url);

    if (!response.isOk) {
      return;
    }

    final list = stringTo(fromBrotli(response!.body));

    if (list == null || list.isEmpty) {
      return;
    }

    this.list = list;
  }
}
