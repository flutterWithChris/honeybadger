import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/view/job_details_page/tablet/tablet_project_page.dart';

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
          return MobileProjectDetailsPage(project: project);
        }
      },
    );
  }
}
