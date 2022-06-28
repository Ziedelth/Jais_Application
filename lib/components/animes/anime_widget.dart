import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/member_mapper.dart' as member_mapper;
import 'package:jais/models/anime.dart';
import 'package:jais/models/member_role.dart';
import 'package:jais/views/updates/anime_update_view.dart';

class AnimeWidget extends StatelessWidget {
  final Anime anime;

  const AnimeWidget({required this.anime, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            builder: (context) => AnimeUpdateView(
              anime: anime,
              member: member,
            ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://ziedelth.fr/${anime.image}',
                  imageBuilder: (context, imageProvider) => RoundBorderWidget(
                    widget: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, url) =>
                      const Skeleton(width: 75, height: 100),
                  errorWidget: (context, url, error) =>
                      const Skeleton(width: 75, height: 100),
                  width: 75,
                  height: 100,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          anime.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          anime.description ??
                              'Aucune description pour le moment',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
