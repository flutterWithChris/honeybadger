import 'package:flutter/material.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/proposals/create/view/desktop/desktop_create_proposal_page.dart';
import 'package:honeybadger/proposals/create/view/tablet/tablet_create_proposal_page.dart';

import '../../../core/constants.dart';
import 'mobile/mobile_create_proposal_page.dart';

class CreateProposalPage extends StatelessWidget {
  final Job job;
  const CreateProposalPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return DesktopCreateProposalPage(
          job: job,
        );
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return TabletCreateProposalPage(
          job: job,
        );
      } else {
        return MobileCreateProposalPage(
          job: job,
        );
      }
    });
  }
}
