import 'package:flutter/material.dart';
import 'package:honeybadger/proposals/create/view/desktop/desktop_create_proposal_page.dart';
import 'package:honeybadger/proposals/create/view/tablet/tablet_create_proposal_page.dart';

import '../../../projects/model/project.dart';
import '../../../core/constants.dart';
import 'mobile/mobile_create_proposal_page.dart';

class CreateProposalPage extends StatelessWidget {
  final Project project;
  const CreateProposalPage({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return DesktopCreateProposalPage(
          project: project,
        );
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return TabletCreateProposalPage(
          project: project,
        );
      } else {
        return MobileCreateProposalPage(
          project: project,
        );
      }
    });
  }
}
