import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/mappers/episode_mapper.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/mappers/simulcast_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/views/anime_details/anime_details_view.dart';
import 'package:jais/views/anime_search_view.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  AnimesViewState createState() => AnimesViewState();
}

class AnimesViewState extends State<AnimesView> {
  final SimulcastMapper _simulcastMapper = SimulcastMapper();
  final EpisodeMapper _episodeMapper = EpisodeMapper();
  final ScanMapper _scanMapper = ScanMapper();
  final AnimeMapper _animeMapper = AnimeMapper();

  final ScrollController _simulcastsScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  Simulcast? _currentSimulcast;

  bool _hasTap = false;
  Anime? _anime;

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
          actions: [],
        ),
      );

  Future<void> _onTap(Anime anime) async {
    _hasTap = false;
    _anime = null;
    if (!mounted) return;
    setState(() {});

    _showLoader(context);
    final details =
        await _animeMapper.loadDetails(_episodeMapper, _scanMapper, anime);
    if (!mounted) return;
    Navigator.pop(context);

    // If details is null, show error
    if (details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while loading details'),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    _setDetails(
      anime: details,
    );
  }

  Future<void> rebuildAnimes({bool force = false}) async {
    if (_currentSimulcast == null) return;
    if (force) _animeMapper.clear();

    await _animeMapper.updateCurrentPage(
      simulcast: _currentSimulcast!,
      onSuccess: () {
        _isLoading = false;
        if (!mounted) return;
        setState(() {});
      },
      onFailure: () {
        _animeMapper.removeLoader();
        _isLoading = false;
        if (!mounted) return;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _animeMapper.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _simulcastMapper.update(
        onSuccess: () {
          // Set current simulcast to the last one
          _currentSimulcast = _simulcastMapper.list?.last;
          rebuildAnimes();
          if (!mounted) return;
          setState(() {});
        },
      );
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _animeMapper.currentPage++;
        _animeMapper.addLoader();

        if (mounted) {
          setState(() {});
        }

        await rebuildAnimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _anime != null) {
      return AnimeDetailsView(_anime!, _setDetails);
    }

    return Column(
      key: _key,
      children: [
        Expanded(
          child: SimulcastsWidget(
            scrollController: _simulcastsScrollController,
            simulcast: _currentSimulcast,
            simulcastMapper: _simulcastMapper,
            onTap: (simulcast) {
              _scrollController.jumpTo(0);

              _currentSimulcast = simulcast;
              _animeMapper.clear();
              rebuildAnimes(force: true);
              if (!mounted) return;
              setState(() {});
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: JList(
            controller: _scrollController,
            children: _animeMapper.list
                .map<Widget>(
                  (e) => GestureDetector(
                    child: e,
                    onTap: () => e is AnimeWidget ? _onTap(e.anime) : null,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _simulcastMapper.clear();
    _episodeMapper.clear();
    _scanMapper.clear();
    _animeMapper.clear();
  }
}

class SimulcastsWidget extends StatelessWidget {
  const SimulcastsWidget({
    Key? key,
    required this.scrollController,
    required this.simulcastMapper,
    this.simulcast,
    this.onTap,
  }) : super(key: key);

  final ScrollController scrollController;
  final SimulcastMapper simulcastMapper;
  final Simulcast? simulcast;
  final Function(Simulcast)? onTap;

  List<Widget> _getWidgets(BuildContext context) {
    if (simulcastMapper.list == null) {
      return const [];
    }

    return simulcastMapper.list!
        .map(
          (simulcast) => Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(8),
                color: simulcast == this.simulcast
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
              ),
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      simulcast.simulcast,
                      style: TextStyle(
                        fontSize: 14,
                        color: simulcast == this.simulcast
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () => onTap?.call(simulcast),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JList(
            direction: Axis.horizontal,
            controller: scrollController,
            children: _getWidgets(context),
          ),
        ),
      ],
    );
  }
}
