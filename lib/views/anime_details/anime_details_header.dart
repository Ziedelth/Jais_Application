import 'package:flutter/material.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/components/platform_widget.dart';
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
    // final bool _hasTopic = hasTopic(widget._animeDetails.code);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  icon: const Icon(Icons.help),
                  onPressed: () {
                    show(
                      context,
                      widget: Column(
                        children: [
                          if (widget._anime.genres.isNotEmpty)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: _buildPlatforms(),
                                ),
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
              ),
            ],
          ),
        ),
        // if (isConnected())
        //   Expanded(
        //     child: IconButton(
        //       icon: Icon(
        //         _hasTopic ? Icons.notifications_on : Icons.notifications_off,
        //         color: _hasTopic ? Colors.green : Colors.red,
        //       ),
        //       onPressed: () {
        //         if (_hasTopic) {
        //           removeTopic(widget._animeDetails.code);
        //           setState(() {});
        //           return;
        //         }
        //
        //         if (!_hasTopic) {
        //           addTopic(widget._animeDetails.code);
        //           setState(() {});
        //           return;
        //         }
        //       },
        //     ),
        //   ),
      ],
    );
  }
}
