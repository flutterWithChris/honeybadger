import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
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
  @override
  Widget build(BuildContext context) {
    UserType? userType = context.watch<OnboardingBloc>().userType;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/logos/OutsourcedX_FullText_White.png'
                      : 'assets/logos/OutsourcedX_FullText_Black.png',
                ),
              ),
              const Gutter(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Text('A platform built for the future of work.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              // const GutterSmall(),
              // Row(
              //   children: [
              //     Expanded(
              //       child: FilledButton(
              //           style: FilledButton.styleFrom(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 64.0, vertical: 8.0),
              //           ),
              //           onPressed: () async {
              //             print('Get Started Clicked');
              //             context.read<OnboardingBloc>().userType = userType;
              //             await widget.pageController?.nextPage(
              //                 duration: const Duration(milliseconds: 500),
              //                 curve: Curves.ease);
              //           },
              //           child: const Text(
              //             'Get Started',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              const Gutter(),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: userType == UserType.freelancer
                            ? BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  width: 2.0,
                                  color: Theme.of(context).primaryColor,
                                ))
                            : null,
                        child: ListTile(
                          onTap: () {
                            print('Freelancer Card Tapped');

                            setState(() {
                              context
                                  .read<OnboardingBloc>()
                                  .add(SetUserType(UserType.freelancer));
                            });
                          },
                          leading: Icon(MdiIcons.accountTie),
                          title: const Text('I\'m a Freelancer.'),
                          subtitle: const Text(
                              'Find the right projects for your skills.'),
                        ),
                      ),
                    ),
                    const GutterTiny(),
                    Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: userType == UserType.client
                            ? BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  width: 2.0,
                                  color: Theme.of(context).primaryColor,
                                ))
                            : null,
                        child: ListTile(
                          onTap: () {
                            print('Client Card Tapped');

                            setState(() {
                              context
                                  .read<OnboardingBloc>()
                                  .add(SetUserType(UserType.client));
                            });
                            print(
                                'User type is ${context.read<OnboardingBloc>().state.userType}');
                          },
                          leading: Icon(MdiIcons.accountGroup),
                          title: const Text('I\'m a Client.'),
                          subtitle: const Text(
                              'Connect with talent to get projects built.'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Flexible(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Flexible(
              //         child: FittedBox(
              //           child: PopupMenuButton(
              //               position: PopupMenuPosition.under,
              //               onSelected: (value) {
              //                 setState(() {
              //                   context.read<OnboardingBloc>().userType =
              //                       value == 'Freelancer'
              //                           ? UserType.freelancer
              //                           : UserType.client;
              //                 });
              //               },
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8.0)),
              //               //color: Colors.white,
              //               elevation: 2.0,
              //               constraints: const BoxConstraints(maxWidth: 400.0),
              //               itemBuilder: (context) => [
              //                     userType == UserType.client
              //                         ? PopupMenuItem(
              //                             value: 'Freelancer',
              //                             child: Text('Freelancer',
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .titleSmall),
              //                           )
              //                         : PopupMenuItem(
              //                             value: 'Client',
              //                             child: Text('Client',
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .titleSmall),
              //                           )
              //                   ],
              //               child: const SizedBox(
              //                 height: 48,
              //                 child: FittedBox(child: UserTypeInputChip()),
              //               )),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
