import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';

import '../../model/project.dart';

class ProjectStatusChip extends StatelessWidget {
  final Project project;
  const ProjectStatusChip({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 1.0,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      label: Wrap(
          spacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: project.status == ProjectStatus.open
                  ? Colors.green[400]
                  : project.status == ProjectStatus.inProgress
                      ? Colors.blue[400]
                      : Colors.red[400],
              radius: 4,
            ),
            Text(parseEnumName(project.status.toString()),
                style: Theme.of(context).textTheme.bodyMedium),
          ]),
    );
  }
}
