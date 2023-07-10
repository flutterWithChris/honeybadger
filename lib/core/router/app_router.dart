import 'package:go_router/go_router.dart';
import 'package:honeybadger/onboarding/view/onboarding_page.dart';
import 'package:honeybadger/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/search/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/onboarding',
  redirect: (context, state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboarded = prefs.getBool('onboarded') ?? false;

    if (onboarded == false) {
      return '/onboarding';
    }

    if (onboarded) {
      return null;
    }
    return null;
  },
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
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchPage(),
    )
  ],
);
