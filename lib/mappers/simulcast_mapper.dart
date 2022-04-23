import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/models/simulcast.dart';
import 'package:url/url.dart';

class SimulcastMapper {
  List<Simulcast>? list;

  void clear() {
    list = null;
  }

// Convert a String? to a List<Simulcast>?
  List<Simulcast>? stringToSimulcasts(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Simulcast.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

// Update the list of simulcasts
  Future<void> update({
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    const link = 'https://api.ziedelth.fr/v1/simulcasts';
    final url = URL();
    debugPrint('[SimulcastMapper] Fetching $link');
    final response = await url.get(link);
    debugPrint('[SimulcastMapper] Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      debugPrint('[SimulcastMapper] Request failed');
      onFailure?.call();
      return;
    }

    debugPrint('[SimulcastMapper] Request success');
    final simulcasts = stringToSimulcasts(utf8.decode(response.bodyBytes));
    debugPrint('[SimulcastMapper] Simulcasts: ${simulcasts?.length}');

    // If scans is null or empty, then the request failed
    if (simulcasts == null || simulcasts.isEmpty) {
      debugPrint('[SimulcastMapper] Conversion failed');
      onFailure?.call();
      return;
    }

    debugPrint('[SimulcastMapper] Conversion success');
    list = simulcasts;
    // Call the onSuccess callback
    onSuccess?.call();
  }
}
