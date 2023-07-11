import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../model/job.dart';

class MobileJobPage extends StatelessWidget {
  final Job job;
  const MobileJobPage({required this.job, super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat numberFormat = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.category!.name!,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const GutterSmall(),
                  Text(job.title!,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const GutterSmall(),

                  Row(
                    children: [
                      job.startDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'Start:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                job.startDate!)
                                            .yMMMMd,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )
                          : const Text.rich(
                              TextSpan(
                                  text: 'Start:  ',
                                  children: [
                                    TextSpan(
                                        text: 'N/A',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                      const GutterSmall(),
                      job.endDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'End:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                job.endDate!)
                                            .yMMMMd,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            )
                          : const Text.rich(
                              TextSpan(
                                  text: 'End:  ',
                                  children: [
                                    TextSpan(
                                        text: 'N/A',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal))
                                  ],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                    ],
                  ),

                  const GutterSmall(),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MdiIcons.cashLock, size: 16.0),
                            const GutterSmall(),
                            Text(parseEnumName(job.paymentType.toString()),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        elevation: 1,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
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
                      Chip(
                        elevation: 1.0,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                        label: Wrap(
                            spacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: job.status == JobStatus.open
                                    ? Colors.green[400]
                                    : Colors.red,
                                radius: 4,
                              ),
                              Text(parseEnumName(job.status.toString()),
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                      )
                    ],
                  ),

                  const Gutter(),

                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Text(job.description!,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  const Gutter(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                          onPressed: () {},
                          icon: Icon(MdiIcons.lightningBolt),
                          label: const Text('Create Proposal')),
                    ],
                  ),
                  const Gutter(),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CircleAvatar(
                              radius: 14,
                              child: job.client!.photoUrl == null ||
                                      job.client!.photoUrl!.isEmpty
                                  ? const Icon(Icons.person, size: 20)
                                  : CachedNetworkImage(
                                      imageUrl: job.client!.photoUrl!)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  job.client!.firstName!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const GutterSmall(),
                                const Text('-'),
                                const GutterSmall(),
                                if (job.client!.rating != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        MdiIcons.star,
                                        color: Colors.yellow[600],
                                        size: 16.0,
                                      ),
                                      const GutterTiny(),
                                      Text.rich(TextSpan(
                                          text:
                                              '${job.client!.rating.toString()} ',
                                          children: [
                                            TextSpan(
                                                text:
                                                    '(${job.client!.ratingCount.toString()})',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall)
                                          ])),
                                    ],
                                  )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(MdiIcons.mapMarkerOutline, size: 14.0),
                                const GutterTiny(),
                                Text(
                                    '${job.client!.city!}, ${job.client!.state!}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: const [],
                  ),
                  // Text('Client', style: Theme.of(context).textTheme.titleSmall),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    expandedAlignment: Alignment.center,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MdiIcons.tools, size: 24.0),
                        const Gutter(),
                        Text('Skills',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, bottom: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Wrap(
                              spacing: 8.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              children: [
                                for (String skill in job.skills!)
                                  Chip(
                                    label: Text(skill),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (job.tags != null && job.tags!.isNotEmpty)
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      expandedAlignment: Alignment.center,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.tagText, size: 24.0),
                          const Gutter(),
                          Text('Tags',
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Wrap(
                            spacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: [
                              for (String tag in job.tags!)
                                Chip(
                                  label: Text(tag),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
