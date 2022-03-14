import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/utils/firebase_options.dart';

class JaisNotifications {
  static final GetStorage getStorage = GetStorage('Notifications');
  static const KEY = "topics";

  static Future<void> initFirebase() async => await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

  static Future<void> _firebaseMessagingBackgroundHandler(
          RemoteMessage message) async =>
      await initFirebase();

  static List<String> getTopics() => getStorage.hasData(KEY)
      ? getStorage.read(KEY)
      : List<String>.empty(growable: true);

  static addTopic(String topic) {
    List<String> list = getTopics();

    if (!list.contains(topic)) {
      list.add(topic);
      FirebaseMessaging.instance.subscribeToTopic(topic);
    }

    getStorage.write(KEY, list);
  }

  static removeTopic(String topic) {
    List<String> list = getTopics();

    if (list.contains(topic)) {
      list.remove(topic);
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }

    getStorage.write(KEY, list);
  }

  static removeAllTopics() {
    List<String> list = getTopics();

    for (String topic in list) {
      FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }

    list.clear();
    getStorage.write(KEY, list);
  }

  static Future<void> init() async {
    await initFirebase();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final bool firstInit = !getStorage.hasData('init');

    if (firstInit) {
      addTopic("animes");
    }

    getStorage.write('init', true);
  }
}
