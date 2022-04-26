import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/country.dart';
import 'package:logger/logger.dart' as logger;
import 'package:url/url.dart';

class ScanMapper {
  static const limit = 27;
  int currentPage = 1;
  List<Widget> list = _defaultList;

  static List<Widget> get _defaultList => List.filled(
        limit,
        const ScanLoaderWidget(),
        growable: true,
      );

  void clear() {
    currentPage = 1;
    list = _defaultList;
  }

  void addLoader() => list.addAll(_defaultList);

  void removeLoader() =>
      list.removeWhere((element) => element is ScanLoaderWidget);

// Convert a String? to a List<Scan>?
  static List<Scan>? stringToScans(String? string) {
    if (string == null) return null;

    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

// Convert a List<Scan> to List<ScanWidget>
  static List<ScanWidget> scansToWidgets(
    List<Scan> scans, {
    Function(Scan scan)? onUp,
    Function(Scan scan)? onDown,
  }) {
    return scans
        .map(
          (e) => ScanWidget(
            scan: e,
            onUp: onUp,
            onDown: onDown,
          ),
        )
        .toList();
  }

// Update the list of scans
  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
    Function(Scan scan)? onUp,
    Function(Scan scan)? onDown,
  }) async {
    final link =
        'https://api.ziedelth.fr/v1/scans/country/${Country.name}/page/$currentPage/limit/$limit';
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
    final scans = stringToScans(utf8.decode(response.bodyBytes));
    logger.info('Scans: $scans');

    // If scans is null or empty, then the request failed
    if (scans == null || scans.isEmpty) {
      logger.warning('Failed to convert in scans list');
      onFailure?.call();
      return;
    }

    logger.info('Successfully converted in scans list');
    // Convert the scans to widgets
    final widgets = scansToWidgets(
      scans,
      onUp: onUp,
      onDown: onDown,
    );

    // Remove the loader
    removeLoader();
    // Add widgets to the list
    list.addAll(widgets);
    // Call the onSuccess callback
    onSuccess?.call();
  }
}
