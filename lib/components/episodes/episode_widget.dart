import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeWidget extends StatelessWidget {
  final Episode episode;
  final Function(Episode)? onUp;
  final Function(Episode)? onDown;

  const EpisodeWidget({required this.episode, this.onUp, this.onDown, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlatformWidget(episode.platform),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  episode.anime.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            episode.title ?? '＞﹏＜',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            '${episode.anime.country.season} ${episode.season} • ${episode.episodeType.fr} ${episode.number} ${episode.langType.fr}',
          ),
          Row(
            children: [
              const Icon(Icons.movie),
              const SizedBox(width: 5),
              Text(printDuration(Duration(seconds: episode.duration))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RoundBorderWidget(
            widget: GestureDetector(
              child: CachedNetworkImage(
                imageUrl: 'https://ziedelth.fr/${episode.image}',
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                placeholder: (context, url) => const Skeleton(height: 200),
                errorWidget: (context, url, error) =>
                    const Skeleton(height: 200),
              ),
              onTap: () => launchUrl(Uri.parse(episode.url)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Il y a ${printTimeSince(DateTime.parse(episode.releaseDate))}',
          ),
        ],
      ),
    );
  }
}
