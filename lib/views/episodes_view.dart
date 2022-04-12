import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/episode_mapper.dart';

class EpisodesView extends StatefulWidget {
  const EpisodesView({Key? key}) : super(key: key);

  @override
  _EpisodesViewState createState() => _EpisodesViewState();
}

class _EpisodesViewState extends State<EpisodesView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;

  Future<void> rebuildEpisodes() async {
    await updateCurrentPage(
      onSuccess: () {
        if (!mounted) return;
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      rebuildEpisodes();
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        currentPage++;
        addLoader();

        if (mounted) {
          setState(() {});
        }

        await rebuildEpisodes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JList(
      key: _key,
      controller: _scrollController,
      children: list,
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('EpisodesView.disposed');
    _scrollController.dispose();
    clear();
  }
}
