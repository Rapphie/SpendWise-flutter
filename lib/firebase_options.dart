// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCtQtqNa25YxMe7RPXT91MQZ7_G6r_aDUk',
    appId: '1:815139196583:web:cd5f69fa50d3508d6ed582',
    messagingSenderId: '815139196583',
    projectId: 'spendwise-a8baa',
    authDomain: 'spendwise-a8baa.firebaseapp.com',
    storageBucket: 'spendwise-a8baa.firebasestorage.app',
    measurementId: 'G-PFEFFWEHKE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApYyeFtYhwKVfUHTbwZg2ESaT8n6VGkPY',
    appId: '1:815139196583:android:212c47aa84be2a796ed582',
    messagingSenderId: '815139196583',
    projectId: 'spendwise-a8baa',
    storageBucket: 'spendwise-a8baa.firebasestorage.app',
  );
}
