import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/onboarding/view/signup_page.dart';

import '../../../../../profile/model/user.dart';
import '../../../../bloc/onboarding_bloc.dart';

class MobileWelcomePage extends StatefulWidget {
  final PageController? pageController;
  const MobileWelcomePage({this.pageController, super.key});

  @override
  State<MobileWelcomePage> createState() => _MobileWelcomePageState();
}

class _MobileWelcomePageState extends State<MobileWelcomePage> {
  @override
  Widget build(BuildContext context) {
    UserType userType = context.watch<OnboardingBloc>().userType;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('A platform built for the future of work.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              const Gutter(),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: FittedBox(
                      child: Text('I am a',
                          style: Theme.of(context).textTheme.headlineLarge),
                    )),
                    const Gutter(),
                    Flexible(
                      child: FittedBox(
                        child: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            onSelected: (value) {
                              setState(() {
                                context.read<OnboardingBloc>().userType =
                                    value == 'Freelancer'
                                        ? UserType.freelancer
                                        : UserType.client;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            //color: Colors.white,
                            elevation: 2.0,
                            constraints: const BoxConstraints(maxWidth: 400.0),
                            itemBuilder: (context) => [
                                  userType == UserType.client
                                      ? PopupMenuItem(
                                          value: 'Freelancer',
                                          child: Text('Freelancer',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        )
                                      : PopupMenuItem(
                                          value: 'Client',
                                          child: Text('Client',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        )
                                ],
                            child: const SizedBox(
                              height: 60,
                              child: FittedBox(child: UserTypeInputChip()),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              const Gutter(),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 64.0, vertical: 8.0),
                        ),
                        onPressed: () async {
                          print('Get Started Clicked');
                          context.read<OnboardingBloc>().userType = userType;
                          await widget.pageController?.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
