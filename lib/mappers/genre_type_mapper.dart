import 'dart:convert';

import 'package:jais/models/genre.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class GenreMapper {
  List<Genre> list = [];

  List<Genre>? stringToGenres(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> update() async {
    final response = await URL().get(
      'https://api.ziedelth.fr/v2/genres',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    final genres = stringToGenres(fromBrotly(response.body));

    if (genres == null || genres.isEmpty) {
      return;
    }

    list = genres;
  }
}
