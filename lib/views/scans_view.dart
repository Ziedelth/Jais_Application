import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:provider/provider.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScanMapper _scanMapper = ScanMapper();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scanMapper.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scanMapper.updateCurrentPage());

    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter <= 0) {
        _scanMapper.currentPage++;
        _scanMapper.updateCurrentPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _scanMapper.clear();
        await _scanMapper.updateCurrentPage();
      },
      child: ChangeNotifierProvider<ScanMapper>(
        create: (_) => _scanMapper,
        child: Consumer<ScanMapper>(
          builder: (context, scanMapper, _) {
            return ScanList(
              scrollController: _scrollController,
              children: scanMapper.list,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scanMapper.dispose();
  }
}
