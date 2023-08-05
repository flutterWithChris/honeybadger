import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

import '../../../../../profile/model/user.dart';
import '../../../../bloc/onboarding_bloc.dart';

class MobileWelcomePage extends StatefulWidget {
  final PageController? pageController;
  const MobileWelcomePage({this.pageController, super.key});

  @override
  State<MobileWelcomePage> createState() => _MobileWelcomePageState();
}

class _MobileWelcomePageState extends State<MobileWelcomePage> {
  UserType _userType = UserType.freelancer;
  @override
  Widget build(BuildContext context) {
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
                                if (value == 'Freelancer') {
                                  _userType = UserType.freelancer;
                                } else if (value == 'Client') {
                                  _userType = UserType.client;
                                }
                                context.read<OnboardingBloc>().userType =
                                    _userType;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            //color: Colors.white,
                            elevation: 2.0,
                            constraints: const BoxConstraints(maxWidth: 400.0),
                            itemBuilder: (context) => [
                                  _userType == UserType.client
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
                            child: SizedBox(
                              height: 50,
                              child: FittedBox(
                                child: Chip(
                                  avatar: const Icon(Icons.arrow_drop_down,
                                      size: 36.0),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          _userType == UserType.freelancer
                                              ? 'Freelancer'
                                              : 'Client',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge),
                                    ],
                                  ),
                                ),
                              ),
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
                          context.read<OnboardingBloc>().userType = _userType;
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
