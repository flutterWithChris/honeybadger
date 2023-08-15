// import 'dart:io';

// import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gutter/flutter_gutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:OutsourcedX/auth/cubit/signup/signup_cubit.dart';
// import 'package:OutsourcedX/core/constants.dart';
// import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
// import 'package:OutsourcedX/profile/model/user.dart';
// import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
// import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

// class WebSignupPage extends StatefulWidget {
//   final UserType userType;
//   final PageController pageController;
//   const WebSignupPage(
//       {required this.userType, required this.pageController, super.key});

//   @override
//   State<WebSignupPage> createState() => _WebSignupPageState();
// }

// class _WebSignupPageState extends State<WebSignupPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     if (kIsWeb) {
//       initGoogleSignInWeb();
//     }
//     super.initState();
//   }

//   Future<void> initGoogleSignInWeb() async {
//     // Initialize the plugin
//     web.GoogleSignInPlugin googleSignIn = web.GoogleSignInPlugin();

//     GoogleSignInPlatform googleSignInPlatform = GoogleSignInPlatform.instance;

//     googleSignInPlatform.initWithParams(const SignInInitParameters(
//       clientId: String.fromEnvironment('GCP_OAUTH_CLIENT_ID'),
//     ));

// // Make sure to initialize the plugin before using it
//     await googleSignIn.initWithParams(const SignInInitParameters(
//       scopes: [],
//       clientId: String.fromEnvironment('GCP_OAUTH_CLIENT_ID'),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OnboardingBloc, OnboardingState>(
//       builder: (context, onboardingState) {
//         if (onboardingState.status == OnboardingStatus.failure) {
//           return const Text('Error Onboarding!');
//         } else if (onboardingState.status == OnboardingStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (onboardingState.status == OnboardingStatus.loaded ||
//             onboardingState.status == OnboardingStatus.initial) {
//           return Scaffold(
//               body: BlocConsumer<SignupCubit, SignupState>(
//             listener: (context, state) async {
//               if (state.status == SignupStatus.success) {
//                 context.read<OnboardingBloc>().add(StartOnboarding(User(
//                       id: state.user!.uid,
//                       userType: context.read<OnboardingBloc>().userType,
//                       email: state.user!.email,
//                       firstName: state.user!.displayName?.split(' ')[0],
//                       lastName: state.user!.displayName?.split(' ')[1],
//                       photoUrl: state.user!.photoURL,
//                     )));

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     behavior: SnackBarBehavior.floating,
//                     backgroundColor: Colors.green,
//                     content: Row(
//                       children: [
//                         Icon(Icons.check_circle_rounded, color: Colors.white),
//                         GutterSmall(),
//                         Text(
//                           'Sign Up Successful!',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     duration: Duration(seconds: 2),
//                   ),
//                 );

//                 await widget.pageController.nextPage(
//                     duration: const Duration(milliseconds: 400),
//                     curve: Curves.easeIn);
//               }
//             },
//             builder: (context, state) {
//               if (state.status == SignupStatus.submitting) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (state.status == SignupStatus.initial ||
//                   state.status == SignupStatus.error) {
//                 return Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Create Your Account.',
//                         style: Theme.of(context).textTheme.headlineLarge,
//                       ),
//                       const Gutter(),
//                       Column(
//                         children: [
//                           kIsWeb
//                               ? (GoogleSignInPlatform.instance
//                                       as web.GoogleSignInPlugin)
//                                   .renderButton(
//                                       configuration: web.GSIButtonConfiguration(
//                                   // type: web.GSIButtonType.icon,
//                                   // size: web.GSIButtonSize.large,
//                                   shape: web.GSIButtonShape.pill,
//                                 ))
//                               : Platform.isIOS
//                                   ? FilledButton.tonal(
//                                       style: ElevatedButton.styleFrom(
//                                         foregroundColor: Colors.white,
//                                         backgroundColor: Colors.black87,
//                                       ),
//                                       onPressed: () {
//                                         context
//                                             .read<SignupCubit>()
//                                             .signupWithApple();
//                                       },
//                                       child: const Icon(FontAwesomeIcons.apple,
//                                           size: 20.0),
//                                     )
//                                   : FilledButton.tonal(
//                                       onPressed: () {
//                                         context
//                                             .read<SignupCubit>()
//                                             .signupWithGoogle();
//                                       },
//                                       child: const Icon(FontAwesomeIcons.google,
//                                           size: 20.0),
//                                     ),
//                           const Gutter(),
//                           Theme(
//                             data: Theme.of(context).copyWith(
//                                 filledButtonTheme: FilledButtonThemeData(
//                                     style: ButtonStyle(
//                               minimumSize: MaterialStateProperty.all(
//                                   const Size(84.0, 40.0)),
//                             ))),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 kIsWeb || Platform.isAndroid
//                                     ? FilledButton.tonal(
//                                         style: ElevatedButton.styleFrom(
//                                           foregroundColor: Colors.white,
//                                           backgroundColor: Colors.black87,
//                                         ),
//                                         onPressed: () {
//                                           context
//                                               .read<SignupCubit>()
//                                               .signupWithApple();
//                                         },
//                                         child: const Icon(
//                                             FontAwesomeIcons.apple,
//                                             size: 20.0),
//                                       )
//                                     : FilledButton.tonal(
//                                         onPressed: () {
//                                           context
//                                               .read<SignupCubit>()
//                                               .signupWithGoogle();
//                                         },
//                                         child: const Icon(
//                                             FontAwesomeIcons.google,
//                                             size: 20.0),
//                                       ),
//                                 const GutterSmall(),
//                                 FilledButton.tonal(
//                                   style: FilledButton.styleFrom(
//                                       backgroundColor: FlexColor
//                                           .flutterDash.dark.secondaryContainer),
//                                   onPressed: () {
//                                     context
//                                         .read<SignupCubit>()
//                                         .signupWithGithub();
//                                   },
//                                   child: const Icon(FontAwesomeIcons.github,
//                                       color: Colors.white, size: 20.0),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       const GutterSmall(),
//                       // ElevatedButton.icon(
//                       //     onPressed: () {
//                       //       context.read<OnboardingBloc>().add(StartOnboarding(
//                       //           User(
//                       //               userType:
//                       //                   onboardingState.user!.userType!)));
//                       //     },
//                       //     icon: const Icon(FontAwesomeIcons.magicWandSparkles,
//                       //         size: 16.0),
//                       //     label: const Text('Send a Magic Link'),
//                       //     style: ElevatedButton.styleFrom(elevation: 0.6)),
//                       // const GutterTiny(),
//                       TextButton(
//                           onPressed: () {},
//                           child:
//                               const Text('Already have an account? Sign in.')),
//                       const GutterSmall(),
//                       const UserTypeInputChip(),
//                     ],
//                   ),
//                 );
//               }
//               if (state.status == SignupStatus.success) {
//                 return Center(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(48.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.check_circle_outline_rounded,
//                               color: Colors.green, size: 80.0),
//                           const GutterSmall(),
//                           Text(
//                             'Signed In!',
//                             style: Theme.of(context).textTheme.headlineLarge,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return const Center(child: Text('Something went wrong!'));
//               }
//             },
//           ));
//         } else {
//           return const Center(child: Text('Something went wrong!'));
//         }
//       },
//     );
//   }
// }

// class UserTypeInputChip extends StatefulWidget {
//   const UserTypeInputChip({super.key});

//   @override
//   State<UserTypeInputChip> createState() => _UserTypeInputChipState();
// }

// class _UserTypeInputChipState extends State<UserTypeInputChip> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OnboardingBloc, OnboardingState>(
//       builder: (context, state) {
//         if (state.status == OnboardingStatus.failure) {
//           return const Text('Error Onboarding!');
//         } else if (state.status == OnboardingStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state.status == OnboardingStatus.loaded ||
//             state.status == OnboardingStatus.initial) {
//           return PopupMenuButton(
//             onSelected: (value) {
//               setState(() {
//                 context.read<OnboardingBloc>().userType = value;
//               });
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: UserType.freelancer,
//                 child: Text('Freelancer'),
//               ),
//               const PopupMenuItem(
//                 value: UserType.client,
//                 child: Text('Client'),
//               ),
//             ],
//             child: Chip(
//                 avatar: const Icon(Icons.arrow_drop_down),
//                 label: Text(parseEnumName(context
//                     .watch<OnboardingBloc>()
//                     .userType
//                     .toString()
//                     .capitalize))),
//           );
//         } else {
//           return const Center(child: Text('Something went wrong!'));
//         }
//       },
//     );
//   }
// }
