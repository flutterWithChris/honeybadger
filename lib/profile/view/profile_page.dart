import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/view/tablet/tablet_profile_page.dart';

import 'desktop/desktop_profile_page.dart';
import 'mobile/mobile_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return const DesktopProfilePage();
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return const TabletProfilePage();
        } else {
          return const MobileProfilePage();
        }
      },
    );
  }
}
