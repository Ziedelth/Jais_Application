import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/watchlist_mapper.dart';
import 'package:jais/utils/utils.dart';

class WatchlistScansView extends StatefulWidget {
  final WatchlistMapper watchlistMapper;

  const WatchlistScansView(this.watchlistMapper, {Key? key}) : super(key: key);

  @override
  _WatchlistScansViewState createState() => _WatchlistScansViewState();
}

class _WatchlistScansViewState extends State<WatchlistScansView> {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans() async {
    await widget.watchlistMapper.updateScansCurrentPage(
      onSuccess: () => _update(false),
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading scans'),
    );
  }

  void setOperation() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildScans());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => setOperation());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        widget.watchlistMapper.currentPageScans++;
        widget.watchlistMapper.addScanLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JList(
      controller: _scrollController,
      children: widget.watchlistMapper.scansList,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
  }
}
