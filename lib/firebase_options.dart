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
    apiKey: 'AIzaSyAcgYHXZQSCFG-NwcE-_rePz31mc_OJWpQ',
    appId: '1:727997255439:web:695b2210369efb40d5387a',
    messagingSenderId: '727997255439',
    projectId: 'vitevents-fdce6',
    authDomain: 'vitevents-fdce6.firebaseapp.com',
    storageBucket: 'vitevents-fdce6.firebasestorage.app',
    measurementId: 'G-ZF03YCQDEJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6lFwgGzEPrIrQr3FdIVr_nGPHgoetoq4',
    appId: '1:727997255439:android:df29bb58adbf6946d5387a',
    messagingSenderId: '727997255439',
    projectId: 'vitevents-fdce6',
    storageBucket: 'vitevents-fdce6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAct1TeuEYcBpzl581uNmmrdB3f8mFgiUQ',
    appId: '1:727997255439:ios:cb8c3f9cc746b34cd5387a',
    messagingSenderId: '727997255439',
    projectId: 'vitevents-fdce6',
    storageBucket: 'vitevents-fdce6.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAct1TeuEYcBpzl581uNmmrdB3f8mFgiUQ',
    appId: '1:727997255439:ios:cb8c3f9cc746b34cd5387a',
    messagingSenderId: '727997255439',
    projectId: 'vitevents-fdce6',
    storageBucket: 'vitevents-fdce6.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAcgYHXZQSCFG-NwcE-_rePz31mc_OJWpQ',
    appId: '1:727997255439:web:84a8e19e09733376d5387a',
    messagingSenderId: '727997255439',
    projectId: 'vitevents-fdce6',
    authDomain: 'vitevents-fdce6.firebaseapp.com',
    storageBucket: 'vitevents-fdce6.firebasestorage.app',
    measurementId: 'G-P7S8J5GHMN',
  );
}