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
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    PlatformWidget(scan.platform),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: Text(
                        scan.anime.name,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  children: [
                    Text(
                      '${scan.episodeType.fr} ${scan.number} ${scan.langType.fr} ',
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Il y a ${printTimeSince(DateTime.parse(scan.releaseDate))}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        launch(scan.url);
      },
    );
  }
}
