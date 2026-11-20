import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsAuthObserver {
  static void iniciar() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
        FirebaseCrashlytics.instance.setCustomKey(
          'EMAIL',
          user.email ?? "sem email",
        );
        debugPrint("Usuario logado e identificado no Crashlytics: ${user.uid}");
      } else {
        FirebaseCrashlytics.instance.setUserIdentifier("");
        debugPrint("Usuario deslogado");
      }
    });
  }
}
