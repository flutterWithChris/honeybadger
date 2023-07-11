import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/view/job_page/mobile/mobile_job_page.dart';
import 'package:honeybadger/jobs/view/job_page/tablet/tablet_job_page.dart';

import 'desktop/desktop_job_page.dart';

class JobPage extends StatelessWidget {
  final Job job;
  const JobPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return DesktopJobPage(job: job);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return TabletJobPage(job: job);
        } else {
          return MobileJobPage(job: job);
        }
      },
    );
  }
}
