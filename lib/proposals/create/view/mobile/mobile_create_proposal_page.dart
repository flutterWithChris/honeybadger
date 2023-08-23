import 'package:flutter/material.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';

import '../../../../projects/model/project.dart';

class MobileCreateProposalPage extends StatelessWidget {
  final Project project;
  const MobileCreateProposalPage({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
    );
  }
}
