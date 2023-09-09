import 'package:outsourcedx/login/view/login_page.dart';
import 'package:outsourcedx/message/bloc/messages_bloc.dart';
import 'package:outsourcedx/message/view/new_chat_screen.dart';
import 'package:outsourcedx/profile/public/view/freelancer_public_profile_page.dart';
import 'package:outsourcedx/settings/pages/privacy_policy.dart';
import 'package:outsourcedx/settings/pages/terms_of_service.dart';
import 'package:outsourcedx/settings/view/settings_page.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/auth/bloc/auth_bloc.dart';
import 'package:outsourcedx/message/channel_page.dart';
import 'package:outsourcedx/message/view/messages_page.dart';
import 'package:outsourcedx/onboarding/stripe_confirmation.dart';
import 'package:outsourcedx/onboarding/view/onboarding_page.dart';
import 'package:outsourcedx/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:outsourcedx/payments/details/payment_details.dart';
import 'package:outsourcedx/payments/model/balance_transaction.dart';
import 'package:outsourcedx/payments/view/payments_page.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/profile/view/profile_page.dart';
import 'package:outsourcedx/projects/bloc/projects_bloc.dart';
import 'package:outsourcedx/projects/create-project/view/create_project.dart';
import 'package:outsourcedx/projects/model/project.dart';
import 'package:outsourcedx/projects/view/project_details_page/mobile/mobile_job_page.dart';
import 'package:outsourcedx/projects/view/project_details_page/project_page.dart';
import 'package:outsourcedx/projects/view/projects_page/projects_page.dart';
import 'package:outsourcedx/proposals/create/view/create_proposal_page.dart';
import 'package:outsourcedx/proposals/model/proposal.dart';
import 'package:outsourcedx/proposals/view/view_proposal.dart';
import 'package:outsourcedx/search/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  observers: [HeroController()],
  initialLocation: '/search',
  redirect: (context, state) async {
    bool loggedIn =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;
    bool isOnboarding = state.matchedLocation.contains('/onboarding');
    bool isLoggingIn = state.matchedLocation == '/login';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: **IMPORTANT** Change this back
    bool onboarded = prefs.getBool('onboarded') ?? false;
    //bool onboarded = false;
    if (state.matchedLocation.contains('privacy-policy') ||
        state.matchedLocation.contains('terms-of-service')) {
      return null;
    }
    if (state.matchedLocation == '/') {
      return '/search';
    }
    if (isOnboarding) {
      return null;
    }
    if (!onboarded) {
      if (state.matchedLocation.contains('stripe')) {
        return null;
      } else {
        return '/onboarding';
      }
    }
    if (!loggedIn) {
      return isLoggingIn ? null : '/login';
    }

    final isLoggedIn = state.path == '/';

    if (loggedIn && isLoggingIn) return isLoggedIn ? null : '/';

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
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const LoginPage();
        }),
    GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
        routes: [
          GoRoute(
              path: 'freelancer-profile/:id',
              name: 'freelancer-profile',
              builder: (context, state) {
                return FreelancerPublicProfilePage(
                  userId: state.extra as String,
                );
              }),
        ]),
    GoRoute(
        path: '/project/:id',
        name: 'project',
        pageBuilder: (context, state) => CustomTransitionPage(
              transitionDuration: 400.ms,
              reverseTransitionDuration: 400.ms,
              child: ProjectDetailsPage(project: state.extra as Project),
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
              project: state.extra as Project,
            ),
          ),
          GoRoute(
              path: 'submit-work',
              name: 'submit-work',
              builder: (context, state) => const SubmitWorkDialog()),
          GoRoute(
              path: 'proposals/:proposalId',
              name: 'proposals',
              builder: (
                context,
                state,
              ) {
                return ViewProposalPage(
                  proposal: state.extra as Proposal,
                );
              }),
        ]),
    GoRoute(
      path: '/projects',
      name: 'projects',
      builder: (context, state) {
        if (context.read<ProfileBloc>().state.user != null &&
            context.read<ProjectsBloc>().state is ProjectsLoaded == false) {
          context
              .read<ProjectsBloc>()
              .add(LoadProjects(user: context.read<ProfileBloc>().state.user!));
        }
        return const ProjectsPage();
      },
    ),
    GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) {
          if (context.read<MessagesBloc>().state is MessagesInitial) {
            context.read<MessagesBloc>().add(LoadMessages());
          }
          return StreamChat(
              client: StreamChat.of(context).client,
              child: const MessagesPage());
        },
        routes: [
          GoRoute(
            path: 'channel/:id',
            name: 'channel',
            builder: (context, state) => StreamChannel(
                channel: state.extra as Channel, child: const ChannelPage()),
          ),
          GoRoute(
              path: 'new-chat',
              name: 'new-chat',
              builder: (context, state) => const NewChatScreen()),
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
          context.read<ProfileBloc>().add(LoadProfile());

          return StripeConfirmationPage(
            stripeAccountId: state.uri.queryParameters['account_id']!,
          );
        }),
    GoRoute(
      path: '/create-project',
      name: 'create-project',
      builder: (context, state) => const CreateProjectPage(),
    ),
    GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
              path: 'privacy-policy',
              name: 'privacy-policy',
              builder: (context, state) {
                return const PrivacyPolicy();
              }),
          GoRoute(
              path: 'terms-of-service',
              name: 'terms-of-service',
              builder: (context, state) {
                return const TermsOfService();
              })
        ])
  ],
);
