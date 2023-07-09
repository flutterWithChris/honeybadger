import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/onboarding/view/onboarding_page.dart';
import 'package:honeybadger/onboarding/view/pages/welcome_page.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation:
      Platform.isLinux || Platform.isMacOS || Platform.isWindows || kIsWeb
          ? '/welcome'
          : '/onboarding',
  routes: [
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      name: 'welcome',
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);
