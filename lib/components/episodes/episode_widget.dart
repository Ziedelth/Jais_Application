import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/circle_widget.dart';
import 'package:jais/components/notation_widget.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeWidget extends StatelessWidget {
  final Episode episode;
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  const EpisodeWidget({required this.episode, this.onUp, this.onDown, Key? key})
      : super(key: key);

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
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://ziedelth.fr/${episode.platformImage}',
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
                      episode.anime,
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
                    '${episode.countrySeason} ${episode.season} • ${episode.episodeType} ${episode.number} ${episode.langType} ',
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.movie),
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                  ),
                  Text(
                    printDuration(Duration(seconds: episode.duration)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              RoundBorderWidget(
                widget: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: 'https://ziedelth.fr/${episode.image}',
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                    placeholder: (context, url) => const Skeleton(height: 200),
                    errorWidget: (context, url, error) =>
                        const Skeleton(height: 200),
                    fit: BoxFit.fill,
                  ),
                  onTap: () => launch(episode.url),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Il y a ${printTimeSince(DateTime.parse(episode.releaseDate))}',
                    ),
                  ),
                  if (isConnected())
                    Expanded(
                      child: NotationWidget(
                        onUp: onUp,
                        up: episode.notation,
                        onDown: onDown,
                        colorUp: _color(1),
                        colorDown: _color(-1),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color? _color(int count) => user?.statistics?.episodes.any(
            (element) =>
                element.episodeId == episode.id && element.count == count,
          ) ==
          true
      ? Colors.green
      : null;
}
