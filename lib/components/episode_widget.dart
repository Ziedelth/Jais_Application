import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/episode.dart';
import 'package:url_launcher/url_launcher.dart';

import 'circle_widget.dart';

class EpisodeWidget extends StatelessWidget {
  final Episode episode;

  const EpisodeWidget({required this.episode, Key? key}) : super(key: key);

  String _printDuration(Duration duration) {
    if (duration.isNegative) {
      return '??:??';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if ((int.tryParse(twoDigits(duration.inHours)) ?? 0) > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  String _printTimeSince(DateTime dateTime) {
    final double seconds = (DateTime.now().millisecondsSinceEpoch.floor() -
            dateTime.millisecondsSinceEpoch.floor()) /
        1000;
    double interval = seconds / 31536000;
    if (interval > 1) {
      return '${interval.floor()} an${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 2592000;
    if (interval > 1) {
      return '${interval.floor()} mois';
    }
    interval = seconds / 86400;
    if (interval > 1) {
      return '${interval.floor()} jour${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 3600;
    if (interval > 1) {
      return '${interval.floor()} heure${interval >= 2 ? 's' : ''}';
    }
    interval = seconds / 60;
    if (interval > 1) {
      return '${interval.floor()} minute${interval >= 2 ? 's' : ''}';
    }
    return 'A l\'instant';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://ziedelth.fr/${episode.platform.image}',
                    imageBuilder: (context, imageProvider) =>
                        CircleWidget(widget: Image(image: imageProvider)),
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
                      episode.anime.name,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      episode.title ?? '＞﹏＜',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${episode.anime.country.season} ${episode.season} • ${episode.episodeType.fr} ${episode.number} ${episode.langType.fr} ',
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.movie),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Text(_printDuration(Duration(seconds: episode.duration))),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              RoundBorderWidget(
                widget: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: 'https://ziedelth.fr/${episode.image}',
                    placeholder: (context, url) => const Skeleton(height: 200),
                    errorWidget: (context, url, error) =>
                        const Skeleton(height: 200),
                  ),
                  onTap: () {
                    launch(episode.url);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: [
                  Text(
                    'Il y a ${_printTimeSince(DateTime.parse(episode.releaseDate))}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
