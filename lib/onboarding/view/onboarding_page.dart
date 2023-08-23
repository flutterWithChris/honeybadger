import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
import 'package:OutsourcedX/onboarding/view/pages/client_industry/client_industry_page.dart';
import 'package:OutsourcedX/onboarding/view/pages/payment_setup.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/profile_setup.dart';
import 'package:OutsourcedX/onboarding/view/pages/skills_and_experience.dart';
import 'package:OutsourcedX/onboarding/view/pages/welcome/welcome_page.dart';
import 'package:OutsourcedX/onboarding/view/signup_page.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    UserType? userType = context.watch<OnboardingBloc>().userType;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: _currentPage == 0
          ? OnboardingPageButtons(
              userType: userType,
              currentPage: _currentPage,
              pageController: _pageController)
          : null,
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
                      physics: const NeverScrollableScrollPhysics(),
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
                      //  physics: const NeverScrollableScrollPhysics(),
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

class OnboardingPageButtons extends StatelessWidget {
  const OnboardingPageButtons({
    super.key,
    required this.userType,
    required int currentPage,
    required PageController pageController,
  })  : _currentPage = currentPage,
        _pageController = pageController;

  final UserType? userType;
  final int _currentPage;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutSine,
      opacity: userType != null && _currentPage == 0 ? 1 : 0,
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
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.618,
                  child: OutlinedButton(
                      onPressed: () async {
                        await _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: const Text('Back')),
                ),
              ),
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
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.618,
                  child: FilledButton(
                      onPressed: () async {
                        if (_currentPage == 4) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('onboarded', true).then((value) {
                            context.go('/search');
                            return value;
                          });
                          return;
                        } else {
                          await _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(_currentPage < 4 ? 'Next' : 'Finish')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
