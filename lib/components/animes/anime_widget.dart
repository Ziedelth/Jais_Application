import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/notation_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/models/anime.dart';

class AnimeWidget extends StatelessWidget {
  final Anime anime;
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  const AnimeWidget({required this.anime, this.onUp, this.onDown, Key? key}) : super(key: key);

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
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            anime.name,
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
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CachedNetworkImage(
                      imageUrl: 'https://ziedelth.fr/${anime.image}',
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                      placeholder: (context, url) =>
                          const Skeleton(width: 75, height: 100),
                      errorWidget: (context, url, error) =>
                          const Skeleton(width: 75, height: 100),
                      width: 75,
                      height: 100,
                    ),
                  ),
                ],
              ),
              if (isConnected())
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const Spacer(),
                      NotationWidget(
                        colorUp: color(
                          "animes",
                          "anime_id",
                          anime.id,
                          1,
                          Colors.green,
                        ),
                        up: anime.notation,
                        colorDown: color(
                          "animes",
                          "anime_id",
                          anime.id,
                          -1,
                          Colors.red,
                        ),
                        onUp: onUp,
                        onDown: onDown,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
