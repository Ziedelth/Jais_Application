import 'package:shared_preferences/shared_preferences.dart';

class AnimeSearchNotifier {
  final _key = 'search';
  SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool get hasSearch => getSearch().isNotEmpty;

  List<String> getSearch() => _sharedPreferences?.containsKey(_key) == true
      ? _sharedPreferences!.getStringList(_key)!
      : [];

  Future<void> setSearch(List<String> search) async =>
      _sharedPreferences?.setStringList(_key, search);

  Future<void> clearSearch() async => _sharedPreferences?.remove(_key);

  Future<void> addSearch(String search) async {
    final searchList = getSearch();

    if (!searchList.contains(search)) {
      searchList.add(search);
      await setSearch(searchList);
    }
  }

  Future<void> removeSearch(String search) async {
    final searchList = getSearch();

    if (searchList.contains(search)) {
      searchList.remove(search);
      await setSearch(searchList);
    }
  }
}
