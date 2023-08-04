import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 5,
              child: CustomScrollView(
                slivers: [
                  const MobileSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                  'A platform built for the future of work.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const GutterLarge(),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: FittedBox(
                                  child: Text('I am a',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                )),
                                const Gutter(),
                                Flexible(
                                  child: FittedBox(
                                    child: PopupMenuButton(
                                        onSelected: (value) {
                                          setState(() {
                                            if (value == 'Freelancer') {
                                              _userType = UserType.freelancer;
                                            } else if (value == 'Client') {
                                              _userType = UserType.client;
                                            }
                                            context
                                                .read<OnboardingBloc>()
                                                .userType = _userType;
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        //color: Colors.white,
                                        elevation: 2.0,
                                        constraints: const BoxConstraints(
                                            maxWidth: 400.0),
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'Freelancer',
                                                child: Text('Freelancer',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium),
                                              ),
                                              PopupMenuItem(
                                                value: 'Client',
                                                child: Text('Client',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium),
                                              ),
                                            ],
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    _userType ==
                                                            UserType.freelancer
                                                        ? 'Freelancer'
                                                        : 'Client',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall),
                                                const Gutter(),
                                                const Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 40.0),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const GutterLarge(),
                          FilledButton(
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 64.0, vertical: 8.0),
                              ),
                              onPressed: () async {
                                print('Get Started Clicked');
                                context.read<OnboardingBloc>().userType =
                                    _userType;
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
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    // Text('Why Honeybadger?',
                    //     textAlign: TextAlign.center,
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .headlineMedium
                    //         ?.copyWith(fontWeight: FontWeight.bold)),
                    // const GutterLarge(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: [
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(MdiIcons.cashMultiple, size: 36.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text(
                                        'Lower Fees.\nFaster, Direct Payments.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'Payments are made directly to you.\nNo middleman. No fees. No waiting.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.money_off, size: 40.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text(
                                        'Start Earning for Free.\nApply For Free.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'Free until you reach \$1,000 in monthly earnings. No fees to apply to job postings.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(MdiIcons.trophyAward, size: 40.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text('Hard work pays off.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'Get rewarded for successful jobs.\nWe\'re here to grow together.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.visibility_outlined,
                                      size: 40.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text('Visibility & Stability',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'No shadow banning or gamifying rankings. We\'re here to help you succeed, not hinder you.',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_outline_rounded,
                                      size: 40.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text(
                                        'Qualified Clients & Freelancers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'We vet our clients & freelancers to ensure that you\'re working with the best of the best.',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                        Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.messenger_outline_rounded,
                                      size: 40.0),
                                  const Gutter(),
                                  Flexible(
                                    child: Text('Clear Communication',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const Gutter(),
                              Text(
                                  'Streamlined text, voice, & video chat to make sure you\'re always on the same page with your clients & freelancers.',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
