import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/utils/const.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/updates/anime_update_view.dart';

class AnimeWidget extends StatelessWidget {
  final Anime anime;

  const AnimeWidget({required this.anime, super.key});

  @override
  Widget build(BuildContext context) {
    var cachedNetworkImage = CachedNetworkImage(
      imageUrl: '$attachmentsUrl${anime.image}',
      imageBuilder: (context, imageProvider) => RoundBorderWidget(
        widget: Image(image: imageProvider, fit: BoxFit.cover),
      ),
      placeholder: (context, url) => const Skeleton(width: 75, height: 100),
      errorWidget: (context, url, error) =>
          const Skeleton(width: 75, height: 100),
      width: 75,
      height: 100,
    );

    return GestureDetector(
      onLongPress: () {
        if (!MemberMapper.instance.isConnected()) {
          return;
        }

        if (MemberMapper.instance.getMember()?.role != MemberRole.admin) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AnimeUpdateView(
                anime: anime,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (anime.inWatchlist > 0)
              Tooltip(
                message:
                    'Présent dans ${anime.inWatchlist} watchlist${anime.inWatchlist > 1 ? 's' : ''}',
                child: Badge(
                  badgeContent: Text(
                    anime.inWatchlist.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  badgeColor: Colors.red,
                  position: BadgePosition.topStart(top: -15),
                  child: cachedNetworkImage,
                ),
              )
            else
              cachedNetworkImage,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    anime.description
                        .ifEmptyOrNull('Aucune description pour le moment'),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
