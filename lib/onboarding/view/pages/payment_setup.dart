import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSetupPage extends StatelessWidget {
  final PageController pageController;
  const PaymentSetupPage({required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  constraints.maxWidth > tabletWidthConstraint ? 48.0 : 24.0,
              vertical: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 12.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on),
                    Text(
                      'Payment Setup',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                const Gutter(),
                Text(
                  'Payments are made through Stripe. Set up your Stripe account to be able to receive payouts.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gutter(),
                BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, state) {
                    if (state is PaymentsLoading) {
                      return FractionallySizedBox(
                        widthFactor:
                            constraints.maxWidth > tabletWidthConstraint
                                ? 0.2
                                : 0.618,
                        child: FilledButton.icon(
                            onPressed: () {
                              scaffoldKey.currentState!.showSnackBar(
                                const SnackBar(
                                  content: Text('Loading...'),
                                ),
                              );
                            },
                            icon: LoadingAnimationWidget.discreteCircle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 18.0),
                            label: const Text('Loading...')),
                      );
                    }
                    if (state is PaymentsError) {
                      return Column(
                        children: [
                          Text(state.message),
                          const Gutter(),
                          FractionallySizedBox(
                            widthFactor:
                                constraints.maxWidth > tabletWidthConstraint
                                    ? 0.2
                                    : 0.618,
                            child: FilledButton.icon(
                                onPressed: () {
                                  context.read<PaymentsBloc>().add(
                                      SetupPaymentAccount(
                                          context: context,
                                          user: context
                                              .read<ProfileBloc>()
                                              .state
                                              .user!));
                                },
                                icon: const Icon(FontAwesomeIcons.stripeS,
                                    size: 16),
                                label: const Text('Try Again')),
                          ),
                        ],
                      );
                    }
                    if (state is PaymentsLoaded || state is PaymentsInitial) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                    onPressed: () {
                                      context.read<PaymentsBloc>().add(
                                          SetupPaymentAccount(
                                              context: context,
                                              user: context
                                                  .read<OnboardingBloc>()
                                                  .state
                                                  .user!));
                                    },
                                    icon: const Icon(FontAwesomeIcons.stripeS,
                                        size: 16),
                                    label: const Text('Setup Stripe Account')),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      alignment: Alignment.center,
                                      // actionsPadding: const EdgeInsets.only(
                                      //     right: 78.0, bottom: 24.0),

                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      title: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Skip Payment Setup'),
                                        ],
                                      ),
                                      content: const Text.rich(
                                        TextSpan(
                                          text:
                                              'You won\'t be able to send proposals or receive payouts \'til you set up your Stripe account. ',
                                          children: [
                                            TextSpan(
                                              text:
                                                  '\n\nYou can set up your Stripe account later via the payments page.',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Cancel')),
                                            ),
                                            const Gutter(),
                                            Expanded(
                                              child: FilledButton(
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setBool(
                                                        'onboarded', true);
                                                    context.go('/search');
                                                  },
                                                  child: const Text('Skip')),
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Skip For Now'))
                        ],
                      );
                    }
                    return const Center(
                      child: Text('Something Went Wrong...'),
                    );
                  },
                ),
                const GutterLarge(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
