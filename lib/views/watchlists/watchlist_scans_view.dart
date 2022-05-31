import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistScansView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistScansView(this.watchlistMapper, {Key? key}) : super(key: key);

  @override
  _WatchlistScansViewState createState() => _WatchlistScansViewState();
}

class _WatchlistScansViewState extends State<WatchlistScansView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.watchlistMapper.watchlistScanMapper.updateCurrentPage());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        widget.watchlistMapper.watchlistScanMapper.currentPage++;
        widget.watchlistMapper.watchlistScanMapper.addLoader();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistScanMapper>.value(
      value: widget.watchlistMapper.watchlistScanMapper,
      child: Consumer<WatchlistScanMapper>(
        builder: (context, watchlistScanMapper, _) {
          return ScanList(
            scrollController: _scrollController,
            children: watchlistScanMapper.list,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
