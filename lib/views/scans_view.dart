import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/scan_mapper.dart';

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

  Future<void> rebuildScans() async {
    await _scanMapper.updateCurrentPage(
      onSuccess: () {
        if (!mounted) {
          return;
        }

        setState(() => _isLoading = false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scanMapper.clear();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      rebuildScans();
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        _scanMapper.currentPage++;
        _scanMapper.addLoader();

        if (mounted) {
          setState(() {});
        }

        await rebuildScans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JList(
      key: _key,
      controller: _scrollController,
      children: _scanMapper.list,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scanMapper.clear();
  }
}
