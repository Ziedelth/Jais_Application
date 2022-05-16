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
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = isLoading;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans() async {
    await _scanMapper.updateCurrentPage(onSuccess: () => _update(false));
  }

  void setOperation() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(rebuildScans());
  }

  @override
  void initState() {
    super.initState();
    _scanMapper.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => setOperation());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
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
