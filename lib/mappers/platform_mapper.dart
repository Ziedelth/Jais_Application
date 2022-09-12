import 'package:jais/mappers/jmapper.dart';
import 'package:jais/models/platform.dart';
import 'package:jais/utils/const.dart';

class PlatformMapper extends JMapper<Platform> {
  static final instance = PlatformMapper();

  PlatformMapper() : super(url: getPlatformsUrl(), fromJson: Platform.fromJson);
}
