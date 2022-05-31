import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/simulcasts/simulcast_loader_widget.dart';
import 'package:jais/components/simulcasts/simulcast_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class SimulcastMapper extends IMapper<Simulcast> {
  SimulcastMapper()
      : super(limit: 5, loaderWidget: const SimulcastLoaderWidget());

  @override
  List<Simulcast> stringTo(String string) {
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Simulcast.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  List<Widget> toWidgets(List<Simulcast> objects) {
    return objects.map((e) => SimulcastWidget(simulcast: e)).toList();
  }

  @override
  Future<void> updateCurrentPage() async {
    addLoader();

    final response = await URL().get(
      'https://api.ziedelth.fr/v2/simulcasts',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    removeLoader();
  }
}
