import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/scan_mapper.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  Future<void> rebuildScans() async {
    await updateCurrentPage(
      onSuccess: () => setState(() => _isLoading = false),
    );
  }

  @override
  void initState() {
    super.initState();

    clear();
    rebuildScans();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0 && !_isLoading) {
        _isLoading = true;
        currentPage++;
        addLoader();
        setState(() {});
        await rebuildScans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JList(
      controller: _scrollController,
      children: list,
    );
  }
}
