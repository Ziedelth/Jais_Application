import 'dart:convert';

import 'package:jais/models/lang_type.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class LangTypeMapper {
  static final instance = LangTypeMapper();
  List<LangType> list = [];

  List<LangType>? stringToLangTypes(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => LangType.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> update() async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/lang-types',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    final langTypes = stringToLangTypes(fromBrotli(response.body));

    if (langTypes == null || langTypes.isEmpty) {
      return;
    }

    langTypes.removeWhere((element) => element.name == 'UNKNOWN');
    list = langTypes;
  }
}
