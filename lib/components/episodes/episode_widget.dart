import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/display_mapper.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/episode.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/updates/episode_update_view.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeWidget extends StatelessWidget {
  final _displayMapper = DisplayMapper();
  final Episode episode;

  EpisodeWidget({required this.episode, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(episode.url)),
      onLongPress: () {
        if (!member_mapper.isConnected()) {
          return;
        }

        final member = member_mapper.getMember()!;

        if (member.role != MemberRole.admin) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EpisodeUpdateView(
              episode: episode,
              member: member,
            ),
          ),
        );
      },
      child: Container(
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
              episode.title?.replaceAll("\n", ' ') ?? '＞﹏＜',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${episode.anime.country.season} ${episode.season} • ${episode.episodeType.fr} ${episode.number} ${episode.langType.fr}',
              overflow: TextOverflow.ellipsis,
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
            if (_displayMapper.isOnMobile(context))
              RoundBorderWidget(
                widget: CachedNetworkImage(
                  imageUrl: 'https://ziedelth.fr/${episode.image}',
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  placeholder: (context, url) => const Skeleton(height: 200),
                  errorWidget: (context, url, error) =>
                      const Skeleton(height: 200),
                ),
              )
            else
              Expanded(
                child: RoundBorderWidget(
                  widget: CachedNetworkImage(
                    imageUrl: 'https://ziedelth.fr/${episode.image}',
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                    placeholder: (context, url) => const Skeleton(),
                    errorWidget: (context, url, error) => const Skeleton(),
                  ),
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
      ),
    );
  }
}
