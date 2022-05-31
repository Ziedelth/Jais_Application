import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/components/simulcasts/simulcast_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/mappers/simulcast_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/utils.dart';
import 'package:jais/views/anime_details/anime_details_view.dart';
import 'package:jais/views/anime_search_view.dart';
import 'package:provider/provider.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  AnimesViewState createState() => AnimesViewState();
}

class AnimesViewState extends State<AnimesView> {
  final SimulcastMapper _simulcastMapper = SimulcastMapper();
  final AnimeMapper _animeMapper = AnimeMapper();

  final ScrollController _simulcastsScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  Simulcast? _currentSimulcast;
  bool _hasTap = false;
  Anime? _anime;
  late List<Widget> _simulcastWidgets;

  void showSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnimeSearchView(
          animeMapper: _animeMapper,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _setDetails({Anime? anime}) {
    setState(() {
      _anime = anime;
      _hasTap = anime != null;
    });
  }

  // Show loader dialog with a builder context
  Future<void> _showLoader(BuildContext context) async => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const AlertDialog(
          content: Loading(),
        ),
      );

  Future<void> _onTap(Anime anime) async {
    _hasTap = false;
    _anime = null;
    if (!mounted) return;
    setState(() {});

    _showLoader(context);
    final details = await _animeMapper.loadDetails(anime);
    if (!mounted) return;
    Navigator.pop(context);

    // If details is null, show error
    if (details == null) {
      showSnackBar(context, 'An error occurred while loading details');
      return;
    }

    _setDetails(
      anime: details,
    );
  }

  Future<void> rebuildAnimes({bool force = false}) async {
    if (_currentSimulcast == null) return;
    if (force) _animeMapper.clear();

    _animeMapper.simulcast = _currentSimulcast;
    await _animeMapper.updateCurrentPage();
  }

  void scrollToEndSimulcasts() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (!mounted) return;

      try {
        _simulcastsScrollController.animateTo(
          _simulcastsScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {}
    });
  }

  @override
  void initState() {
    super.initState();
    _animeMapper.clear();
    _simulcastWidgets = _simulcastMapper.list;
    WidgetsBinding.instance.addPostFrameCallback((_) async => init());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        _animeMapper.currentPage++;
        _animeMapper.addLoader();
        rebuildAnimes();
      }
    });
  }

  Future<void> init() async {
    _simulcastMapper.clear();
    _animeMapper.clear();
    await _simulcastMapper.updateCurrentPage();
    scrollToEndSimulcasts();
    _simulcastWidgets = _simulcastMapper.list;
    var last = _simulcastWidgets.last as SimulcastWidget;
    // Set current simulcast to the last one
    _currentSimulcast = last.simulcast;
    last = last.copyWith(isSelected: true);
    _simulcastWidgets.removeLast();
    _simulcastWidgets.add(last);
    rebuildAnimes();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _anime != null) {
      return AnimeDetailsView(_anime!, _setDetails);
    }

    return RefreshIndicator(
      onRefresh: () async => init(),
      child: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider<SimulcastMapper>.value(
              value: _simulcastMapper,
              child: Consumer<SimulcastMapper>(
                builder: (context, simulcastMapper, _) => SimulcastsWidget(
                  scrollController: _simulcastsScrollController,
                  simulcast: _currentSimulcast,
                  children: simulcastMapper.list,
                  onTap: (simulcast) {
                    _scrollController.jumpTo(0);
                    _currentSimulcast = simulcast;

                    final copyList = simulcastMapper.list;

                    for (var element in copyList) {
                      if (element is SimulcastWidget) {
                        element = element.copyWith(
                          isSelected: element.simulcast == simulcast,
                        );
                      }
                    }

                    _simulcastWidgets = copyList;
                    _animeMapper.clear();
                    rebuildAnimes(force: true);
                    if (!mounted) return;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: isOnMobile(context) ? 9 : 4,
            child: ChangeNotifierProvider<AnimeMapper>.value(
              value: _animeMapper,
              child: Consumer<AnimeMapper>(
                builder: (context, animeMapper, _) => AnimeList(
                  scrollController: _scrollController,
                  children: animeMapper.list
                      .map<Widget>(
                        (e) => GestureDetector(
                          child: e,
                          onTap: () =>
                              e is AnimeWidget ? _onTap(e.anime) : null,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

class SimulcastsWidget extends StatelessWidget {
  const SimulcastsWidget({
    Key? key,
    required this.scrollController,
    required this.children,
    this.simulcast,
    this.onTap,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<Widget> children;
  final Simulcast? simulcast;
  final Function(Simulcast)? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JList(
            direction: Axis.horizontal,
            controller: scrollController,
            children: children
                .map(
                  (e) => e is SimulcastWidget
                      ? e.copyWith(
                          isSelected: e.simulcast == simulcast,
                          onTap: (simulcast) => onTap?.call(simulcast),
                        )
                      : e,
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
