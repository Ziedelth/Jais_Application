import 'package:flutter/material.dart';
import 'package:jais/utils/utils.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScrollController _scrollController = ScrollController();

  Future<void> rebuildScans() async {
    await Utils.updateCurrentPageScans(
      onSuccess: () => setState(() {}),
    );
  }

  @override
  void initState() {
    Utils.clearScans();
    rebuildScans();

    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter <= 0) {
        Utils.scanCurrentPage++;
        Utils.addLoaderScans();
        setState(() {});
        await rebuildScans();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: Utils.scans.length,
      itemBuilder: (context, index) {
        return Utils.scans[index];
      },
    );
  }
}
