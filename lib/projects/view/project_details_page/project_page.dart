import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/projects/view/project_details_page/mobile/mobile_client_project_page.dart';
import 'package:OutsourcedX/projects/view/project_details_page/tablet/tablet_project_page.dart';

import 'desktop/desktop_job_page.dart';
import 'mobile/mobile_job_page.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;
  const ProjectDetailsPage({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return DesktopProjectDetailsPage(project: project);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return TabletProjectDetailsPage(project: project);
        } else {
          if (context.watch<ProfileBloc>().state.user!.userType ==
              UserType.freelancer) {
            return MobileProjectDetailsPage(project: project);
          } else {
            return MobileClientProjectDetailsPage(project: project);
          }
        }
      },
    );
  }
}
