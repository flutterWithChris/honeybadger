import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StripeConfirmationPage extends StatelessWidget {
  final String stripeAccountId;
  const StripeConfirmationPage({required this.stripeAccountId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PaymentsBloc, PaymentsState>(
        builder: (context, state) {
          if (state is PaymentsLoading) {
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
          if (state is PaymentsLoaded) {
            bool setupComplete = state
                        .stripeAccount?.requirements?['currently_due']
                        .toString() ==
                    '' ||
                state.stripeAccount?.requirements?['currently_due'] == null;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Stripe Confirmation Page'),
                  const Gutter(),
                  const Text('Stripe Account ID: '),
                  const Gutter(),
                  const Text('Account Complete: '),
                  Text(setupComplete.toString()),
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
          return const Center(
            child: Text('Something Went Wrong...'),
          );
        },
      ),
    );
  }
}
