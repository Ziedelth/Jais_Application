import 'package:flutter/material.dart';
import 'package:jais/utils/main_color.dart';

class JTab extends StatefulWidget {
  const JTab(this.tabController, {Key? key}) : super(key: key);

  final TabController tabController;

  @override
  _JTabState createState() => _JTabState();
}

class _JTabState extends State<JTab> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      indicatorColor: Colors.black,
      labelColor: mainColorO,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(
          icon: Icon(
            Icons.subscriptions,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.library_books,
          ),
        ),
      ],
    );
  }
}
