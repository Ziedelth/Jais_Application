import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/utils.dart';

const _limit = 18;
int currentPage = 1;

List<Widget> get _defaultList =>
    List.filled(_limit, const ScanLoaderWidget(), growable: true);
List<Widget> list = _defaultList;

void clear() {
  currentPage = 1;
  list = _defaultList;
}

void addLoader() {
  list.addAll(_defaultList);
}

void removeLoader() {
  list.removeWhere((element) => element is ScanLoaderWidget);
}

Future<void> updateCurrentPage({
  Function()? onSuccess,
  Function()? onFailure,
}) async {
  await get(
    "https://ziedelth.fr/api/v1/country/${Country.name}/page/$currentPage/limit/$_limit/scans",
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
      } catch (_) {
        onFailure?.call();
      }
    },
    (failure) {
      onFailure?.call();
    },
  );
}
