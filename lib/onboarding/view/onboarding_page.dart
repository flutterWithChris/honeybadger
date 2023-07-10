import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/onboarding/view/pages/payment_setup.dart';
import 'package:honeybadger/onboarding/view/pages/profile_setup.dart';
import 'package:honeybadger/onboarding/view/pages/signup_page.dart';
import 'package:honeybadger/onboarding/view/pages/skills_and_experience.dart';
import 'package:honeybadger/onboarding/view/pages/welcome_page.dart';
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutSine,
        opacity: _currentPage > 0 ? 1 : 0,
        child: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    await _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text('Back')),
              const Gutter(),
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
                    dotColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
              ),
              const Gutter(),
              TextButton(
                  onPressed: () async {
                    await _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text('Next'))
            ],
          ),
        ),
      ),
      body: PageView(
        allowImplicitScrolling: true,
        controller: _pageController,
        children: [
          WelcomePage(
            pageController: _pageController,
          ),
          SignupPage(
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
    );
  }
}
