import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

class ScanMapper {
  static const limit = 18;
  static int currentPage = 1;

  static List<Widget> get defaultList =>
      List.filled(limit, const ScanLoaderWidget(), growable: true);
  static List<Widget> list = defaultList;

  static void clear() {
    currentPage = 1;
    list = defaultList;
  }

  static void addLoader() {
    list.addAll(defaultList);
  }

  // Remove all scan loader widgets from list
  static void removeLoader() {
    list.removeWhere((element) => element is ScanLoaderWidget);
  }

  static Future<void> updateCurrentPage(
      {Function? onSuccess, Function? onFailure}) async {
    await Utils.get(
      "https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$limit/scans",
      (success) {
        removeLoader();
        list.addAll((jsonDecode(success) as List<dynamic>)
            .map((e) => ScanWidget(scan: Scan.fromJson(e)))
            .toList());
        onSuccess?.call();
      },
      (failure) {
        onFailure?.call();
      },
    );
  }
}
