import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentSetupPage extends StatelessWidget {
  final PageController pageController;
  const PaymentSetupPage({required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Payment Setup',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Gutter(),
              Text(
                'Payments are made through Stripe. Set up or Login to your Stripe account to be able to receive payouts.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Gutter(),
              Text.rich(TextSpan(
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
                  ])),
              const GutterLarge(),
              FractionallySizedBox(
                widthFactor: 0.2,
                child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.stripeS, size: 16),
                    label: const Text('Connect with Stripe')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
