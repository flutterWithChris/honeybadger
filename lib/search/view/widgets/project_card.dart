import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/extensions.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/projects/model/project.dart';
import 'package:outsourcedx/proposals/bloc/proposal_bloc.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return InkWell(
      onTap: () {
        context.read<ProposalBloc>().add(LoadProposal(
            project.id!, context.read<ProfileBloc>().state.user!.id!));
        context.push('/project/${project.id}', extra: project);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: Hero(
                    tag: '${project.id}-title',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(project.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                  //fontWeight: FontWeight.bold,
                                  )),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Hero(
                        tag: '${project.id}-budget',
                        child: Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: Chip(
                            backgroundColor: Theme.of(context).primaryColor,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            side: BorderSide.none,
                            label: Text(numberFormat.format(project.budget),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //const GutterTiny(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${project.id}-description',
                  child: Material(
                    color: Colors.transparent,
                    type: MaterialType.transparency,
                    child: Text(
                      project.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const GutterSmall(),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Wrap(
                    spacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (String skill in project.skills ?? [])
                        Chip(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            label: Text(titleCase(skill),
                                style: Theme.of(context).textTheme.bodySmall),
                            visualDensity: VisualDensity.compact),

                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Icon(MdiIcons.calendarClock, size: 14.0),
                      //     const GutterTiny(),
                      //     Text('${project.weekEstimate! / 4} Months ',
                      //         style: Theme.of(context).textTheme.bodySmall),
                      //   ],
                      // )
                    ],
                  ),
                ],
              ),
            ),
            // Hero(
            //   tag: '${project.id}-category',
            //   child: Material(
            //     color: Colors.transparent,
            //     child: SizedBox(
            //       height: 32.0,
            //       child: FittedBox(
            //         child: Chip(
            //           visualDensity: VisualDensity.compact,
            //           label: Text(
            //             project.category!,
            //             maxLines: 1,
            //             style: const TextStyle(
            //               fontStyle: FontStyle.italic,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark)),
            //     IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
