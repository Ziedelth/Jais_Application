import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/scans/scan_widget.dart';
import 'package:jais/models/anime_details.dart';

class ScansDetailsView extends StatelessWidget {
  final AnimeDetails _animeDetails;
  late final List<Widget> _scans;

  ScansDetailsView(this._animeDetails) {
    _scans = _animeDetails.scans
        .map<Widget>(
          (element) => ScanWidget(scan: element),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_animeDetails.scans.isEmpty) {
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
          child: JList(
            children: _scans,
          ),
        ),
      ],
    );
  }
}
