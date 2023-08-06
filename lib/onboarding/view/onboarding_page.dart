import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/onboarding/view/pages/client_industry/client_industry_page.dart';
import 'package:honeybadger/onboarding/view/pages/payment_setup.dart';
import 'package:honeybadger/onboarding/view/pages/profile_setup/profile_setup.dart';
import 'package:honeybadger/onboarding/view/pages/skills_and_experience.dart';
import 'package:honeybadger/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:honeybadger/onboarding/view/signup_page.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  final UserType userType;
  const OnboardingPage({required this.userType, super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static final PageController _pageController = PageController();
  static int _currentPage = 0;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        print('Setting current page to $_currentPage');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      bottomNavigationBar: IgnorePointer(
        ignoring: _currentPage == 0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutSine,
          opacity: _currentPage > 0 ? 1 : 0,
          child: Theme(
            data: Theme.of(context).copyWith(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flexible(
                  //   child: TextButton(
                  //       onPressed: () async {
                  //         await _pageController.previousPage(
                  //           duration: const Duration(milliseconds: 500),
                  //           curve: Curves.ease,
                  //         );
                  //       },
                  //       child: const Text('Back')),
                  // ),
                  // const Gutter(),
                  SizedBox(
                    height: 80,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 5,
                      effect: WormEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: Theme.of(context).indicatorColor,
                        dotColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  // const Gutter(),
                  // Flexible(
                  //   child: TextButton(
                  //       onPressed: () async {
                  //         if (_currentPage == 4) {
                  //           SharedPreferences prefs =
                  //               await SharedPreferences.getInstance();
                  //           prefs.setBool('onboarded', true).then((value) {
                  //             context.go('/search');
                  //             return value;
                  //           });
                  //           return;
                  //         } else {
                  //           await _pageController.nextPage(
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.ease,
                  //           );
                  //         }
                  //       },
                  //       child: Text(_currentPage < 4 ? 'Next' : 'Finish')),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<OnboardingBloc, OnboardingState>(
              listenWhen: (previous, current) {
                print('Previous: ${previous.user?.userType}');
                print('Current: ${current.user?.userType}');
                return previous.user != null &&
                    previous.user!.userType.toString().trim() ==
                        current.user?.userType.toString().trim();
              },
              listener: (context, state) {
                print('Jumping to page $_currentPage');
                _pageController.jumpToPage(_currentPage);
              },
              builder: (context, state) {
                if (state.status == OnboardingStatus.failure) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error Loading Onboarding!'),
                      ],
                    ),
                  );
                }
                if (state.status == OnboardingStatus.initial ||
                    state.status == OnboardingStatus.loaded ||
                    state.status == OnboardingStatus.loading) {
                  if (state.user != null &&
                      state.user!.userType == UserType.client) {
                    return PageView(
                      allowImplicitScrolling: true,
                      controller: _pageController,
                      children: [
                        WelcomePage(
                          pageController: _pageController,
                        ),
                        // kIsWeb
                        //     ? WebSignupPage(
                        //         pageController: _pageController,
                        //         userType: widget.userType,
                        //       )
                        //    :
                        SignupPage(
                          pageController: _pageController,
                          userType: widget.userType,
                        ),
                        ProfileSetup(
                          pageController: _pageController,
                        ),
                        ClientIndustryPage(
                          pageController: _pageController,
                        ),
                      ],
                    );
                  } else {
                    return PageView(
                      allowImplicitScrolling: true,
                      controller: _pageController,
                      children: [
                        WelcomePage(
                          pageController: _pageController,
                        ),
                        // kIsWeb
                        //     ? WebSignupPage(
                        //         pageController: _pageController,
                        //         userType: widget.userType,
                        //       )
                        //    :
                        SignupPage(
                          pageController: _pageController,
                          userType: widget.userType,
                        ),
                        ProfileSetup(
                          pageController: _pageController,
                        ),
                        SkillsAndExperiencePage(
                          pageController: _pageController,
                        ),
                        PaymentSetupPage(pageController: _pageController),
                      ],
                    );
                  }
                }
                return const Center(
                  child: Text('Something went wrong!'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
