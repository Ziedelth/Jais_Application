import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/jdialog.dart';
import 'package:jais/mappers/anime_details_mapper.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:provider/provider.dart';

class AnimeDetailsView extends StatefulWidget {
  final Anime _anime;

  const AnimeDetailsView(this._anime, {super.key});

  @override
  _AnimeDetailsViewState createState() => _AnimeDetailsViewState();
}

class _AnimeDetailsViewState extends State<AnimeDetailsView> {
  late final AnimeDetailsMapper _animeDetailsMapper;
  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _animeDetailsMapper = AnimeDetailsMapper(widget._anime);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _animeDetailsMapper.updateCurrentPage();

      if (!mounted) return;
      setState(() => _key = UniqueKey());
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAnimeInWatchlist =
        MemberMapper.instance.hasAnimeInWatchlist(widget._anime);

    return Column(
      children: [
        Row(
          children: [
            BackButton(
              onPressed: () => Navigator.pop(context),
            ),
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
            if (MemberMapper.instance.isConnected())
              IconButton(
                icon: Icon(
                  hasAnimeInWatchlist
                      ? Icons.playlist_remove
                      : Icons.playlist_add,
                  color: hasAnimeInWatchlist ? Colors.red : Colors.green,
                ),
                onPressed: () async {
                  if (hasAnimeInWatchlist) {
                    await MemberMapper.instance
                        .removeAnimeInWatchlist(widget._anime);
                  } else {
                    await MemberMapper.instance
                        .addAnimeInWatchlist(widget._anime);
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
                      if (widget._anime.genres.isNotEmpty) ...[
                        Text(
                          widget._anime.genres.map((e) => e.fr).join(', '),
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
        const Divider(
          height: 2,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _animeDetailsMapper.clear();
              _animeDetailsMapper.updateCurrentPage();
            },
            child: ChangeNotifierProvider<AnimeDetailsMapper>.value(
              value: _animeDetailsMapper,
              child: Consumer<AnimeDetailsMapper>(
                builder: (context, animeDetailsMapper, _) {
                  return EpisodeList(
                    key: _key,
                    scrollController: animeDetailsMapper.scrollController,
                    children: animeDetailsMapper.list,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
