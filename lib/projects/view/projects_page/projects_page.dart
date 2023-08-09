import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/projects/bloc/projects_bloc.dart';
import 'package:honeybadger/proposals/bloc/proposal_bloc.dart';

import '../../../core/presentation/system/mobile_jobs_app_bar.dart';
import '../../model/project.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: DefaultTabController(
        length: 4,
        child: CustomScrollView(
          slivers: [
            const MobileJobsSliverAppBar(),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsError) {
                  return SliverFillRemaining(
                      child: Center(child: Text(state.message)));
                }
                if (state is ProjectsLoading) {
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (state is ProjectsLoaded) {
                  return SliverFillRemaining(
                      child: TabBarView(
                    children: [
                      ActiveProjectsTab(
                          projects: state.projects
                              .where((element) =>
                                  element.status == ProjectStatus.open)
                              .toList()),
                      const Center(child: Text('No Saved Jobs!')),
                      const Center(child: Text('No Applications!')),
                      const Center(child: Text('No Completed Jobs!')),
                    ],
                  ));
                }
                return const SliverFillRemaining(
                    child: Center(child: Text('Something went wrong!')));
              },
            )
          ],
        ),
      ),
    );
  }
}

class ActiveProjectsTab extends StatelessWidget {
  final List<Project> projects;
  const ActiveProjectsTab({
    required this.projects,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.earthAmericas,
              size: 72.0,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[500]
                  : Colors.grey[600]),
          const Gutter(),
          Text('A world of opportunities..',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[500]
                      : Colors.grey[600])),
          const Gutter(),
          FilledButton(
              // style: FilledButton.styleFrom(
              //     foregroundColor: Colors.white),
              onPressed: () => context.go('/search  '),
              child: const Text(' Search Jobs'))
        ],
      ));
    } else {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          int unreadProposalCount = project.unreadProposalCount ?? 0;
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: ListTile(
                  visualDensity: VisualDensity.comfortable,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (unreadProposalCount != 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 2.0),
                              child: Badge.count(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                backgroundColor:
                                    Theme.of(context).indicatorColor,
                                count: unreadProposalCount,
                                alignment: Alignment.topCenter,
                                offset: const Offset(0, 1),
                              ),
                            ),
                          Text(
                            project.title!,
                            // style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(project.description!),
                  ),
                  onTap: () {
                    context.read<ProposalBloc>().add(LoadProposals(project.id!,
                        context.read<ProfileBloc>().state.user!.id!));
                    context.push('/project/${project.id}', extra: project);
                  }),
            ),
          );
        },
        separatorBuilder: (context, index) => const GutterSmall(),
      );
    }
  }
}
