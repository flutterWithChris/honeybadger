import 'package:flutter/material.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/jobs/model/job.dart';

class MobileCreateProposalPage extends StatelessWidget {
  final Job job;
  const MobileCreateProposalPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
    );
  }
}
