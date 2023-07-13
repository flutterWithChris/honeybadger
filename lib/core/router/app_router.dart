import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/view/job_details_page/job_page.dart';
import 'package:honeybadger/jobs/view/jobs_page/jobs_page.dart';
import 'package:honeybadger/message/view/messages_page.dart';
import 'package:honeybadger/onboarding/view/onboarding_page.dart';
import 'package:honeybadger/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:honeybadger/payments/view/payments_page.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/profile/view/profile_page.dart';
import 'package:honeybadger/proposals/create/view/create_proposal_page.dart';
import 'package:honeybadger/search/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  observers: [HeroController()],
  initialLocation: '/search',
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
    ),
    GoRoute(
        path: '/job/:id',
        name: 'job',
        pageBuilder: (context, state) => CustomTransitionPage(
              transitionDuration: 400.ms,
              reverseTransitionDuration: 400.ms,
              child: JobDetailsPage(job: state.extra as Job),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child,
                );
              },
            ),
        routes: [
          GoRoute(
            path: 'create-proposal',
            name: 'create-proposal',
            builder: (context, state) => CreateProposalPage(
              job: state.extra as Job,
            ),
          ),
        ]),
    GoRoute(
      path: '/jobs',
      name: 'jobs',
      builder: (context, state) => const JobsPage(),
    ),
    GoRoute(
      path: '/messages',
      name: 'messages',
      builder: (context, state) => const MessagesPage(),
    ),
    GoRoute(
      path: '/payments',
      name: 'payments',
      builder: (context, state) => const PaymentsPage(),
    ),
    GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage())
  ],
);
