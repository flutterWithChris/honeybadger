import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:OutsourcedX/profile/view/mobile/mobile_client_profile_page.dart';
import 'package:OutsourcedX/profile/view/tablet/tablet_profile_page.dart';

import 'desktop/desktop_profile_page.dart';
import 'mobile/mobile_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<ProfileBloc>().state.user;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return const DesktopProfilePage();
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return const TabletProfilePage();
        } else {
          if (user?.userType == UserType.freelancer) {
            return const MobileProfilePage();
          } else {
            return const MobileClientProfilePage(); // TODO: Client Profile Page
          }
        }
      },
    );
  }
}
