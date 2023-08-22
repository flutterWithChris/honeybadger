import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:OutsourcedX/auth/cubit/signup/signup_cubit.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  final UserType userType;
  final PageController pageController;
  const SignupPage(
      {required this.userType, required this.pageController, super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                print(
                    'Creating profile with type: ${onboardingState.userType}');
                context.read<OnboardingBloc>().add(StartOnboarding(User(
                      id: state.user!.uid,
                      userType: context.read<OnboardingBloc>().userType,
                      email: state.user!.email,
                      firstName: state.user!.displayName != null
                          ? state.user!.displayName?.split(' ')[0]
                          : null,
                      lastName: state.user!.displayName != null
                          ? state.user!.displayName?.split(' ')[1]
                          : null,
                      photoUrl: state.user!.photoURL,
                      createdAt: DateTime.now(),
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

                await widget.pageController.nextPage(
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
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        filledButtonTheme: FilledButtonThemeData(
                            style: Theme.of(context)
                                .filledButtonTheme
                                .style
                                ?.copyWith(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size.fromWidth(260)),
                                ))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Your Account.',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const Gutter(),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    context
                                        .read<SignupCubit>()
                                        .emailChanged(value);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!EmailValidator.validate(
                                        value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const Gutter(),
                                TextFormField(
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off_outlined,
                                        )),
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    context
                                        .read<SignupCubit>()
                                        .passwordChanged(value);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const Gutter(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<SignupCubit>()
                                                .signupWithEmailAndPassword();
                                          }
                                        },
                                        child: const Text('Sign Up'),
                                      ),
                                    ),
                                  ],
                                ),
                                // const Gutter(),
                              ],
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     Platform.isIOS
                          //         ? Row(
                          //             children: [
                          //               Expanded(
                          //                 child: FilledButton.tonalIcon(
                          //                   style: ElevatedButton.styleFrom(
                          //                     foregroundColor: Colors.white,
                          //                     backgroundColor: Colors.black87,
                          //                   ),
                          //                   onPressed: () {
                          //                     context
                          //                         .read<SignupCubit>()
                          //                         .signupWithApple();
                          //                   },
                          //                   label: const Text(
                          //                       'Sign In with Apple'),
                          //                   icon: const Icon(
                          //                       FontAwesomeIcons.apple,
                          //                       size: 20.0),
                          //                 ),
                          //               ),
                          //             ],
                          //           )
                          //         : Row(
                          //             children: [
                          //               Expanded(
                          //                 child: FilledButton.icon(
                          //                   onPressed: () {
                          //                     context
                          //                         .read<SignupCubit>()
                          //                         .signupWithGoogle();
                          //                   },
                          //                   label: const Text(
                          //                       'Sign In with Google'),
                          //                   icon: const Icon(
                          //                       FontAwesomeIcons.google,
                          //                       size: 20.0),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //     if (Platform.isIOS == false) const GutterSmall(),
                          //     if (Platform.isIOS == false)
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: FilledButton.tonalIcon(
                          //               style: FilledButton.styleFrom(
                          //                   backgroundColor: FlexColor
                          //                       .flutterDash
                          //                       .dark
                          //                       .secondaryContainer),
                          //               onPressed: () {
                          //                 context
                          //                     .read<SignupCubit>()
                          //                     .signupWithGithub();
                          //               },
                          //               label: const Text(
                          //                 'Sign In with Github',
                          //                 style: TextStyle(color: Colors.white),
                          //               ),
                          //               icon: const Icon(
                          //                   FontAwesomeIcons.github,
                          //                   color: Colors.white,
                          //                   size: 20.0),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //   ],
                          // ),
                          // const GutterSmall(),
                          // ElevatedButton.icon(
                          //     onPressed: () {
                          //       context.read<OnboardingBloc>().add(StartOnboarding(
                          //           User(
                          //               userType:
                          //                   onboardingState.user!.userType!)));
                          //     },
                          //     icon: const Icon(FontAwesomeIcons.magicWandSparkles,
                          //         size: 16.0),
                          //     label: const Text('Send a Magic Link'),
                          //     style: ElevatedButton.styleFrom(elevation: 0.6)),
                          // const GutterTiny(),
                          TextButton(
                              onPressed: () async {
                                context.go('/login');
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('onboarded', true);
                                prefs.setBool('paymentSetupComplete', true);
                              },
                              child: const Text(
                                  'Already have an account? Sign in.')),
                          //   const GutterSmall(),

                          const UserTypeInputChip()
                        ],
                      ),
                    ),
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

class UserTypeInputChip extends StatefulWidget {
  const UserTypeInputChip({super.key});

  @override
  State<UserTypeInputChip> createState() => _UserTypeInputChipState();
}

class _UserTypeInputChipState extends State<UserTypeInputChip> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.status == OnboardingStatus.failure) {
          return const Text('Error Onboarding!');
        } else if (state.status == OnboardingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == OnboardingStatus.loaded ||
            state.status == OnboardingStatus.initial) {
          User? user = context.read<OnboardingBloc>().state.user;
          return PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (value) {
              User? user = context.read<OnboardingBloc>().state.user;
              if (user != null) {
                context
                    .read<OnboardingBloc>()
                    .add(UpdateUser(user.copyWith(userType: value)));
              }

              print('Setting user type to $value');
              context.read<OnboardingBloc>().add(SetUserType(value));
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
                label: Text(user?.userType != null
                    ? parseEnumName(user!.userType!.toString())
                    : parseEnumName(context
                        .read<OnboardingBloc>()
                        .userType
                        .toString()
                        .capitalize))),
          );
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
