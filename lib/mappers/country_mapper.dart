import 'dart:convert';

import 'package:jais/models/country.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:url/url.dart';

class CountryMapper {
  static Country? selectedCountry;
  static List<Country> list = [];

  List<Country>? stringTo(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> update() async {
    final response = await URL().get(getCountriesUrl());

    if (response == null || response.statusCode != 200) {
      return;
    }

    final countries = stringTo(fromBrotli(response.body));

    if (countries == null || countries.isEmpty) {
      return;
    }

    list = countries;
    // Set the selected country to the first one in the list
    selectedCountry = list.first;
  }
}
