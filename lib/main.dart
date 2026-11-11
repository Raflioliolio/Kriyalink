import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Try to initialize Firebase; if google-services.json not set up yet,
  // app still runs with dummy data.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase not configured yet — app will use dummy data
  }

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
