import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
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
  GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans({bool isNew = false}) async {
    await widget.watchlistMapper.updateScansCurrentPage(
      onSuccess: () {
        _update(false);

        if (isNew) {
          _key = GlobalKey();
        }
      },
      onFailure: () =>
          showSnackBar(context, 'An error occurred while loading scans'),
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
        ?.addPostFrameCallback((_) => setOperation(isNew: true));

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
    return ScanList(
      scrollController: _scrollController,
      key: _key,
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
