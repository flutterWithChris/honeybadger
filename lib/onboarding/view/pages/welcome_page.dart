import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/onboarding/view/pages/desktop/desktop_welcome_page.dart';
import 'package:honeybadger/onboarding/view/pages/mobile/mobile_welcome_page.dart';
import 'package:honeybadger/onboarding/view/pages/tablet/tablet_welcome_page.dart';

import '../../../profile/model/user.dart';

class WelcomePage extends StatefulWidget {
  final PageController? pageController;
  const WelcomePage({this.pageController, super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final UserType _userType = UserType.freelancer;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return const DesktopWelcomePage();
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return const TabletWelcomePage();
      } else {
        return MobileWelcomePage(
          pageController: widget.pageController,
        );
      }
    });
  }
}
