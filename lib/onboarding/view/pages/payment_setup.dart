import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';

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
                  'Payments are made through Stripe. Set up or Login to your Stripe account to be able to receive payouts.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const GutterLarge(),
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
                            icon:
                                const Icon(FontAwesomeIcons.stripeS, size: 16),
                            label: const Text('Connect with Stripe')),
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
                    if (state is PaymentsLoaded) {
                      return FractionallySizedBox(
                        widthFactor:
                            constraints.maxWidth > tabletWidthConstraint
                                ? 0.2
                                : 0.618,
                        child: FilledButton.icon(
                            onPressed: () {
                              context.read<PaymentsBloc>().add(
                                  SetupPaymentAccount(
                                      user: context
                                          .read<ProfileBloc>()
                                          .state
                                          .user!));
                            },
                            icon:
                                const Icon(FontAwesomeIcons.stripeS, size: 16),
                            label: const Text('Connect with Stripe')),
                      );
                    }
                    return const Center(
                      child: Text('Something Went Wrong...'),
                    );
                  },
                ),
                const GutterLarge(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text.rich(
                      TextSpan(
                        text: 'Important: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text:
                                  'Since payments are made directly to you, this means you are responsible for reporting your income via 1099 to the IRS based on your state guidelines.',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
