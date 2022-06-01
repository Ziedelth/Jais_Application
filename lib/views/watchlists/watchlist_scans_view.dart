import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:provider/provider.dart';

class WatchlistScansView extends StatelessWidget {
  final WatchlistScanMapper watchlistScanMapper;

  const WatchlistScansView(this.watchlistScanMapper, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WatchlistScanMapper>.value(
      value: watchlistScanMapper,
      child: Consumer<WatchlistScanMapper>(
        builder: (context, watchlistScanMapper, _) {
          return ScanList(
            scrollController: watchlistScanMapper.scrollController,
            children: watchlistScanMapper.list,
          );
        },
      ),
    );
  }
}
