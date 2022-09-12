import 'package:jais/mappers/jmapper.dart';
import 'package:jais/models/genre.dart';
import 'package:jais/utils/const.dart';

class GenreMapper extends JMapper<Genre> {
  static final instance = GenreMapper();

  GenreMapper() : super(url: getGenresUrl(), fromJson: Genre.fromJson);

  @override
  Future<void> update() async {
    await super.update();
    list.retainWhere((element) => element.name == 'UNKNOWN');
  }
}
