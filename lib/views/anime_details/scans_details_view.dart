import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/anime.dart';

class ScansDetailsView extends StatelessWidget {
  final Anime _anime;
  late final List<Widget> _scans;

  ScansDetailsView(this._anime) {
    _scans = _anime.scans
        .map<Widget>(
          (element) => ScanWidget(scan: element),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_anime.scans.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            Text("Il n'y a pas de scans pour cet anime"),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ScanList(
            children: _scans,
          ),
        ),
      ],
    );
  }
}
