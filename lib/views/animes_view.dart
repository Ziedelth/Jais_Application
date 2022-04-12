import 'package:flutter/material.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/components/loading_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';
import 'package:jais/models/anime.dart';
import 'package:jais/views/anime_details/anime_details_view.dart';

class AnimesView extends StatefulWidget {
  const AnimesView({Key? key}) : super(key: key);

  @override
  _AnimesViewState createState() => _AnimesViewState();
}

class _AnimesViewState extends State<AnimesView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;

  bool _hasTap = false;
  Anime? _anime;

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
    _showLoader(context);
    final details = await loadDetails(anime);
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

  Future<void> rebuildAnimes() async {
    await updateCurrentPage(
      onSuccess: () {
        if (!mounted) {
          return;
        }

        setState(() => _isLoading = false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      rebuildAnimes();
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        currentPage++;
        addLoader();

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

    return JList(
      key: _key,
      controller: _scrollController,
      children: list
          .map<Widget>(
            (e) => GestureDetector(
              child: e,
              onTap: () => e is AnimeWidget ? _onTap(e.anime) : null,
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('AnimesView.disposed');
    _scrollController.dispose();
    clear();
  }
}
