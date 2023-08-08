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
    apiKey: 'AIzaSyAUdTao7sM42nWT7vV5m9afu5xdkQ-2F0Q',
    appId: '1:880726937609:web:dc30e3f184deda191268d8',
    messagingSenderId: '880726937609',
    projectId: 'blac-coffer',
    authDomain: 'blac-coffer.firebaseapp.com',
    storageBucket: 'blac-coffer.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACDLyMBGvWQsGQYQtkaIH3HaV9hdZ0EkE',
    appId: '1:880726937609:android:0755ee15bab3d6521268d8',
    messagingSenderId: '880726937609',
    projectId: 'blac-coffer',
    storageBucket: 'blac-coffer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFbh6X64ir9vZApt1se4OHL9O7IPAMGwQ',
    appId: '1:880726937609:ios:91405a555fe244341268d8',
    messagingSenderId: '880726937609',
    projectId: 'blac-coffer',
    storageBucket: 'blac-coffer.appspot.com',
    iosClientId: '880726937609-7o9idr2kqpr5elpl8ru7s01li3ctabbi.apps.googleusercontent.com',
    iosBundleId: 'com.example.blackCoffer',
  );
}
