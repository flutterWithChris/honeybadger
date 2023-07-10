import 'package:go_router/go_router.dart';
import 'package:honeybadger/onboarding/view/onboarding_page.dart';
import 'package:honeybadger/onboarding/view/pages/welcome_page.dart';
import 'package:honeybadger/profile/model/user.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => OnboardingPage(
        userType: state.extra as UserType? ?? UserType.freelancer,
      ),
    ),
    GoRoute(
      name: 'welcome',
      path: '/welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);
