import 'package:flutter/material.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanWidget extends StatelessWidget {
  final Scan scan;
  final Function(Scan scan)? onUp;
  final Function(Scan scan)? onDown;

  const ScanWidget({required this.scan, this.onUp, this.onDown, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PlatformWidget(scan.platform),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    scan.anime.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${scan.episodeType.fr} ${scan.number} ${scan.langType.fr} ',
            ),
            const SizedBox(height: 5),
            Text(
              'Il y a ${printTimeSince(DateTime.parse(scan.releaseDate))}',
            ),
          ],
        ),
      ),
      onTap: () => launchUrl(Uri.parse(scan.url)),
    );
  }
}
