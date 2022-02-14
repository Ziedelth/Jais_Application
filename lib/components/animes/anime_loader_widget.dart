import 'package:flutter/material.dart';
import 'package:jais/components/skeleton.dart';

class AnimeLoaderWidget extends StatelessWidget {
  const AnimeLoaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Skeleton(height: 20),
                        Skeleton(height: 100),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Skeleton(width: 75, height: 100),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
