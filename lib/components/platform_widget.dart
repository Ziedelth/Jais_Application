import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jais/components/roundborder_widget.dart';
import 'package:jais/components/skeleton.dart';
import 'package:jais/models/platform.dart';
import 'package:jais/utils/const.dart';

class PlatformWidget extends StatelessWidget {
  final Platform _platform;
  static const double _width = 20;
  static const double _height = 20;

  const PlatformWidget(this._platform, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$attachmentsUrl${_platform.image}',
      imageBuilder: (context, imageProvider) => RoundBorderWidget(
        radius: 360,
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
