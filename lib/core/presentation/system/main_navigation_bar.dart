import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({
    super.key,
  });

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  static int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          switch (index) {
            case 0:
              context.go('/search');
              break;
            case 1:
              context.go('/projects');
              break;
            case 2:
              context.go('/messages');
              break;
            case 3:
              context.go('/payments');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(MdiIcons.homeOutline),
            selectedIcon: Icon(MdiIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.folderOutline),
            selectedIcon: Icon(MdiIcons.folder),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Badge(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: const Text('2'),
              child: Icon(MdiIcons.chatOutline),
            ),
            selectedIcon: Icon(MdiIcons.chat),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Badge(
              label: const Text('1'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(MdiIcons.cash),
            ),
            selectedIcon: Icon(MdiIcons.cash),
            label: 'Payments',
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.accountOutline),
            selectedIcon: Icon(MdiIcons.account),
            label: 'Profile',
          ),
        ]);
  }
}
