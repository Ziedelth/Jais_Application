import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/circle_widget.dart';
import 'package:jais/components/notation_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/user_mapper.dart';
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
                    CachedNetworkImage(
                      imageUrl: 'https://ziedelth.fr/${scan.platformImage}',
                      imageBuilder: (context, imageProvider) => CircleWidget(
                        widget: Image(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Skeleton(width: 25, height: 25),
                      errorWidget: (context, url, error) =>
                          const Skeleton(width: 25, height: 25),
                      width: 25,
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: Text(
                        scan.anime,
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
                      '${scan.episodeType} ${scan.number} ${scan.langType} ',
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
                    if (isConnected())
                      Expanded(
                        child: NotationWidget(
                          up: scan.notation,
                          colorUp: _color(1),
                          colorDown: _color(-1),
                          onUp: () => onUp?.call(scan),
                          onDown: () => onDown?.call(scan),
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

  Color? _color(int count) => user?.statistics?.scans.any(
            (element) => element.scanId == scan.id && element.count == count,
          ) ==
          true
      ? Colors.green
      : null;
}
