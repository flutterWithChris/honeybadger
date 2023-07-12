import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';

import '../../../core/presentation/system/mobile_jobs_app_bar.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: DefaultTabController(
        length: 4,
        child: CustomScrollView(
          slivers: [
            const MobileJobsSliverAppBar(),
            SliverFillRemaining(
                child: TabBarView(
              children: [
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.earthAmericas,
                        size: 72.0, color: Colors.grey[600]),
                    const Gutter(),
                    Text('A world of opportunities..',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            )),
                    const Gutter(),
                    FilledButton.tonal(
                        onPressed: () => context.go('/search  '),
                        style: OutlinedButton.styleFrom(
                            //   foregroundColor: Colors.grey[600],
                            //side: BorderSide(color: Colors.grey[600]!),
                            ),
                        child: const Text(' Search Jobs'))
                  ],
                )),
                const Center(child: Text('No Saved Jobs!')),
                const Center(child: Text('No Applications!')),
                const Center(child: Text('No Completed Jobs!')),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
