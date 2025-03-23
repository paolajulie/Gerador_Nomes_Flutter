// Arquivo: firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyDwbGkmiD10xexedpPZFce2M3g7PyxZSmc",
      authDomain: "gerador-nomes.firebaseapp.com",
      databaseURL: "https://gerador-nomes-default-rtdb.firebaseio.com",
      projectId: "gerador-nomes",
      storageBucket: "gerador-nomes.firebasestorage.app",
      messagingSenderId: "601878247740",
      appId: "1:601878247740:web:f14b3a35b2d954bbfe8639");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApOmE7V0j-Mumv_SwpZTYl27s7DkZEihU',
    appId: '1:601878247740:android:6d419c7a8b3f2ca4fe8639',
    messagingSenderId: '601878247740',
    projectId: 'gerador-nomes',
    databaseURL: 'https://gerador-nomes.firebasestorage.app',
  );
}
