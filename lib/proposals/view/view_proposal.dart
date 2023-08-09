import 'package:flutter/material.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:honeybadger/proposals/view/view_proposal/desktop/desktop_view_proposal.dart';
import 'package:honeybadger/proposals/view/view_proposal/mobile/mobile_view_proposal.dart';
import 'package:honeybadger/proposals/view/view_proposal/tablet/tablet_view_proposal.dart';

import '../../core/constants.dart';

class ViewProposalPage extends StatelessWidget {
  final Proposal proposal;
  const ViewProposalPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return const DesktopViewProposalPage();
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return const TabletViewProposalPage();
        } else {
          return MobileViewProposalPage(
            proposal: proposal,
          );
        }
      },
    );
  }
}
