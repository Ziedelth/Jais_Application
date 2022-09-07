import 'package:jais/mappers/jmapper.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/utils/const.dart';

class LangTypeMapper extends JMapper<LangType> {
  static final instance = LangTypeMapper();

  LangTypeMapper() : super(url: getLangTypesUrl(), fromJson: LangType.fromJson);

  @override
  Future<void> update() async {
    await super.update();
    list.retainWhere((element) => element.name == 'UNKNOWN');
  }
}
