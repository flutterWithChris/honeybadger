import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:outsourcedx/onboarding/bloc/onboarding_bloc.dart';

import '../../../../../profile/model/user.dart';

class TabletWelcomePage extends StatefulWidget {
  final PageController? pageController;
  const TabletWelcomePage({this.pageController, super.key});

  @override
  State<TabletWelcomePage> createState() => _TabletWelcomePageState();
}

class _TabletWelcomePageState extends State<TabletWelcomePage> {
  UserType _userType = UserType.freelancer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            child: NavigationRail(
              selectedIndex: 0,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.search_rounded), label: Text('Search')),
                NavigationRailDestination(
                    icon: Icon(Icons.messenger_outline_rounded),
                    label: Text('Messages')),
                NavigationRailDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    label: Text('Profile')),
              ],
            ),
          ),
          Expanded(
            flex: 12,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 12.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 30.0, color: Colors.grey[800]),
                        Text('Honeybadger',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('A platform built for the future of work.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const Gutter(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Text('I am a',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge)),
                          const Gutter(),
                          Flexible(
                            child: PopupMenuButton(
                                onSelected: (value) {
                                  setState(() {
                                    if (value == 'Freelancer') {
                                      _userType = UserType.freelancer;
                                    } else if (value == 'Client') {
                                      _userType = UserType.client;
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                //color: Colors.white,
                                elevation: 2.0,
                                constraints:
                                    const BoxConstraints(maxWidth: 400.0),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Freelancer',
                                        child: Text('Freelancer',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall),
                                      ),
                                      PopupMenuItem(
                                        value: 'Client',
                                        child: Text('Client',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall),
                                      ),
                                    ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            _userType == UserType.freelancer
                                                ? 'Freelancer'
                                                : 'Client',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge),
                                        const Gutter(),
                                        const Icon(Icons.arrow_drop_down,
                                            size: 40.0),
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      const GutterLarge(),
                      FilledButton.tonal(
                          onPressed: () async {
                            context.read<OnboardingBloc>().userType = _userType;
                            await widget.pageController?.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32.0, vertical: 16.0),
                            child: Text('Get Started',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                          )),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    // /mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Why Honeybadger?',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Gutter(),
                      Flexible(
                          child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 12.0,
                          runSpacing: 12.0,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 6 / 4,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.payments_outlined,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text(
                                                  'Lower Fees, Faster Payments',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'We don\'t take a cut of your earnings & payments are made directly to you for quicker, no-fee payouts.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 5 / 4,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.favorite_border_outlined,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text(
                                                  'We <3 our freelancers & clients.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'We\'re nothing without our community of hard-working freelancers & clients. So, we make sure to reward you to show our appreciation.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 6 / 4,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.visibility_outlined,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text(
                                                  'Visibility & Stability',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'No shadow banning or gamifying rankings. We\'re here to help you succeed, not hinder you.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 6 / 4,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text(
                                                  'Qualified Clients & Freelancers',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'We vet our clients & freelancers to ensure that you\'re working with the best of the best.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 6 / 5,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.messenger_outline_rounded,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text('Clear Communication',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'Streamlined text, voice, & video chat to make sure you\'re always on the same page with your clients & freelancers.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 200.0, maxWidth: 350.0),
                              child: AspectRatio(
                                  aspectRatio: 5 / 3,
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 32.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.money_off,
                                                size: 40.0),
                                            const Gutter(),
                                            Flexible(
                                              child: Text('\$0 to get started.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Gutter(),
                                        Text(
                                            'No need to pay to get started. Applying to & posting jobs is free.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
