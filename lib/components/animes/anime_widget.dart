import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/notation_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/mappers/user_mapper.dart';
import 'package:jais/models/anime.dart';

class AnimeWidget extends StatelessWidget {
  final Anime anime;
  final Function(Anime anime)? onUp;
  final Function(Anime anime)? onDown;

  const AnimeWidget({required this.anime, this.onUp, this.onDown, Key? key})
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
                        up: anime.notation,
                        colorUp: _color(1),
                        colorDown: _color(-1),
                        onUp: () => onUp?.call(anime),
                        onDown: () => onDown?.call(anime),
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

  Color? _color(int count) => user?.statistics?.animes.any(
            (element) => element.animeId == anime.id && element.count == count,
          ) ==
          true
      ? Colors.green
      : null;
}
