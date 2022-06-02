import 'package:flutter/material.dart';
import 'package:jais/components/skeleton.dart';

class SimulcastLoaderWidget extends StatelessWidget {
  const SimulcastLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Skeleton(
          width: 80,
        ),
      ),
    );
  }
}
