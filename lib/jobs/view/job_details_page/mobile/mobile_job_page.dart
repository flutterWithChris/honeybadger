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

class MobileJobDetailsPage extends StatefulWidget {
  final Job job;
  const MobileJobDetailsPage({required this.job, super.key});

  @override
  State<MobileJobDetailsPage> createState() => _MobileJobDetailsPageState();
}

class _MobileJobDetailsPageState extends State<MobileJobDetailsPage> {
  bool _writingProposal = false;
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
                  Hero(
                    tag: '${widget.job.id}-category',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(widget.job.category!.name!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const GutterSmall(),
                  Hero(
                    tag: '${widget.job.id}-title',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(widget.job.title!,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                  const GutterSmall(),

                  Row(
                    children: [
                      widget.job.startDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'Start:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                widget.job.startDate!)
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
                      widget.job.endDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'End:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                widget.job.endDate!)
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
                            Text(
                                parseEnumName(
                                    widget.job.paymentType.toString()),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Hero(
                        tag: '${widget.job.id}-budget',
                        child: Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            side: BorderSide.none,
                            elevation: 1,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            label: Text(numberFormat.format(widget.job.budget),
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
                                backgroundColor:
                                    widget.job.status == JobStatus.open
                                        ? Colors.green[400]
                                        : Colors.red,
                                radius: 4,
                              ),
                              Text(parseEnumName(widget.job.status.toString()),
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
                      child: Hero(
                        tag: '${widget.job.id}-description',
                        child: Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: Text(widget.job.description!,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    ),
                  ),
                  const GutterSmall(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _writingProposal
                        ? Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    expandedAlignment: Alignment.center,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(MdiIcons.timelineOutline,
                                            size: 24.0),
                                        const Gutter(),
                                        Text('Milestones',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            bottom: 16.0,
                                            right: 16.0),
                                        child: Row(
                                          children: [
                                            Wrap(
                                              spacing: 8.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              alignment: WrapAlignment.start,
                                              children: [
                                                for (String skill
                                                    in widget.job.skills!)
                                                  Chip(
                                                    padding: EdgeInsets.zero,
                                                    label: Text(skill),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const GutterSmall(),
                                const Flexible(
                                  child: TextField(
                                      minLines: 3,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          label: Text('Proposal'),
                                          hintText: 'Enter your proposal..')),
                                ),
                                const GutterSmall(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(MdiIcons.contentSaveCheck,
                                        size: 14.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    const GutterTiny(),
                                    Text('Draft Auto-Saved',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                                const GutterSmall(),
                                Flexible(
                                  child: FilledButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _writingProposal = false;
                                        });
                                      },
                                      icon: Icon(MdiIcons.sendCircleOutline),
                                      label: const Text('Send Proposal')),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _writingProposal = true;
                                      });
                                    },
                                    icon: Icon(MdiIcons.lightningBolt),
                                    label: const Text('Create Proposal'),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              child: widget.job.client!.photoUrl == null ||
                                      widget.job.client!.photoUrl!.isEmpty
                                  ? const Icon(Icons.person, size: 20)
                                  : CachedNetworkImage(
                                      imageUrl: widget.job.client!.photoUrl!)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.job.client!.firstName!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const GutterSmall(),
                                const Text('-'),
                                const GutterSmall(),
                                if (widget.job.client!.rating != null)
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
                                              '${widget.job.client!.rating.toString()} ',
                                          children: [
                                            TextSpan(
                                                text:
                                                    '(${widget.job.client!.ratingCount.toString()})',
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
                                    '${widget.job.client!.city!}, ${widget.job.client!.state!}',
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
                                for (String skill in widget.job.skills!)
                                  Chip(
                                    padding: EdgeInsets.zero,
                                    label: Text(skill),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (widget.job.tags != null && widget.job.tags!.isNotEmpty)
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
                              for (String tag in widget.job.tags!)
                                Chip(
                                  padding: EdgeInsets.zero,
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
