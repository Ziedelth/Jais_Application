import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/circle_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/platform.dart';

class PlatformWidget extends StatelessWidget {
  final Platform _platform;
  static const double _width = 25;
  static const double _height = 25;

  const PlatformWidget(this._platform, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https://ziedelth.fr/${_platform.image}',
      imageBuilder: (context, imageProvider) => CircleWidget(
        widget: Image(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      placeholder: (context, url) => const Skeleton(
        width: _width,
        height: _height,
      ),
      errorWidget: (context, url, error) =>
          const Skeleton(width: _width, height: _height),
      width: _width,
      height: _height,
    );
  }
}
