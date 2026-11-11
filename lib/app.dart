import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/theme.dart';

// ── Screen imports (built by other workers) ─────────────────────────────────
import 'presentation/splash/splash_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/home/main_shell.dart';
import 'presentation/kreator/kreator_detail_screen.dart';
import 'presentation/request/request_form_screen.dart';

/// Root widget of the KriyaLink application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: KriyaLinkTheme.lightTheme,
      initialRoute: kRouteSplash,
      routes: _routes,
    );
  }

  /// Named route table.
  static final Map<String, WidgetBuilder> _routes = {
    kRouteSplash: (_) => const SplashScreen(),
    kRouteOnboarding: (_) => const OnboardingScreen(),
    kRouteHome: (_) => const MainShell(),
    kRouteKreatorDetail: (_) => const KreatorDetailScreen(),
    kRouteRequestForm: (_) => const RequestFormScreen(),
  };
}
