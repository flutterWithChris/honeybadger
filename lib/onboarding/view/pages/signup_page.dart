import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';

class SignupPage extends StatelessWidget {
  final UserType userType;
  const SignupPage({required this.userType, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.status == OnboardingStatus.failure) {
          return const Text('Error Onboarding!');
        } else if (state.status == OnboardingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == OnboardingStatus.loaded) {
          return Scaffold(
              body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Your Account.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Gutter(),
                Wrap(
                  spacing: 12.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Icon(FontAwesomeIcons.google, size: 20.0),
                    ),
                    FilledButton.tonal(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black87,
                      ),
                      onPressed: () {},
                      child: const Icon(FontAwesomeIcons.apple, size: 20.0),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Icon(FontAwesomeIcons.github, size: 20.0),
                    ),
                  ],
                ),
                const GutterTiny(),
                const Text('or',
                    style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                const GutterSmall(),
                ElevatedButton.icon(
                    onPressed: () {
                      context.read<OnboardingBloc>().add(StartOnboarding(
                          User(userType: state.user!.userType!)));
                    },
                    icon: const Icon(FontAwesomeIcons.magicWandSparkles,
                        size: 16.0),
                    label: const Text('Send a Magic Link'),
                    style: ElevatedButton.styleFrom(elevation: 0.6)),
                const GutterTiny(),
                TextButton(
                    onPressed: () {},
                    child: const Text('Already have an account? Sign in.')),
                const GutterTiny(),
                const UserTypeInputChip(),
              ],
            ),
          ));
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}

class UserTypeInputChip extends StatelessWidget {
  const UserTypeInputChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.status == OnboardingStatus.failure) {
          return const Text('Error Onboarding!');
        } else if (state.status == OnboardingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == OnboardingStatus.loaded) {
          return PopupMenuButton(
            onSelected: (value) {
              context
                  .read<OnboardingBloc>()
                  .add(UpdateUser(User(userType: value)));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: UserType.freelancer,
                child: Text('Freelancer'),
              ),
              const PopupMenuItem(
                value: UserType.client,
                child: Text('Client'),
              ),
            ],
            child: Chip(
                avatar: const Icon(Icons.arrow_drop_down),
                label: Text(state.user!.userType!.name.toString().capitalize)),
          );
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
