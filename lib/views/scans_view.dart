import 'package:flutter/material.dart';
import 'package:jais/components/jlist.dart';
import 'package:jais/mappers/scan_mapper.dart';
import 'package:jais/models/scan.dart';

class ScansView extends StatefulWidget {
  const ScansView({Key? key}) : super(key: key);

  @override
  _ScansViewState createState() => _ScansViewState();
}

class _ScansViewState extends State<ScansView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  bool _isLoading = true;

  Future<void> _on(Scan scan, int count) async {
    // if (!isConnected()) {
    //   return;
    // }
    //
    // await put(
    //   'https://ziedelth.fr/api/v1/member/notation/scan',
    //   {
    //     'token': token,
    //     'id': '${scan.id}',
    //     'count': '$count',
    //   },
    //   (success) async {
    //     await get(
    //       'https://ziedelth.fr/api/v1/statistics/member/${user?.pseudo}',
    //       (success) {
    //         user?.statistics = Statistics.fromJson(
    //           jsonDecode(success) as Map<String, dynamic>,
    //         );
    //
    //         if (mounted) {
    //           setState(() {
    //             clear();
    //             rebuildScans();
    //             _key = GlobalKey();
    //           });
    //         }
    //       },
    //       (_) => null,
    //     );
    //   },
    //   (_) => null,
    // );
  }

  Future<void> rebuildScans() async {
    await updateCurrentPage(
      onSuccess: () {
        if (!mounted) {
          return;
        }

        setState(() => _isLoading = false);
      },
      onUp: (Scan scan) => _on(scan, 1),
      onDown: (Scan scan) => _on(scan, -1),
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
      children: list,
    );
  }
}
