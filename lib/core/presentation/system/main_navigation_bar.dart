import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:OutsourcedX/projects/bloc/projects_bloc.dart';
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
            // case 2:
            //   context.go('/messages');
            //   break;
            case 2:
              context.go('/payments');
              break;
            case 3:
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
          // TODO: Make badges work for freelancers
          NavigationDestination(
            icon: BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsLoaded &&
                    context.watch<ProfileBloc>().state.user!.userType ==
                        UserType.client) {
                  int unreadProposalCount = state.projects
                      .where((element) => element.unreadProposalCount! > 0)
                      .length;
                  if (unreadProposalCount > 0) {
                    return Badge(
                      label: Text(unreadProposalCount.toString()),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(MdiIcons.folderOutline),
                    );
                  }
                }
                return Icon(MdiIcons.folderOutline);
              },
            ),
            selectedIcon: Icon(MdiIcons.folder),
            //  BlocBuilder<ProjectsBloc, ProjectsState>(
            //   builder: (context, state) {
            //     if (state is ProjectsLoaded) {
            //       int unreadProposalCount = state.projects
            //           .where((element) => element.unreadProposalCount! > 0)
            //           .length;
            //       if (unreadProposalCount > 0) {
            //         return Badge(
            //           label: Text(unreadProposalCount.toString()),
            //           backgroundColor: Theme.of(context).colorScheme.tertiary,
            //           child: Icon(MdiIcons.folder),
            //         );
            //       }
            //     }
            //     return Icon(MdiIcons.folder);
            //   },
            // ),
            label: 'Projects',
          ),
          // NavigationDestination(
          //   icon: Icon(MdiIcons.chatOutline),
          //   selectedIcon: Icon(MdiIcons.chat),
          //   label: 'Messages',
          // ),
          NavigationDestination(
            icon: Icon(MdiIcons.cash),
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
