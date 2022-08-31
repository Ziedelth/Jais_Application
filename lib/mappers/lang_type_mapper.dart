import 'dart:convert';

import 'package:jais/models/lang_type.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart';
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
    if (list.isNotEmpty) return;

    Logger.info('Get all lang types...');
    final response = await URL().get(getLangTypesUrl());

    if (response == null || response.statusCode != 200) {
      Logger.error('An error occurred while getting all lang types');
      return;
    }

    final langTypes = stringToLangTypes(fromBrotli(response.body));

    if (langTypes == null || langTypes.isEmpty) {
      Logger.error('An error occurred while getting all lang types');
      return;
    }

    Logger.debug('Lang types: ${langTypes.length}');
    langTypes.removeWhere((element) => element.name == 'UNKNOWN');
    list = langTypes;
  }
}
