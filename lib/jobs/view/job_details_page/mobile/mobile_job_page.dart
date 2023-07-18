import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/jobs/model/milestone.dart';
import 'package:honeybadger/jobs/model/proposal.dart';
import 'package:honeybadger/proposals/bloc/proposal_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../model/job.dart';

class MobileJobDetailsPage extends StatefulWidget {
  final Job job;
  const MobileJobDetailsPage({required this.job, super.key});

  @override
  State<MobileJobDetailsPage> createState() => _MobileJobDetailsPageState();
}

class _MobileJobDetailsPageState extends State<MobileJobDetailsPage> {
  final bool _writingProposal = false;
  Timer? _autosaveTimer;
  late Timer _autosaveTimestampTimer;
  DateTime? _lastSavedAt;
  String? _lastSavedAtString;
  final _proposalController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    // _autosaveTimestampTimer =
    //     Timer.periodic(const Duration(minutes: 1), (timer) {
    //   if (context.watch<ProposalBloc>().state is ProposalStarted &&
    //       _lastSavedAt != null) {
    //     setState(() {
    //       _lastSavedAt = context.read<ProposalBloc>().state.proposal!.savedAt;
    //       _lastSavedAtString = Jiffy.parseFromDateTime(_lastSavedAt!).fromNow();
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _proposalController.dispose();
    super.dispose();
  }

  void _startAutosaveTimer() {
    _autosaveTimer ??= Timer(const Duration(seconds: 30), () {
      _save();
      _cancelAutosaveTimer();
    });
  }

  void _cancelAutosaveTimer() {
    _autosaveTimer?.cancel();
    _autosaveTimer = null;
  }

  void _save() {
    // Save the user's work here.
    context.read<ProposalBloc>().add(
          AutoSaveProposal(
            context.read<ProposalBloc>().state.proposal!.copyWith(
                  description: _proposalController.text,
                ),
          ),
        );
  }

  void _setAutoSaveTimestamp() {
    setState(() {
      _lastSavedAt = context.read<ProposalBloc>().state.proposal!.savedAt;
      _lastSavedAtString = Jiffy.parseFromDateTime(_lastSavedAt!).fromNow();
    });
  }

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
                  const Gutter(),
                  BlocBuilder<ProposalBloc, ProposalState>(
                      builder: (context, state) {
                    return AnimatedSwitcher(
                        // transitionBuilder:
                        //     (child, primaryAnimation, secondaryAnimation) {
                        //   return SharedAxisTransition(
                        //     animation: primaryAnimation,
                        //     secondaryAnimation: secondaryAnimation,
                        //     transitionType:
                        //         SharedAxisTransitionType.vertical,
                        //     child: child,
                        //   );
                        // },
                        // height: state is ProposalStarted ? 280.0 : 60.0,
                        duration: const Duration(milliseconds: 300),
                        //  curve: Curves.easeInOutSine,
                        child: state is ProposalLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FilledButton.icon(
                                    onPressed: () {
                                      // setState(() {
                                      //   _writingProposal = true;
                                      // });
                                    },
                                    icon: LoadingAnimationWidget.beat(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        size: 14.0),
                                    label: const Text('Loading Proposal'),
                                  ),
                                ],
                              )
                            : state is ProposalStarted ||
                                    state is ProposalSaving ||
                                    state is ProposalSaved
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.job.paymentType ==
                                              PaymentType.fixedPrice
                                          ? Flexible(
                                              child: ExpansionTile(
                                                tilePadding: EdgeInsets.zero,
                                                expandedAlignment:
                                                    Alignment.center,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                title: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        MdiIcons
                                                            .timelineOutline,
                                                        size: 24.0),
                                                    const Gutter(),
                                                    Text('Milestones',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge),
                                                  ],
                                                ),
                                                children: [
                                                  BlocBuilder<ProposalBloc,
                                                      ProposalState>(
                                                    builder: (context, state) {
                                                      // if (state
                                                      //     is ProposalSaving) {
                                                      //   return const Center(
                                                      //       child:
                                                      //           CircularProgressIndicator());
                                                      // }
                                                      if (state
                                                              is ProposalStarted ||
                                                          state
                                                              is ProposalSaving) {
                                                        _lastSavedAt = state
                                                            .proposal?.savedAt;
                                                        List<Milestone>?
                                                            milestones = state
                                                                .proposal
                                                                ?.milestones;
                                                        if (milestones !=
                                                                null &&
                                                            milestones
                                                                .isNotEmpty) {
                                                          return Column(
                                                            children: [
                                                              for (Milestone milestone
                                                                  in milestones)
                                                                MilestoneEntry(
                                                                  proposal: state
                                                                      .proposal,
                                                                  milestone:
                                                                      milestone,
                                                                ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  OutlinedButton.icon(
                                                                      style: FilledButton.styleFrom(minimumSize: const Size(180, 34), fixedSize: const Size(180, 34)),
                                                                      onPressed: () {
                                                                        context
                                                                            .read<ProposalBloc>()
                                                                            .add(
                                                                              AddMilestone(
                                                                                Milestone(jobId: state.proposal!.jobId),
                                                                              ),
                                                                            );
                                                                      },
                                                                      icon: Icon(MdiIcons.plusCircle, size: 12.0),
                                                                      label: const Text('Add Milestone')),
                                                                ],
                                                              ),
                                                              const GutterLarge(),
                                                            ],
                                                          );
                                                        } else {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const GutterSmall(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  OutlinedButton.icon(
                                                                      style: FilledButton.styleFrom(minimumSize: const Size(180, 34), fixedSize: const Size(180, 34)),
                                                                      onPressed: () {
                                                                        context
                                                                            .read<ProposalBloc>()
                                                                            .add(
                                                                              AddMilestone(
                                                                                Milestone(jobId: widget.job.id),
                                                                              ),
                                                                            );
                                                                      },
                                                                      icon: Icon(MdiIcons.plusCircle, size: 12.0),
                                                                      label: const Text('Add Milestone')),
                                                                ],
                                                              ),
                                                              const Gutter(),
                                                            ],
                                                          );
                                                        }
                                                      }
                                                      return const Text(
                                                          'Something went wrong.');
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          : const Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      width: 160.0,
                                                      child: TextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          label: Text(
                                                              'Hourly Rate'),
                                                          prefixText: '\$',
                                                          suffixText: '/hr',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(
                                                    flex: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      const GutterSmall(),
                                      Flexible(
                                        child: TextField(
                                            scrollPadding:
                                                const EdgeInsets.only(
                                                    bottom: 200),
                                            onChanged: (value) {
                                              // _cancelAutosaveTimer();
                                              _startAutosaveTimer();
                                            },
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            minLines: 5,
                                            maxLines: 7,
                                            decoration: const InputDecoration(
                                                label: Text('Proposal'),
                                                hintText:
                                                    'Enter your proposal..')),
                                      ),
                                      const GutterSmall(),
                                      BlocConsumer<ProposalBloc, ProposalState>(
                                        listener: (context, state) {
                                          if (state is ProposalSaving) {
                                            _setAutoSaveTimestamp();
                                            Timer.periodic(
                                                const Duration(minutes: 1),
                                                (timer) {
                                              _setAutoSaveTimestamp();
                                            });
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is ProposalSaving) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const CupertinoActivityIndicator(
                                                  radius: 6.0,
                                                ),
                                                // LoadingAnimationWidget.beat(
                                                //     color: Theme.of(context)
                                                //         .iconTheme
                                                //         .color!,
                                                //     size: 12.0),
                                                const GutterTiny(),
                                                Text('Auto-Saving...',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                              ],
                                            );
                                          }
                                          if (state is ProposalStarted) {
                                            if (state.proposal?.savedAt !=
                                                null) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                      MdiIcons.contentSaveCheck,
                                                      size: 14.0,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                  const GutterTiny(),
                                                  Text(
                                                      'Auto-Saved · ${_lastSavedAtString!}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall),
                                                ],
                                              );
                                            }
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                      const GutterSmall(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: IconButton(
                                                onPressed: () async {
                                                  if (state.proposal != null) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(24.0),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      'Are you sure you want to delete this proposal?',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleLarge),
                                                                  const Gutter(),
                                                                  const Text(
                                                                    'You will not be able to recover this proposal once it is deleted.',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  const Gutter(),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: OutlinedButton(
                                                                            onPressed: () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: const Text('Cancel')),
                                                                      ),
                                                                      const Gutter(),
                                                                      Expanded(
                                                                        child: FilledButton.icon(
                                                                            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                                                                            onPressed: () {
                                                                              context.read<ProposalBloc>().add(DeleteProposal(state.proposal));
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            label: const Text('Delete', style: TextStyle(color: Colors.white)),
                                                                            icon: const Icon(Icons.cancel_outlined, size: 16.0, color: Colors.white)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    context
                                                        .read<ProposalBloc>()
                                                        .add(
                                                            const DeleteProposal(
                                                                null));
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.cancel_outlined)),
                                          ),
                                          const Gutter(),
                                          Expanded(
                                            flex: 4,
                                            child: FilledButton.icon(
                                                onPressed: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(24.0),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    'Are you sure you want to send this proposal?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleLarge),
                                                                const Gutter(),
                                                                const Text(
                                                                  'You will not be able to edit this proposal once it is sent.',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                const Gutter(),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: OutlinedButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text('Cancel')),
                                                                    ),
                                                                    const Gutter(),
                                                                    Expanded(
                                                                      child: FilledButton.icon(
                                                                          onPressed: () {
                                                                            context.read<ProposalBloc>().add(
                                                                                  SendProposal(
                                                                                    Proposal(
                                                                                      jobId: widget.job.id,
                                                                                      status: ProposalStatus.sent,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          icon: Icon(MdiIcons.sendCircleOutline, size: 20.0),
                                                                          label: const Text('Send')),
                                                                    ),
                                                                  ],
                                                                )
                                                              ]),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                    MdiIcons.sendCircleOutline),
                                                label: const Text(
                                                    'Send Proposal')),
                                          ),
                                          const Spacer(),
                                          //   const Flexible(child: SizedBox(width: 32.0))
                                        ],
                                      ),
                                    ],
                                  )
                                :

                                //  else
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FilledButton.icon(
                                        onPressed: () {
                                          context.read<ProposalBloc>().add(
                                              StartProposal(widget.job.id!));
                                        },
                                        icon: Icon(MdiIcons.lightningBolt),
                                        label: const Text('Create Proposal'),
                                      ),
                                    ],
                                  ));
                  }),
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

class MilestoneEntry extends StatelessWidget {
  final Proposal? proposal;
  final Milestone milestone;
  const MilestoneEntry({
    this.proposal,
    required this.milestone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
            begin: Offset(-0.5, 0.0), duration: Duration(milliseconds: 200))
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // FilledButton(
            //     style: FilledButton.styleFrom(
            //         minimumSize:
            //             const Size(160, 32),
            //         fixedSize:
            //             const Size(100, 32)),
            //     onPressed: () {},
            //     child: const Text(
            //         'Add Milestone')),

            Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  // side: const BorderSide(
                  //     color: Colors.blue,
                  //     width: 4.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusColor: Colors.transparent,
                hoverColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.02),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // IconButton(
                            //     padding: EdgeInsets.zero,
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.drag_handle)),
                            IconButton(
                                hoverColor: Colors.red.withOpacity(0.6),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context
                                      .read<ProposalBloc>()
                                      .add(DeleteMilestone(milestone));
                                },
                                icon: const Icon(Icons.delete_outline)),
                          ],
                        ),
                      ),
                      const Gutter(),
                      const Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration:
                                        InputDecoration(label: Text('Name')),
                                  ),
                                ),
                                GutterSmall(),
                                Expanded(
                                    child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      prefixText: '\$', label: Text('Budget')),
                                )),
                              ],
                            ),
                            GutterSmall(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text('Start Date')),
                                  ),
                                ),
                                GutterSmall(),
                                Flexible(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        label: Text('End Date')),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
