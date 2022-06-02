import 'dart:convert';

import 'package:jais/components/scans/scan_loader_widget.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/country.dart';
import 'package:jais/utils/decompress.dart';
import 'package:url/url.dart';

class ScanMapper extends IMapper<Scan> {
  ScanMapper() : super(limit: 33, loaderWidget: ScanLoaderWidget());

  @override
  List<Scan> stringTo(String string) {
    try {
      return (jsonDecode(string) as List<dynamic>)
          .map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  List<ScanWidget> toWidgets(List<Scan> objects) {
    return objects.map((e) => ScanWidget(scan: e)).toList();
  }

  @override
  Future<void> updateCurrentPage() async {
    addLoader();

    final response = await URL().get(
      'https://api.ziedelth.fr/v2/scans/country/${Country.name}/page/$currentPage/limit/$limit',
    );

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(stringTo(fromBrotly(response.body))));
    removeLoader();
  }
}
