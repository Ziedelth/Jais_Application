import 'package:flutter/material.dart';
import 'package:jais/components/full_widget.dart';

class SectionWidget extends StatelessWidget {
  final Icon icon;
  final String title;
  final List<Widget>? widgets;

  const SectionWidget({
    required this.icon,
    required this.title,
    this.widgets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: FullWidget(
            icon: icon,
            widget: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2.5),
          child: Divider(
            height: 1,
          ),
        ),
        ...?widgets
      ],
    );
  }
}
