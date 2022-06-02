import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistScansView extends StatefulWidget {
  final WatchlistScanMapper watchlistScanMapper;

  const WatchlistScansView(this.watchlistScanMapper, {super.key});

  @override
  _WatchlistScansViewState createState() => _WatchlistScansViewState();
}

class _WatchlistScansViewState extends State<WatchlistScansView> {
  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    widget.watchlistScanMapper.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.watchlistScanMapper.updateCurrentPage();

      if (!mounted) return;
      setState(() => _key = UniqueKey());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistScanMapper>.value(
      value: widget.watchlistScanMapper,
      child: Consumer<WatchlistScanMapper>(
        builder: (context, watchlistScanMapper, _) {
          return ScanList(
            key: _key,
            scrollController: watchlistScanMapper.scrollController,
            children: watchlistScanMapper.list,
          );
        },
      ),
    );
  }
}
