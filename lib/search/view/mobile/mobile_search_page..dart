import 'package:flutter/material.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/model/job_category.dart';
import 'package:honeybadger/search/view/widgets/job_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileSearchPage extends StatefulWidget {
  const MobileSearchPage({super.key});

  @override
  State<MobileSearchPage> createState() => _MobileSearchPageState();
}

class _MobileSearchPageState extends State<MobileSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(destinations: [
        NavigationDestination(
          icon: Icon(MdiIcons.homeOutline),
          selectedIcon: Icon(MdiIcons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(MdiIcons.briefcaseOutline),
          selectedIcon: Icon(MdiIcons.briefcase),
          label: 'Jobs',
        ),
        NavigationDestination(
          icon: Icon(MdiIcons.chatOutline),
          selectedIcon: Icon(MdiIcons.chat),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(MdiIcons.accountOutline),
          selectedIcon: Icon(MdiIcons.account),
          label: 'Profile',
        ),
      ]),
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
                      title: 'Create an app for a Vet.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term. Creating an app for a local veterinarian who\'d like away for patients to check in and pay through their phone.',
                      budget: 1000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile Development',
                      ),
                      paymentType: PaymentType.hourly,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
                      weekEstimate: 10,
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
