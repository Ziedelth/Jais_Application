library notifications;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart' as logger;
import 'package:notifications/firebase_options.dart';

late final GetStorage _getStorage;
const _key = "topics";

Future<void> initFirebase() async =>
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async =>
    initFirebase();

List<String> getTopics() => _getStorage.hasData(_key)
    ? (_getStorage.read(_key) as List<dynamic>)
        .map((e) => e.toString())
        .toList()
    : List<String>.empty(growable: true);

bool hasTopic(String topic) => getTopics().contains(topic);

void addTopic(String topic) {
  final list = getTopics();
  logger.info("Adding topic $topic to $list");

  if (hasTopic(topic)) {
    logger.debug("Topic $topic already exists");
    return;
  }

  list.add(topic);
  logger.info("Writing topics $list");
  _getStorage.write(_key, list);

  logger.info("Subscribing to topic $topic");
  if (!kIsWeb) FirebaseMessaging.instance.subscribeToTopic(topic);
}

void removeTopic(String topic) {
  final list = getTopics();
  logger.info("Removing topic $topic from $list");

  if (!hasTopic(topic)) {
    logger.debug("Topic $topic does not exist");
    return;
  }

  list.remove(topic);
  logger.info("Writing topics $list");
  _getStorage.write(_key, list);

  logger.info("Unsubscribing from topic $topic");
  FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}

void removeAllTopics() {
  final list = getTopics();
  logger.info("Removing all topics $list");

  for (final String topic in list) {
    logger.info("Unsubscribing from topic $topic");
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  list.clear();
  logger.info("Writing topics $list");
  _getStorage.write(_key, list);
}

Future<void> init() async {
  logger.info("Initializing notifications");
  await GetStorage.init('notifications');
  _getStorage = GetStorage('notifications');
  logger.info("Initializing firebase");
  await initFirebase();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final bool firstInit = !_getStorage.hasData('init');
  logger.debug("First init: $firstInit");

  if (firstInit) {
    logger.info("Initializing topics");
    addTopic("animes");
  }

  logger.info("Initializing notifications done");
  _getStorage.write('init', true);
}
