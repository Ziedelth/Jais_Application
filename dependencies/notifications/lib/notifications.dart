library notifications;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notifications/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications {
  static final instance = Notifications();
  late final SharedPreferences _sharedPreferences;
  final _topicsKey = "topics";
  final _typeKey = "type";

  List<String> getTopics() => _sharedPreferences.containsKey(_topicsKey)
      ? _sharedPreferences.getStringList(_topicsKey)!
      : <String>[];

  bool hasTopic(String topic) => getTopics().contains(topic);

  Future<void> addTopic(String topic) async {
    final list = getTopics();

    if (hasTopic(topic)) {
      return;
    }

    list.add(topic);
    await _sharedPreferences.setStringList(_topicsKey, list);
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> removeTopic(String topic) async {
    final list = getTopics();

    if (!hasTopic(topic)) {
      return;
    }

    list.remove(topic);
    await _sharedPreferences.setStringList(_topicsKey, list);
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<void> removeAllTopics() async {
    final list = getTopics();

    await Future.wait([
      for (final topic in list)
        FirebaseMessaging.instance.unsubscribeFromTopic(topic),
    ]);

    list.clear();
    await _sharedPreferences.setStringList(_topicsKey, list);
  }

  String getType() => _sharedPreferences.containsKey(_typeKey)
      ? _sharedPreferences.getString(_typeKey)!
      : "default";

  Future<void> setType(String type) async {
    await _sharedPreferences.setString(_typeKey, type);
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final isInit = _sharedPreferences.containsKey(_topicsKey) &&
        _sharedPreferences.containsKey(_typeKey);

    if (!isInit) {
      await addTopic("animes");
      await setType("default");
    }
  }
}
