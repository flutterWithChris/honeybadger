import 'package:flutter/material.dart';
import 'package:honeybadger/onboarding/view/pages/signup_page.dart';
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
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          SignupPage(),
        ],
      ),
    );
  }
}
