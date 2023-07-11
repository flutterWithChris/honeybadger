import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(destinations: [
      NavigationDestination(
        icon: Icon(MdiIcons.homeOutline),
        selectedIcon: Icon(MdiIcons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(MdiIcons.briefcaseOutline),
        selectedIcon: Icon(MdiIcons.briefcase),
        label: 'Jobs',
      ),
      NavigationDestination(
        icon: Icon(MdiIcons.chatOutline),
        selectedIcon: Icon(MdiIcons.chat),
        label: 'Messages',
      ),
      NavigationDestination(
        icon: Icon(MdiIcons.accountOutline),
        selectedIcon: Icon(MdiIcons.account),
        label: 'Profile',
      ),
    ]);
  }
}
