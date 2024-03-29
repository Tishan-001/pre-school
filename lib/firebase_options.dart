// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyDLeBd-y1IG51djdvrX3zua-FqAJx4fwRI',
    appId: '1:169025738096:web:0b1dd5f2e0d3bda8c9abb5',
    messagingSenderId: '169025738096',
    projectId: 'pre-school-88b37',
    authDomain: 'pre-school-88b37.firebaseapp.com',
    databaseURL: 'https://pre-school-88b37-default-rtdb.firebaseio.com',
    storageBucket: 'pre-school-88b37.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8N1SBAv__hB9H5Mo2Bt3StYj0uICUt7s',
    appId: '1:169025738096:android:e4ceb227d3b54fc2c9abb5',
    messagingSenderId: '169025738096',
    projectId: 'pre-school-88b37',
    databaseURL: 'https://pre-school-88b37-default-rtdb.firebaseio.com',
    storageBucket: 'pre-school-88b37.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_ArknnCUtHmwpzdHvD-SE71NeK3RFGKY',
    appId: '1:169025738096:ios:5bd4d5608d88bacbc9abb5',
    messagingSenderId: '169025738096',
    projectId: 'pre-school-88b37',
    databaseURL: 'https://pre-school-88b37-default-rtdb.firebaseio.com',
    storageBucket: 'pre-school-88b37.appspot.com',
    iosBundleId: 'com.example.preSchool',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_ArknnCUtHmwpzdHvD-SE71NeK3RFGKY',
    appId: '1:169025738096:ios:297d66fe46a8cff8c9abb5',
    messagingSenderId: '169025738096',
    projectId: 'pre-school-88b37',
    databaseURL: 'https://pre-school-88b37-default-rtdb.firebaseio.com',
    storageBucket: 'pre-school-88b37.appspot.com',
    iosBundleId: 'com.example.preSchool.RunnerTests',
  );
}
