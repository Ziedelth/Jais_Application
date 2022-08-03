import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/simulcasts/simulcast_list.dart';
import 'package:jais/components/simulcasts/simulcast_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/mappers/simulcast_mapper.dart';
import 'package:provider/provider.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({super.key});

  @override
  AnimesViewState createState() => AnimesViewState();
}

class AnimesViewState extends State<AnimesView> {
  final SimulcastMapper _simulcastMapper = SimulcastMapper(listener: false);
  final AnimeMapper _animeMapper = AnimeMapper();

  Future<void> rebuildAnimes({bool force = false}) async {
    if (force) _animeMapper.clear();
    await _animeMapper.updateCurrentPage();
  }

  void scrollToEndSimulcasts() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (!mounted) return;

      try {
        _simulcastMapper.scrollController.animateTo(
          _simulcastMapper.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {}
    });
  }

  @override
  void initState() {
    super.initState();
    _simulcastMapper.clear();
    _animeMapper.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async => init());
  }

  Future<void> init() async {
    _simulcastMapper.clear();
    _animeMapper.clear();
    await _simulcastMapper.updateCurrentPage();

    if (_simulcastMapper.list.last is SimulcastWidget) {
      scrollToEndSimulcasts();
      _animeMapper.simulcast =
          (_simulcastMapper.list.last as SimulcastWidget).simulcast;
      rebuildAnimes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => init(),
      child: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider<SimulcastMapper>.value(
              value: _simulcastMapper,
              child: Consumer<SimulcastMapper>(
                builder: (context, simulcastMapper, _) {
                  return SimulcastList(
                    scrollController: simulcastMapper.scrollController,
                    simulcast: _animeMapper.simulcast,
                    children: simulcastMapper
                        .toWidgetsSelected(_animeMapper.simulcast)
                        .map(
                          (e) => e is SimulcastWidget
                              ? GestureDetector(
                                  onTap: () {
                                    _animeMapper.scrollController.jumpTo(0);
                                    _animeMapper.simulcast = e.simulcast;
                                    _animeMapper.clear();
                                    rebuildAnimes(force: true);
                                    setState(() {});
                                  },
                                  child: e,
                                )
                              : e,
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: ChangeNotifierProvider<AnimeMapper>.value(
              value: _animeMapper,
              child: Consumer<AnimeMapper>(
                builder: (context, animeMapper, _) {
                  return AnimeList(
                    scrollController: animeMapper.scrollController,
                    children: animeMapper.list
                        .map<Widget>(
                          (e) => GestureDetector(
                            child: e,
                            onTap: () => e is AnimeWidget
                                ? Navigator.pushNamed(
                                    context,
                                    '/anime',
                                    arguments: e.anime,
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
