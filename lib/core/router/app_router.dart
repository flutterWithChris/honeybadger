import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:OutsourcedX/auth/bloc/auth_bloc.dart';
import 'package:OutsourcedX/message/channel_page.dart';
import 'package:OutsourcedX/message/view/messages_page.dart';
import 'package:OutsourcedX/onboarding/stripe_confirmation.dart';
import 'package:OutsourcedX/onboarding/view/onboarding_page.dart';
import 'package:OutsourcedX/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:OutsourcedX/payments/bloc/payments_bloc.dart';
import 'package:OutsourcedX/payments/details/payment_details.dart';
import 'package:OutsourcedX/payments/model/balance_transaction.dart';
import 'package:OutsourcedX/payments/view/payments_page.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:OutsourcedX/profile/view/profile_page.dart';
import 'package:OutsourcedX/projects/bloc/projects_bloc.dart';
import 'package:OutsourcedX/projects/create-project/view/create_project.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/projects/view/project_details_page/mobile/mobile_job_page.dart';
import 'package:OutsourcedX/projects/view/project_details_page/project_page.dart';
import 'package:OutsourcedX/projects/view/projects_page/projects_page.dart';
import 'package:OutsourcedX/proposals/create/view/create_proposal_page.dart';
import 'package:OutsourcedX/proposals/model/proposal.dart';
import 'package:OutsourcedX/proposals/view/view_proposal.dart';
import 'package:OutsourcedX/search/view/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

GoRouter goRouter = GoRouter(
  debugLogDiagnostics: true,
  observers: [HeroController()],
  initialLocation: '/search',
  redirect: (context, state) async {
    bool loggedIn =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;
    bool isOnboarding = state.matchedLocation.contains('onboarding');
    print('Logged in: $loggedIn');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: **IMPORTANT** Change this back
    // bool onboarded = prefs.getBool('onboarded') ?? false;
    bool onboarded = false;
    if (isOnboarding) {
      return null;
    }
    if (loggedIn == false) {
      return '/onboarding';
    }
    if (onboarded == false) {
      if (state.matchedLocation.contains('stripe-confirmation')) {
        return '/stripe-confirmation?${state.uri.query}';
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
          print('State path params: ${state.uri.queryParameters}');
          return StripeConfirmationPage(
            stripeAccountId: state.uri.queryParameters['account_id']!,
          );
        }),
    GoRoute(
      path: '/create-project',
      name: 'create-project',
      builder: (context, state) => const CreateProjectPage(),
    )
  ],
);
