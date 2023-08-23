import 'package:flutter/material.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/onboarding/view/pages/welcome/desktop/desktop_welcome_page.dart';
import 'package:outsourcedx/onboarding/view/pages/welcome/mobile/mobile_welcome_page.dart';
import 'package:outsourcedx/onboarding/view/pages/welcome/tablet/tablet_welcome_page.dart';

class WelcomePage extends StatefulWidget {
  final PageController? pageController;
  const WelcomePage({this.pageController, super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return DesktopWelcomePage(pageController: widget.pageController);
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return TabletWelcomePage(pageController: widget.pageController);
      } else {
        return MobileWelcomePage(
          pageController: widget.pageController,
        );
      }
    });
  }
}
