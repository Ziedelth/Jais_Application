// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmBtWRFA7Wuq_LMX2PJJiQ93JTLsei3bA',
    appId: '1:866259759032:android:a7a40f3242d342f3fba94d',
    messagingSenderId: '866259759032',
    projectId: 'jais-cc41c',
    storageBucket: 'jais-cc41c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLgX4PbGaGIHBIGTO6S5SnVouMrcMXDnc',
    appId: '1:866259759032:ios:45906fd7e9db9871fba94d',
    messagingSenderId: '866259759032',
    projectId: 'jais-cc41c',
    storageBucket: 'jais-cc41c.appspot.com',
    iosClientId: '866259759032-shkks1eac2ptmhq97einp0d54shqi8ku.apps.googleusercontent.com',
    iosBundleId: 'fr.ziedelth.jais',
  );
}