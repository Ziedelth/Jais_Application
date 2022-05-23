import 'package:async/async.dart';
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
  bool _isLoading = true;
  Simulcast? _currentSimulcast;
  bool _hasTap = false;
  Anime? _anime;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

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
    await _animeMapper.updateCurrentPage(onSuccess: () => _update(false));
  }

  void setOperation() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildAnimes());
  }

  @override
  void initState() {
    super.initState();
    _animeMapper.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _simulcastMapper.updateCurrentPage(
        onSuccess: () {
          // Set current simulcast to the last one
          _currentSimulcast =
              (_simulcastMapper.list.last as SimulcastWidget).simulcast;
          _build();
        },
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _animeMapper.currentPage++;
        _animeMapper.addLoader();
        _update(true);
        setOperation();
      }
    });
  }

  Future<void> _build() async {
    setOperation();

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    try {
      _simulcastsScrollController.animateTo(
        _simulcastsScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_hasTap && _anime != null) {
      return AnimeDetailsView(_anime!, _setDetails);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _simulcastMapper.clear();
        _animeMapper.clear();
        _update(true);

        await _simulcastMapper.updateCurrentPage(
          onSuccess: () {
            // Set current simulcast to the last one
            _currentSimulcast =
                (_simulcastMapper.list.last as SimulcastWidget).simulcast;

            if (!mounted) return;

            setState(() {
              _simulcastsScrollController.animateTo(
                _simulcastsScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });

            _build();
          },
        );
      },
      child: Column(
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
            flex: isOnMobile(context) ? 9 : 4,
            child: AnimeList(
              scrollController: _scrollController,
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
    _simulcastMapper.clear();
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JList(
            direction: Axis.horizontal,
            controller: scrollController,
            children: simulcastMapper.list,
          ),
        ),
      ],
    );
  }
}
