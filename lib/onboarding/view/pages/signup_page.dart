import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:honeybadger/auth/cubit/signup/signup_cubit.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';

class SignupPage extends StatelessWidget {
  final UserType userType;
  final PageController pageController;
  const SignupPage(
      {required this.userType, required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, onboardingState) {
        if (onboardingState.status == OnboardingStatus.failure) {
          return const Text('Error Onboarding!');
        } else if (onboardingState.status == OnboardingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (onboardingState.status == OnboardingStatus.loaded ||
            onboardingState.status == OnboardingStatus.initial) {
          return Scaffold(
              body: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) async {
              if (state.status == SignupStatus.success) {
                context.read<OnboardingBloc>().add(StartOnboarding(User(
                      id: state.user!.uid,
                      userType: context.read<OnboardingBloc>().userType,
                      email: state.user!.email,
                      firstName: state.user!.displayName?.split(' ')[0],
                      lastName: state.user!.displayName?.split(' ')[1],
                      photoUrl: state.user!.photoURL,
                    )));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    content: Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.white),
                        GutterSmall(),
                        Text(
                          'Sign Up Successful!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                await pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn);
              }
            },
            builder: (context, state) {
              if (state.status == SignupStatus.submitting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == SignupStatus.initial ||
                  state.status == SignupStatus.error) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Your Account.',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Gutter(),
                      Theme(
                        data: Theme.of(context).copyWith(
                            filledButtonTheme: FilledButtonThemeData(
                                style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(48.0, 40.0)),
                        ))),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 12.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            FilledButton.tonal(
                              onPressed: () {
                                context.read<SignupCubit>().signupWithGoogle();
                              },
                              child: const Icon(FontAwesomeIcons.google,
                                  size: 20.0),
                            ),
                            FilledButton.tonal(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black87,
                              ),
                              onPressed: () {
                                context.read<SignupCubit>().signupWithApple();
                              },
                              child: const Icon(FontAwesomeIcons.apple,
                                  size: 20.0),
                            ),
                            FilledButton(
                              onPressed: () {
                                context.read<SignupCubit>().signupWithGithub();
                              },
                              child: const Icon(FontAwesomeIcons.github,
                                  size: 20.0),
                            ),
                          ],
                        ),
                      ),
                      const GutterTiny(),
                      const Text('or',
                          style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                      const GutterSmall(),
                      ElevatedButton.icon(
                          onPressed: () {
                            context.read<OnboardingBloc>().add(StartOnboarding(
                                User(
                                    userType:
                                        onboardingState.user!.userType!)));
                          },
                          icon: const Icon(FontAwesomeIcons.magicWandSparkles,
                              size: 16.0),
                          label: const Text('Send a Magic Link'),
                          style: ElevatedButton.styleFrom(elevation: 0.6)),
                      const GutterTiny(),
                      TextButton(
                          onPressed: () {},
                          child:
                              const Text('Already have an account? Sign in.')),
                      const GutterTiny(),
                      const UserTypeInputChip(),
                    ],
                  ),
                );
              }
              if (state.status == SignupStatus.success) {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.green, size: 80.0),
                          const GutterSmall(),
                          Text(
                            'Signed In!',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('Something went wrong!'));
              }
            },
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
