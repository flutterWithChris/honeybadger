import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return Card(
      elevation: 1,
      //  color: Theme.of(context).colorScheme.surfaceVariant,
      // shape: RoundedRectangleBorder(
      //   side: BorderSide(
      //     color: Theme.of(context).colorScheme.outline,
      //     width: 0.6,
      //   ),
      //   borderRadius: const BorderRadius.all(Radius.circular(12)),
      // ),
      child: InkWell(
        onTap: () {
          context.push('/job/${job.id}', extra: job);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Hero(
                      tag: '${job.id}-title',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(job.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                          tag: '${job.id}-budget',
                          child: Material(
                            color: Colors.transparent,
                            type: MaterialType.transparency,
                            child: Chip(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              side: BorderSide.none,
                              label: Text(numberFormat.format(job.budget),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const GutterTiny(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: '${job.id}-category',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        job.category!.name!,
                        maxLines: 1,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const GutterTiny(),
                  Hero(
                    tag: '${job.id}-description',
                    child: Material(
                      color: Colors.transparent,
                      type: MaterialType.transparency,
                      child: Text(
                        job.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const Gutter(),
              Wrap(
                spacing: 16.0,
                children: [
                  Text(
                    job.skills!.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.clockOutline, size: 14.0),
                      const GutterTiny(),
                      Text(
                          '${job.paymentType.toString().split('.').last.capitalize} ',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.calendarClock, size: 14.0),
                      const GutterTiny(),
                      Text('${job.weekEstimate! / 4} Months ',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  )
                ],
              ),
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
      ),
    );
  }
}
