import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jais/utils/firebase_options.dart';

class JNotifications {
  static final GetStorage getStorage = GetStorage();
  static const KEY = "topics";

  static Future<void> initFirebase() async => await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

  static Future<void> _firebaseMessagingBackgroundHandler(
          RemoteMessage message) async =>
      await initFirebase();

  static List<String> getTopics() => getStorage.hasData(KEY)
      ? getStorage.read(KEY)!.map<String>((element) => element.toString()).toList()
      : List<String>.empty(growable: true);

  static hasTopic(String topic) => getTopics().contains(topic);

  static addTopic(String topic) {
    final List<String> list = getTopics();

    if (hasTopic(topic)) {
      return;
    }

    if (topic != "animes") {
      list.remove("animes");
    }

    list.add(topic);
    FirebaseMessaging.instance.subscribeToTopic(topic);
    getStorage.write(KEY, list);
  }

  static removeTopic(String topic) {
    final List<String> list = getTopics();

    if (!hasTopic(topic)) {
      return;
    }

    list.remove(topic);
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    getStorage.write(KEY, list);
  }

  static removeAllTopics() {
    final List<String> list = getTopics();

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
