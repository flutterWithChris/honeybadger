import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:OutsourcedX/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:OutsourcedX/payments/bloc/payments_bloc.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripeConfirmationPage extends StatelessWidget {
  final String stripeAccountId;
  const StripeConfirmationPage({required this.stripeAccountId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        MobileSliverAppBar(noActions: true),
        SliverFillRemaining(
          child: BlocConsumer<PaymentsBloc, PaymentsState>(
            listener: (context, state) async {
              if (state is PaymentsLoaded &&
                  state.stripeAccountStatus == StripeAccountStatus.complete) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('paymentSetupComplete', true);
                await prefs.setBool('onboarded', true);
              }
            },
            builder: (context, state) {
              if (state is PaymentsLoading ||
                  context.watch<ProfileBloc>().state is ProfileLoading) {
                return Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                      color: Theme.of(context).primaryColor, size: 40.0),
                );
              }
              if (state is PaymentsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Error'),
                      const Gutter(),
                      Text(state.message),
                      const Gutter(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );
              }
              if (state is PaymentsLoaded &&
                  state.stripeAccountStatus == StripeAccountStatus.complete) {
                bool setupComplete = (state
                        .stripeAccount?.requirements?['currently_due'] as List)
                    .isEmpty;
                print(
                    'Currently Due: ${state.stripeAccount?.requirements?['currently_due']}');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 24.0),
                            const Gutter(),
                            Text(
                              'Stripe Setup Complete',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        const Gutter(),
                        Text(
                          'Thank you! Your Stripe account is now ready to receive payouts.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const Gutter(),
                        FilledButton(
                            onPressed: () async {
                              context.go('/search');
                            },
                            child: const Text('Finish Setup')),
                        const Gutter(),
                        Text(
                          'You can access your Stripe account & dashboard at any time by going to the "Payments" page.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is PaymentsLoaded &&
                  state.stripeAccountStatus == StripeAccountStatus.incomplete) {
                print(
                    'Currently Due: ${state.stripeAccount?.requirements?['currently_due']}');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 12.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.red, size: 32.0),
                            Text(
                              'Setup Incomplete',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        const Gutter(),
                        const Text.rich(
                          TextSpan(
                            text:
                                'It looks like you have not completed your Stripe setup!',
                            children: [
                              TextSpan(
                                text:
                                    ' Please complete your setup to be able to receive payouts.',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gutter(),
                        FilledButton(
                            onPressed: () async {
                              context.read<PaymentsBloc>().add(
                                  FinishSetupPaymentAccount(
                                      user: context
                                          .read<ProfileBloc>()
                                          .state
                                          .user!,
                                      context: context));
                            },
                            child: const Text('Finish Setup')),

                        const Gutter(),
                        // Card to display the currently due requirements
                        // Card(
                        //     child: Padding(
                        //         padding: const EdgeInsets.all(16.0),
                        //         child: Column(
                        //           children: [
                        //             Text(
                        //               'Currently Due',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .titleLarge,
                        //             ),
                        //             const GutterSmall(),
                        //             Text(
                        //               'Please complete the following requirements to finish setting up your Stripe account:',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyMedium,
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             const Gutter(),
                        //             // List of requirements
                        //             ListView.builder(
                        //               padding: EdgeInsets.zero,
                        //               shrinkWrap: true,
                        //               itemCount: state
                        //                   .stripeAccount
                        //                   ?.requirements?['currently_due']
                        //                   .length,
                        //               itemBuilder: (context, index) {
                        //                 return Text(
                        //                   '- ${state.stripeAccount!.requirements!['currently_due'][index].split('_').join(' ').split('.').join(' ').toString().toTitleCase()}',
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .bodyMedium,
                        //                   textAlign: TextAlign.center,
                        //                 );
                        //               },
                        //             ),
                        //           ],
                        //         )))
                      ],
                    ),
                  ),
                );
              }
              if (state is PaymentsLoaded &&
                  state.stripeAccountStatus == StripeAccountStatus.notCreated) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 12.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.red, size: 32.0),
                            Text(
                              'Setup Incomplete',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        const Gutter(),
                        const Text.rich(
                          TextSpan(
                            text:
                                'It looks like your Stripe account wasn\'t created!',
                            children: [
                              TextSpan(
                                text:
                                    ' Please complete the Stripe onboarding to be eligible for payouts.',
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gutter(),
                        FilledButton(
                            onPressed: () async {
                              context.read<PaymentsBloc>().add(
                                  SetupPaymentAccount(
                                      user: context
                                          .read<ProfileBloc>()
                                          .state
                                          .user!,
                                      context: context));
                            },
                            child: const Text('Setup Stripe Account')),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: Text('Something Went Wrong...'),
              );
            },
          ),
        ),
      ],
    ));
  }
}
