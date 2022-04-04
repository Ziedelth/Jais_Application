import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/utils/firebase_options.dart';

final GetStorage _getStorage = GetStorage();
const _key = "topics";

Future<void> initFirebase() async => Firebase.initializeApp(
      options: currentPlatform,
    );

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async =>
    initFirebase();

List<String> getTopics() => _getStorage.hasData(_key)
    ? (_getStorage.read(_key) as List<dynamic>)
        .map((e) => e.toString())
        .toList()
    : List<String>.empty(growable: true);

bool hasTopic(String topic) => getTopics().contains(topic);

void addTopic(String topic) {
  final List<String> list = getTopics();

  if (hasTopic(topic)) {
    return;
  }

  if (topic != "animes") {
    list.remove("animes");
  }

  list.add(topic);
  FirebaseMessaging.instance.subscribeToTopic(topic);
  _getStorage.write(_key, list);
}

void removeTopic(String topic) {
  final List<String> list = getTopics();

  if (!hasTopic(topic)) {
    return;
  }

  list.remove(topic);
  FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  _getStorage.write(_key, list);
}

void removeAllTopics() {
  final List<String> list = getTopics();

  for (final String topic in list) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  list.clear();
  _getStorage.write(_key, list);
}

Future<void> init() async {
  await initFirebase();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final bool firstInit = !_getStorage.hasData('init');

  if (firstInit) {
    addTopic("animes");
  }

  _getStorage.write('init', true);
}
