import 'dart:io';

import 'package:OutsourcedX/globals.dart';
import 'package:OutsourcedX/login/view/cubit/login_cubit.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go('/search');
        }
      },
      builder: (context, state) {
        print('Login Status: ${state.status}');
        if (state.status == LoginStatus.submitting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LoginStatus.error) {
          return const Center(child: Text('Error'));
        }

        if (state.status == LoginStatus.success) {
          return const Center(child: Text('Success!'));
        }
        if (state.status == LoginStatus.initial) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 60, child: FittedBox(child: OutsourcedFullText())),
              const Gutter(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Platform.isIOS
                        ? Row(
                            children: [
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black87,
                                  ),
                                  onPressed: () {
                                    context.read<LoginCubit>().loginWithApple();
                                  },
                                  label: const Text('Continue with Apple'),
                                  icon: const Icon(FontAwesomeIcons.apple,
                                      size: 20.0),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () {
                                    context
                                        .read<LoginCubit>()
                                        .loginWithGoogle();
                                  },
                                  label: const Text('Continue with Google'),
                                  icon: const Icon(FontAwesomeIcons.google,
                                      size: 20.0),
                                ),
                              ),
                            ],
                          ),
                    const GutterSmall(),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                                backgroundColor: FlexColor
                                    .flutterDash.dark.secondaryContainer),
                            onPressed: () {
                              context.read<LoginCubit>().loginWithGithub();
                            },
                            label: const Text(
                              'Continue with Github',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(FontAwesomeIcons.github,
                                color: Colors.white, size: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Something Went Wrong...'));
        }
      },
    ));
  }
}
