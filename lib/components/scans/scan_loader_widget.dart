import 'package:flutter/material.dart';
import 'package:jais/components/skeleton.dart';

class ScanLoaderWidget extends StatelessWidget {
  const ScanLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Skeleton(width: 20, height: 20),
              SizedBox(width: 10),
              Expanded(child: Skeleton(height: 20)),
            ],
          ),
          const SizedBox(height: 10),
          const Skeleton(width: 250, height: 15), // Info
          const SizedBox(height: 5),
          const Skeleton(width: 200, height: 15), // Time since
        ],
      ),
    );
  }
}
