import 'dart:io';

import 'package:OutsourcedX/globals.dart';
import 'package:OutsourcedX/login/view/cubit/login_cubit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool emailSignup = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
              const GutterSmall(),
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
                                  label: const Text('Sign In with Apple'),
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
                                  label: const Text('Sign In with Google'),
                                  icon: const Icon(FontAwesomeIcons.google,
                                      size: 20.0),
                                ),
                              ),
                            ],
                          ),
                    if (Platform.isIOS == false) const GutterSmall(),
                    if (Platform.isIOS == false)
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
                                'Sign In with Github',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(FontAwesomeIcons.github,
                                  color: Colors.white, size: 20.0),
                            ),
                          ),
                        ],
                      ),
                    const GutterTiny(),
                    // Email and Password Login
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: emailSignup == false
                            ? Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          emailSignup = true;
                                        });
                                      },
                                      label: const Text('Sign In with Email'),
                                      icon: const Icon(Icons.email_rounded),
                                    ),
                                  ),
                                ],
                              )
                            : Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    const GutterSmall(),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'Enter your email',
                                        border: OutlineInputBorder(),
                                      ),
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
                                      controller: _passwordController,
                                      obscureText: _obscureText,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                                  : Icons
                                                      .visibility_off_outlined,
                                            )),
                                        labelText: 'Password',
                                        hintText: 'Enter your password',
                                        border: const OutlineInputBorder(),
                                      ),
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
                                          child: FilledButton.icon(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<LoginCubit>()
                                                    .loginWithEmailAndPassword(
                                                        _emailController
                                                            .value.text,
                                                        _passwordController
                                                            .value.text);
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.email_rounded),
                                            label: const Text(
                                                'Sign In With Email'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // const Gutter(),
                                  ],
                                ),
                              )),
                    TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('onboarded', false);
                          await prefs.setBool('paymentSetupComplete', false);
                          context.go('/onboarding');
                        },
                        child: const Text('New? Sign up.')),
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
