import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/utils.dart';

class ScanMapper {
  static const limit = 18;
  static int currentPage = 1;
  static List<Widget> list =
      List.filled(limit, const ScanLoaderWidget(), growable: true);

  static void clear() {
    currentPage = 1;
    list = List.filled(limit, const ScanLoaderWidget(), growable: true);
  }

  static void addLoader() {
    list.addAll(List.filled(limit, const ScanLoaderWidget(), growable: true));
  }

  static Future<void> updateCurrentPage(
      {Function? onSuccess, Function? onFailure}) async {
    await Utils.request(
      "https://ziedelth.fr/api/v1/country/fr/page/$currentPage/limit/$limit/scans",
      (success) {
        list.removeWhere((element) => element is ScanLoaderWidget);
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
