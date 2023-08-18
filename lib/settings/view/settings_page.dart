import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/settings/view/tablet/tablet_settings_page.dart';
import 'package:flutter/material.dart';

import 'desktop/desktop_settings_page.dart';
import 'mobile/mobile_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return const DesktopSettingsPage();
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return const TabletSettingsPage();
        } else {
          return const MobileSettingsPage();
        }
      },
    );
  }
}
