import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
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
    _scanMapper.clear();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => setOperation(isNew: true));

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
    return ScanList(
      key: _key,
      scrollController: _scrollController,
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
