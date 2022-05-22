import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/watchlist_mapper.dart';

class WatchlistScansView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistScansView(this.watchlistMapper, {Key? key}) : super(key: key);

  @override
  _WatchlistScansViewState createState() => _WatchlistScansViewState();
}

class _WatchlistScansViewState extends State<WatchlistScansView> {
  final _scrollController = ScrollController();
  GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans({bool isNew = false}) async {
    await widget.watchlistMapper.watchlistScanMapper.updateCurrentPage(
      onSuccess: () {
        if (isNew) {
          _key = GlobalKey();
        }

        _update(false);
      },
    );
  }

  void setOperation({bool isNew = false}) {
    _cancelableOperation?.cancel();
    _cancelableOperation =
        CancelableOperation.fromFuture(rebuildScans(isNew: isNew));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setOperation(isNew: true));

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        widget.watchlistMapper.watchlistScanMapper.currentPage++;
        widget.watchlistMapper.watchlistScanMapper.addLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScanList(
      key: _key,
      scrollController: _scrollController,
      children: widget.watchlistMapper.watchlistScanMapper.list,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
  }
}
