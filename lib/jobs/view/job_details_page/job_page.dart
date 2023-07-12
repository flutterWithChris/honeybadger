import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/view/job_details_page/mobile/mobile_job_page.dart';
import 'package:honeybadger/jobs/view/job_details_page/tablet/tablet_job_page.dart';

import 'desktop/desktop_job_page.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;
  const JobDetailsPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return DesktopJobDetailsPage(job: job);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return TabletJobDetailsPage(job: job);
        } else {
          return MobileJobDetailsPage(job: job);
        }
      },
    );
  }
}
