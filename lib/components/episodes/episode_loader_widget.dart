import 'package:flutter/material.dart';
import 'package:jais/components/skeleton.dart';

class EpisodeLoaderWidget extends StatelessWidget {
  const EpisodeLoaderWidget({
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Skeleton(
                    width: 25,
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Skeleton(
                    width: 250,
                    height: 30,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: const [
                  Skeleton(
                    width: 150,
                    height: 20,
                  ),
                ],
              ),
              Row(
                children: const [
                  Skeleton(
                    width: 250,
                    height: 20,
                  ),
                ],
              ),
              Row(
                children: const [
                  Skeleton(
                    width: 100,
                    height: 20,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Skeleton(
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: const [
                  Skeleton(
                    width: 200,
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
