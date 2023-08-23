import 'package:outsourcedx/core/presentation/drawers/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_jobs_app_bar%20copy.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/projects/bloc/projects_bloc.dart';
import 'package:outsourcedx/proposals/bloc/proposal_bloc.dart';

import '../../../core/presentation/system/mobile_jobs_app_bar.dart';
import '../../model/project.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        //   if (constraints.maxWidth > desktopWidthConstraint) {
        //  //   return const DesktopProjectsPage();
        //   } else if (constraints.maxWidth > tabletWidthConstraint) {
        //   //  return const TabletProjectsPage();
        //   }
        if (context.read<ProfileBloc>().state.user!.userType ==
            UserType.client) {
          return const MobileClientProjectsPage();
        }
        return const MobileProjectsPage();
      }),
    );
  }
}

class MobileProjectsPage extends StatelessWidget {
  const MobileProjectsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasActiveProjects = context
            .watch<ProjectsBloc>()
            .state
            .projects
            ?.where((element) => element.status == ProjectStatus.inProgress)
            .toList()
            .isNotEmpty ??
        false;
    return DefaultTabController(
      length: 3,
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
                    if (hasActiveProjects)
                      ActiveProjectsTab(
                          projects: state.projects
                              .where((element) =>
                                  element.status == ProjectStatus.inProgress)
                              .toList()),
                    AppliedProjectsTab(
                        projects: state.projects
                            .where((element) =>
                                element.status == ProjectStatus.open)
                            .toList()),
                    CompletedProjectsTab(
                        projects: state.projects
                            .where((element) =>
                                element.status == ProjectStatus.completed)
                            .toList()),
                  ],
                ));
              }
              return const SliverFillRemaining(
                  child: Center(child: Text('Something went wrong!')));
            },
          )
        ],
      ),
    );
  }
}

class MobileClientProjectsPage extends StatelessWidget {
  const MobileClientProjectsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool hasActiveProjects = context
            .watch<ProjectsBloc>()
            .state
            .projects
            ?.where((element) => element.status == ProjectStatus.inProgress)
            .toList()
            .isNotEmpty ??
        false;
    return DefaultTabController(
      length: 3,
      child: CustomScrollView(
        slivers: [
          const ClientProjectsSliverAppBar(),
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
                                element.status == ProjectStatus.inProgress)
                            .toList()),
                    OpenProjectsTab(
                        projects: state.projects
                            .where((element) =>
                                element.status == ProjectStatus.open)
                            .toList()),
                    CompletedProjectsTab(
                        projects: state.projects
                            .where((element) =>
                                element.status == ProjectStatus.completed)
                            .toList()),
                  ],
                ));
              }
              return const SliverFillRemaining(
                  child: Center(child: Text('Something went wrong!')));
            },
          )
        ],
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
          if (context.read<ProfileBloc>().state.user!.userType ==
              UserType.freelancer) {
            return ProjectCard(project: project);
          } else {
            return ClientProjectCard(
                unreadProposalCount: unreadProposalCount, project: project);
          }
        },
        separatorBuilder: (context, index) => const GutterSmall(),
      );
    }
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: ListTile(
            visualDensity: VisualDensity.comfortable,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  project.title!,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(project.description!),
            ),
            onTap: () {
              context.read<ProposalBloc>().add(LoadProposal(
                  project.id!, context.read<ProfileBloc>().state.user!.id!));
              context.push('/project/${project.id}', extra: project);
            }),
      ),
    );
  }
}

class OpenProjectsTab extends StatelessWidget {
  final List<Project> projects;
  const OpenProjectsTab({
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
          if (context.read<ProfileBloc>().state.user!.userType ==
              UserType.freelancer) {
            return ProjectCard(project: project);
          } else {
            return ClientProjectCard(
                unreadProposalCount: unreadProposalCount, project: project);
          }
        },
        separatorBuilder: (context, index) => const GutterSmall(),
      );
    }
  }
}

class AppliedProjectsTab extends StatelessWidget {
  final List<Project> projects;
  const AppliedProjectsTab({
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
          if (context.read<ProfileBloc>().state.user!.userType ==
              UserType.freelancer) {
            return ProjectCard(project: project);
          } else {
            return ClientProjectCard(
                unreadProposalCount: unreadProposalCount, project: project);
          }
        },
        separatorBuilder: (context, index) => const GutterSmall(),
      );
    }
  }
}

class ClientProjectCard extends StatelessWidget {
  const ClientProjectCard({
    super.key,
    required this.unreadProposalCount,
    required this.project,
  });

  final int unreadProposalCount;
  final Project project;

  @override
  Widget build(BuildContext context) {
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
                        padding: const EdgeInsets.only(right: 8.0, bottom: 2.0),
                        child: Badge.count(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          backgroundColor: Theme.of(context).indicatorColor,
                          count: unreadProposalCount,
                          alignment: Alignment.topCenter,
                          offset: const Offset(0, 1),
                        ),
                      ),
                    Text(
                      project.title!,
                      style: Theme.of(context).textTheme.titleMedium,
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
              context.read<ProposalBloc>().add(LoadProposals(
                  project, context.read<ProfileBloc>().state.user!.id!));
              context.push('/project/${project.id}', extra: project);
            }),
      ),
    );
  }
}

class CompletedProjectsTab extends StatelessWidget {
  final List<Project> projects;
  const CompletedProjectsTab({
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
          if (context.read<ProfileBloc>().state.user!.userType ==
              UserType.freelancer) {
            return ProjectCard(project: project);
          } else {
            return ClientProjectCard(
                unreadProposalCount: unreadProposalCount, project: project);
          }
        },
        separatorBuilder: (context, index) => const GutterSmall(),
      );
    }
  }
}
