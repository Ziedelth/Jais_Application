import 'package:flutter/material.dart';

class JTab extends StatelessWidget {
  final TabController tabController;

  const JTab(this.tabController, {super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.black,
      labelColor: Theme.of(context).primaryColor,
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
