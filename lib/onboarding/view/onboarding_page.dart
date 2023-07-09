import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/onboarding/view/pages/payment_setup.dart';
import 'package:honeybadger/onboarding/view/pages/profile_setup.dart';
import 'package:honeybadger/onboarding/view/pages/signup_page.dart';
import 'package:honeybadger/onboarding/view/pages/skills_and_experience.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
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
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Colors.deepPurple,
                dotColor: Colors.grey,
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
              child: const Text('Skip'))
        ],
      ),
      body: PageView(
        allowImplicitScrolling: true,
        controller: _pageController,
        children: [
          const SignupPage(),
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
