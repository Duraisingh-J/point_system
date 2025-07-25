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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDVHCmYD2jnZwVnWcDT_YmJ5Ma9dZowozM',
    appId: '1:100189662257:web:35abfdd3fd11dbad983910',
    messagingSenderId: '100189662257',
    projectId: 'pointsystem-accbd',
    authDomain: 'pointsystem-accbd.firebaseapp.com',
    databaseURL: 'https://pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pointsystem-accbd.firebasestorage.app',
    measurementId: 'G-E1PKW4B2V5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaAhZZz-_M81IR6fkAWDuMWaeumIN3Blk',
    appId: '1:100189662257:android:7439119a99c3184a983910',
    messagingSenderId: '100189662257',
    projectId: 'pointsystem-accbd',
    databaseURL: 'https://pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pointsystem-accbd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLfZfSSInpFujZ5d_mdgrMrwZBhN_95AQ',
    appId: '1:100189662257:ios:a0ae55102a613af4983910',
    messagingSenderId: '100189662257',
    projectId: 'pointsystem-accbd',
    databaseURL: 'https://pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pointsystem-accbd.firebasestorage.app',
    iosBundleId: 'com.example.pointSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDLfZfSSInpFujZ5d_mdgrMrwZBhN_95AQ',
    appId: '1:100189662257:ios:a0ae55102a613af4983910',
    messagingSenderId: '100189662257',
    projectId: 'pointsystem-accbd',
    databaseURL: 'https://pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pointsystem-accbd.firebasestorage.app',
    iosBundleId: 'com.example.pointSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVHCmYD2jnZwVnWcDT_YmJ5Ma9dZowozM',
    appId: '1:100189662257:web:ac405dcbbb76b30e983910',
    messagingSenderId: '100189662257',
    projectId: 'pointsystem-accbd',
    authDomain: 'pointsystem-accbd.firebaseapp.com',
    databaseURL: 'https://pointsystem-accbd-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pointsystem-accbd.firebasestorage.app',
    measurementId: 'G-KM9WX0YXBC',
  );
}
