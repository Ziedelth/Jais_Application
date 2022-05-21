import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/scan_mapper.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScanMapper _scanMapper = ScanMapper();
  final ScrollController _scrollController = ScrollController();
  GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans({bool isNew = false}) async {
    await _scanMapper.updateCurrentPage(
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
    _scanMapper.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setOperation(isNew: true));

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _scanMapper.currentPage++;
        _scanMapper.addLoader();
        _update(true);
        setOperation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _scanMapper.clear();
        _update(true);
        setOperation();
      },
      child: ScanList(
        key: _key,
        scrollController: _scrollController,
        children: _scanMapper.list,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelableOperation?.cancel();
    _scrollController.dispose();
    _scanMapper.clear();
  }
}
