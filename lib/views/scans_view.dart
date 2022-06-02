import 'package:flutter/material.dart';
import 'package:jais/components/scans/scan_list.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:provider/provider.dart';

class ScansView extends StatefulWidget {
  const ScansView({super.key});

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final _scanMapper = ScanMapper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scanMapper.updateCurrentPage());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _scanMapper.clear();
        _scanMapper.updateCurrentPage();
      },
      child: ChangeNotifierProvider<ScanMapper>.value(
        value: _scanMapper,
        child: Consumer<ScanMapper>(
          builder: (context, scanMapper, _) {
            return ScanList(
              scrollController: scanMapper.scrollController,
              children: scanMapper.list,
            );
          },
        ),
      ),
    );
  }
}
