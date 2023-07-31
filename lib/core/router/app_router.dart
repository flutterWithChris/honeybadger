import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/auth/bloc/auth_bloc.dart';
import 'package:honeybadger/jobs/create-project/view/create_project.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/view/job_details_page/job_page.dart';
import 'package:honeybadger/jobs/view/jobs_page/jobs_page.dart';
import 'package:honeybadger/message/channel_page.dart';
import 'package:honeybadger/message/view/messages_page.dart';
import 'package:honeybadger/onboarding/stripe_confirmation.dart';
import 'package:honeybadger/onboarding/view/onboarding_page.dart';
import 'package:honeybadger/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/payments/details/payment_details.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';
import 'package:honeybadger/payments/view/payments_page.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/profile/view/profile_page.dart';
import 'package:honeybadger/proposals/create/view/create_proposal_page.dart';
import 'package:honeybadger/search/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  observers: [HeroController()],
  initialLocation: '/search',
  redirect: (context, state) async {
    bool loggedIn =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;
    print('Logged in: $loggedIn');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboarded = true;

    // onboarded = prefs.getBool('onboarded') ?? false;
    if (loggedIn == false) {
      return '/onboarding';
    }
    if (onboarded == false) {
      if (state.location.contains('stripe-confirmation')) {
        return null;
      }
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
        builder: (context, state) => StreamChat(
            client: StreamChat.of(context).client, child: const MessagesPage()),
        routes: [
          GoRoute(
            path: 'channel/:id',
            name: 'channel',
            builder: (context, state) => StreamChannel(
                channel: state.extra as Channel, child: const ChannelPage()),
          ),
        ]),
    GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) {
          // if (context.read<ProfileBloc>().state is ProfileLoaded == false) {
          //   context.read<ProfileBloc>().add(LoadProfile());
          // } if (context.read<PaymentsBloc>().add(LoadPayments(user: )))
          return const PaymentsPage();
        },
        routes: [
          GoRoute(
            path: 'details/:id',
            name: 'details',
            builder: (context, state) {
              return PaymentDetailsPage(
                  balanceTransaction: state.extra as BalanceTransaction);
            },
          )
        ]),
    GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage()),
    GoRoute(
        path: '/stripe-confirmation',
        name: 'stripe-confirmation',
        builder: (context, state) {
          if (context.read<ProfileBloc>().state.user != null) {
            context.read<PaymentsBloc>().add(
                LoadPayments(user: context.read<ProfileBloc>().state.user!));
          }
          return StripeConfirmationPage(
            stripeAccountId: state.queryParameters['account_id']!,
          );
        }),
    GoRoute(
      path: '/create-project',
      name: 'create-project',
      builder: (context, state) => const CreateProjectPage(),
    )
  ],
);
