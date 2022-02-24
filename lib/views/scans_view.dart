import 'package:flutter/material.dart';
import 'package:jais/utils/scan_mapper.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  Future<void> rebuildScans() async {
    await ScanMapper.updateCurrentPage(
      onSuccess: () => setState(() {
        _isLoading = false;
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    ScanMapper.clear();
    rebuildScans();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        ScanMapper.currentPage++;
        ScanMapper.addLoader();
        setState(() {});
        await rebuildScans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      controller: _scrollController,
      itemCount: ScanMapper.list.length,
      itemBuilder: (context, index) {
        return ScanMapper.list[index];
      },
    );
  }
}
