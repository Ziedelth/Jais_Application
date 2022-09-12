import 'package:jais/mappers/jmapper.dart';
import 'package:jais/models/episode_type.dart';
import 'package:jais/utils/const.dart';

class EpisodeTypeMapper extends JMapper<EpisodeType> {
  static final instance = EpisodeTypeMapper();

  EpisodeTypeMapper()
      : super(url: getEpisodeTypesUrl(), fromJson: EpisodeType.fromJson);

  @override
  Future<void> update() async {
    await super.update();
    list.retainWhere((element) => element.name != 'UNKNOWN');
  }
}
