import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/utils/utils.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScanMapper _scanMapper = ScanMapper();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;
  CancelableOperation? _cancelableOperation;

  void _update(bool isLoading) {
    _isLoading = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> rebuildScans() async {
    await _scanMapper.updateCurrentPage(
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
    _scanMapper.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) => setOperation());

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
    if (!isOnMobile(context)) {
      return GridView(
        key: _key,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 4,
        ),
        controller: _scrollController,
        children: _scanMapper.list,
      );
    }

    return JList(
      key: _key,
      controller: _scrollController,
      children: _scanMapper.list,
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
