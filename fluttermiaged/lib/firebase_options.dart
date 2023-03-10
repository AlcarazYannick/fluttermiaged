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
    apiKey: 'AIzaSyCGE00O0PSDVsCbY8ykngZrpCqvgKX9MeQ',
    appId: '1:989065429453:web:6d9b41927eee46915c8484',
    messagingSenderId: '989065429453',
    projectId: 'flutter-miaged-8b6c3',
    authDomain: 'flutter-miaged-8b6c3.firebaseapp.com',
    storageBucket: 'flutter-miaged-8b6c3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNRGsAL6TW2lXBa_zFB3teJqcVK_4ESiM',
    appId: '1:989065429453:android:a6ba34cc3ce3860b5c8484',
    messagingSenderId: '989065429453',
    projectId: 'flutter-miaged-8b6c3',
    storageBucket: 'flutter-miaged-8b6c3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBThIWajVJ5DoiT_4vTNg4BQ84PoutLeSg',
    appId: '1:989065429453:ios:a943ac77ed3b5e125c8484',
    messagingSenderId: '989065429453',
    projectId: 'flutter-miaged-8b6c3',
    storageBucket: 'flutter-miaged-8b6c3.appspot.com',
    iosClientId: '989065429453-7fuua5fqun77j43qviucijrkbnrdv8ub.apps.googleusercontent.com',
    iosBundleId: 'com.example.fluttermiaged',
  );
}
