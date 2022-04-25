import 'package:flutter/material.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/platform_widget.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/platform.dart';

class AnimeDetailsHeader extends StatefulWidget {
  const AnimeDetailsHeader(this._callback, this._anime, {Key? key})
      : super(key: key);

  final VoidCallback _callback;
  final Anime _anime;

  @override
  _AnimeDetailsHeaderState createState() => _AnimeDetailsHeaderState();
}

class _AnimeDetailsHeaderState extends State<AnimeDetailsHeader> {
  List<PlatformWidget> _buildPlatforms() {
    final Map<int, Platform> platforms = <int, Platform>{};
    widget._anime.episodes
        .where(
          (element) => !platforms.containsKey(element.platform.id),
        )
        .forEach((e) => platforms[e.platform.id] = e.platform);
    widget._anime.scans
        .where(
          (element) => !platforms.containsKey(element.platform.id),
        )
        .forEach((e) => platforms[e.platform.id] = e.platform);
    final List<PlatformWidget> widgets = platforms.values
        .toSet()
        .map<PlatformWidget>((e) => PlatformWidget(e))
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          onPressed: widget._callback,
        ),
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  widget._anime.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (isConnected())
                IconButton(
                  icon: Icon(
                    hasAnimeInWatchlist(widget._anime.id)
                        ? Icons.playlist_remove
                        : Icons.playlist_add,
                    color: hasAnimeInWatchlist(widget._anime.id)
                        ? Colors.red
                        : Colors.green,
                  ),
                  onPressed: () async {
                    if (hasAnimeInWatchlist(widget._anime.id)) {
                      await removeAnimeInWatchlist(widget._anime.id);
                    } else {
                      await addAnimeInWatchlist(widget._anime.id);
                    }

                    if (!mounted) return;
                    setState(() {});
                  },
                ),
              IconButton(
                icon: const Icon(Icons.help),
                onPressed: () {
                  show(
                    context,
                    widget: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _buildPlatforms(),
                            ),
                            if (widget._anime.genres.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2.5,
                                ),
                              ),
                              Text(
                                widget._anime.genres
                                    .map((e) => e.fr)
                                    .join(', '),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Divider(
                                height: 5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget._anime.description ?? 'No description',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
