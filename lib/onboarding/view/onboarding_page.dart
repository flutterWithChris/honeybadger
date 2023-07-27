import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
        print('Current Page: $_currentPage');
      });
    });
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
              //  color: Theme.of(context).appBarTheme.backgroundColor,
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
                        activeDotColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        dotColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
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
            child: PageView(
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
            ),
          ),
        ],
      ),
    );
  }
}
