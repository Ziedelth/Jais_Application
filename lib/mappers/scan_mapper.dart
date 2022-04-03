import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const limit = 18;
int currentPage = 1;

List<Widget> get defaultList =>
    List.filled(limit, const ScanLoaderWidget(), growable: true);
List<Widget> list = defaultList;

void clear() {
  currentPage = 1;
  list = defaultList;
}

void addLoader() {
  list.addAll(defaultList);
}

void removeLoader() {
  list.removeWhere((element) => element is ScanLoaderWidget);
}

Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
}) async {
  await get(
    "https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$limit/scans",
    (success) {
      try {
        removeLoader();
        list.addAll(
          (jsonDecode(success) as List<dynamic>)
              .map(
                (e) => ScanWidget(
                  scan: Scan.fromJson(e as Map<String, dynamic>),
                ),
              )
              .toList(),
        );
        onSuccess?.call();
      } catch (exception, stackTrace) {
        // Print exception and stack trace to the console
        debugPrint("Exception: $exception\nStackTrace: $stackTrace");

        onFailure?.call();
      }
    },
    (failure) {
      onFailure?.call();
    },
  );
}
