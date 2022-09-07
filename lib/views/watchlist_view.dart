import 'package:flutter/material.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/lang_type_mapper.dart';
import 'package:jais/mappers/member_mapper.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  final _watchlistMapper =
      WatchlistMapper(pseudo: MemberMapper.instance.getMember()!.pseudo);
  final _langTypeFilter = WatchlistLangTypeFilter();
  UniqueKey _key = UniqueKey();
  bool _filterIsExpanded = false;
  List<String> _filter = [];
  final List<Widget> _filterWidgets = [];

  Future<void> _setFilterWidgets({bool update = false}) async {
    _filter = await _langTypeFilter.getFilter();

    _filterWidgets.clear();
    _filterWidgets.addAll(
      LangTypeMapper.instance.list.map(
        (langType) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(langType.fr),
          activeColor: Theme.of(context).primaryColor,
          value: _filter.contains(langType.name),
          onChanged: (value) async {
            if (value == true) {
              await _langTypeFilter.addToFilter(langType.name);
            } else {
              await _langTypeFilter.removeToFilter(langType.name);
            }

            await _setFilterWidgets(update: true);
          },
        ),
      ),
    );

    if (update && mounted) {
      setState(() {});
    }
  }

  List<Widget> filteredEpisodes(WatchlistMapper watchlistMapper) {
    final filter = watchlistMapper.list
        .where(
          (e) =>
              (e is EpisodeLoaderWidget) ||
              (e is EpisodeWidget && _filter.contains(e.episode.langType.name)),
        )
        .toList();

    return filter.isEmpty ? watchlistMapper.list : filter;
  }

  @override
  void initState() {
    super.initState();
    Logger.info('Initializing watchlist view...');
    _watchlistMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Logger.info('Loading watchlist...');
      await _watchlistMapper.updateCurrentPage();
      Logger.debug('Watchlist length: ${_watchlistMapper.list.length}');

      if (!mounted) return;
      await _setFilterWidgets();
      setState(() => _key = UniqueKey());
    });

    Logger.info('Watchlist view initialized.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() => _filterIsExpanded = !isExpanded);
          },
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) => const ListTile(
                title: Text('Filtres'),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _filterWidgets,
              ),
              isExpanded: _filterIsExpanded,
            ),
          ],
        ),
        Expanded(
          child: ChangeNotifierProvider<WatchlistMapper>.value(
            value: _watchlistMapper,
            child: Consumer<WatchlistMapper>(
              builder: (context, watchlistEpisodeMapper, _) => EpisodeList(
                key: _key,
                scrollController: watchlistEpisodeMapper.scrollController,
                children: filteredEpisodes(watchlistEpisodeMapper),
              ),
            ),
          ),
        )
      ],
    );
  }
}
