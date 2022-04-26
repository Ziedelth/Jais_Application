import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/anime.dart';

class AnimeWidget extends StatelessWidget {
  final Anime anime;
  final Function(Anime anime)? onUp;
  final Function(Anime anime)? onDown;

  const AnimeWidget({required this.anime, this.onUp, this.onDown, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CachedNetworkImage(
                imageUrl: 'https://ziedelth.fr/${anime.image}',
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                placeholder: (context, url) =>
                    const Skeleton(width: 75, height: 100),
                errorWidget: (context, url, error) =>
                    const Skeleton(width: 75, height: 100),
                width: 75,
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
