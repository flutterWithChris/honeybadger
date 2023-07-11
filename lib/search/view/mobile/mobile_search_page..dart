import 'package:flutter/material.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/model/job_category.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/search/view/widgets/job_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/presentation/system/main_navigation_bar.dart';

class MobileSearchPage extends StatefulWidget {
  const MobileSearchPage({super.key});

  @override
  State<MobileSearchPage> createState() => _MobileSearchPageState();
}

class _MobileSearchPageState extends State<MobileSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                elevation: const MaterialStatePropertyAll(0.618),
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                trailing: [Icon(MdiIcons.briefcaseSearch)],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: JobCard(
                    job: Job(
                      client: User(
                          id: '1',
                          firstName: 'John',
                          lastName: 'Doe',
                          city: 'San Francisco',
                          state: 'CA',
                          photoUrl: '',
                          email: '',
                          ratingCount: 4,
                          rating: 4.5),
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
