import 'dart:convert';

import 'package:jais/models/simulcast.dart';
import 'package:logger/logger.dart' as logger;
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
    logger.info('Fetching $link');
    final response = await url.get(link);
    logger.info('Response: ${response?.statusCode}');

    // If the response is null or the status code is not equals to 200, then the request failed
    if (response == null || response.statusCode != 200) {
      logger.warning('Failed to fetch $link');
      onFailure?.call();
      return;
    }

    logger.info('Successfully fetched $link');
    final simulcasts = stringToSimulcasts(utf8.decode(response.bodyBytes));
    logger.info('Simulcasts: $simulcasts');

    // If scans is null or empty, then the request failed
    if (simulcasts == null || simulcasts.isEmpty) {
      logger.warning('Failed to convert in simulcasts list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in simulcasts list');
    list = simulcasts;
    // Call the onSuccess callback
    onSuccess?.call();
  }
}
