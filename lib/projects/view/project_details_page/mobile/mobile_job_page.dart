import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/projects/view/widgets/project_status_chip.dart';
import 'package:honeybadger/proposals/model/milestone.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/proposals/bloc/proposal_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../model/project.dart';

Timer? _autosaveTimer;
late Timer _autosaveTimestampTimer;
DateTime? _lastSavedAt;
String? _lastSavedAtString;

class MobileProjectDetailsPage extends StatefulWidget {
  final Project project;
  const MobileProjectDetailsPage({required this.project, super.key});

  @override
  State<MobileProjectDetailsPage> createState() =>
      _MobileProjectDetailsPageState();
}

class _MobileProjectDetailsPageState extends State<MobileProjectDetailsPage> {
  final bool _writingProposal = false;

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
                    tag: '${widget.project.id}-category',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(widget.project.category!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic)),
                    ),
                  ),
                  const GutterSmall(),
                  Hero(
                    tag: '${widget.project.id}-title',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(widget.project.title!,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                  const GutterSmall(),

                  Row(
                    children: [
                      widget.project.startDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'Start:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                widget.project.startDate!)
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
                      widget.project.endDate != null
                          ? Text.rich(
                              TextSpan(
                                  text: 'End:  ',
                                  children: [
                                    TextSpan(
                                        text: Jiffy.parseFromDateTime(
                                                widget.project.endDate!)
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
                      Hero(
                        tag: '${widget.project.id}-budget',
                        child: Material(
                          color: Colors.transparent,
                          type: MaterialType.transparency,
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            side: BorderSide.none,
                            elevation: 1,
                            backgroundColor: Theme.of(context).primaryColor,
                            label: Text(
                                numberFormat.format(widget.project.budget),
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
                                    widget.project.projectType.toString()),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      ProjectStatusChip(project: widget.project)
                    ],
                  ),
                  const Gutter(),
                  Hero(
                    tag: '${widget.project.id}-description',
                    child: Material(
                      color: Colors.transparent,
                      type: MaterialType.transparency,
                      child: Text(widget.project.description!,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),

                  context.watch<ProposalBloc>().state is ProposalStarted
                      ? const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Divider(),
                        )
                      : const Gutter(),
                  CreateProposalSection(
                    widget: widget,
                  ),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 16.0),
                        //   child: CircleAvatar(
                        //       radius: 14,
                        //       child: widget.project.client!.photoUrl == null ||
                        //               widget.project.client!.photoUrl!.isEmpty
                        //           ? const Icon(Icons.person, size: 20)
                        //           : CachedNetworkImage(
                        //               imageUrl:
                        //                   widget.project.client!.photoUrl!)),
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.project.clientName!.split(' ')[0],
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const GutterSmall(),
                                const Text('-'),
                                const GutterSmall(),
                                // if (widget.project.client!.rating != null)
                                //   Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       Icon(
                                //         MdiIcons.star,
                                //         color: Colors.yellow[600],
                                //         size: 16.0,
                                //       ),
                                //       const GutterTiny(),
                                //       Text.rich(TextSpan(
                                //           text:
                                //               '${widget.project.client!.rating.toString()} ',
                                //           children: [
                                //             TextSpan(
                                //                 text:
                                //                     '(${widget.project.client!.ratingCount.toString()})',
                                //                 style: Theme.of(context)
                                //                     .textTheme
                                //                     .bodySmall)
                                //           ])),
                                //     ],
                                //   )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(MdiIcons.mapMarkerOutline, size: 14.0),
                                const GutterTiny(),
                                // Text(
                                //     '${widget.project.client!.city!}, ${widget.project.client!.state!}',
                                //     style:
                                //         Theme.of(context).textTheme.bodyMedium),
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
                                for (String skill in widget.project.skills!)
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
                  if (widget.project.tags != null &&
                      widget.project.tags!.isNotEmpty)
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
                              for (String tag in widget.project.tags!)
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

class CreateProposalSection extends StatefulWidget {
  const CreateProposalSection({
    super.key,
    required this.widget,
  });

  final MobileProjectDetailsPage widget;

  @override
  State<CreateProposalSection> createState() => _CreateProposalSectionState();
}

class _CreateProposalSectionState extends State<CreateProposalSection> {
  final TextEditingController _proposalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalBloc, ProposalState>(builder: (context, state) {
      if (state is ProposalStarted ||
          state is ProposalSent ||
          state is ProposalLoaded && _proposalController.text.isEmpty) {
        _proposalController.text = state.proposal?.description ?? '';
      }
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
                          color: Theme.of(context).colorScheme.onPrimary,
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
                        widget.widget.project.projectType == ProjectType.fixed
                            ? Flexible(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    expandedAlignment: Alignment.center,
                                    // backgroundColor:
                                    //     Theme.of(context)
                                    //         .colorScheme
                                    //         .surface,
                                    title: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(MdiIcons.timelineOutline,
                                            size: 24.0),
                                        const Gutter(),
                                        Text('Milestones',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            context.read<ProposalBloc>().add(
                                                AddMilestone(Milestone(
                                                    id: const Uuid().v4(),
                                                    projectId: widget
                                                        .widget.project.id!)));
                                          },
                                          icon: Icon(MdiIcons.plusCircle,
                                              size: 20.0),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      BlocBuilder<ProposalBloc, ProposalState>(
                                        builder: (context, state) {
                                          // if (state
                                          //     is ProposalSaving) {
                                          //   return const Center(
                                          //       child:
                                          //           CircularProgressIndicator());
                                          // }
                                          if (state is ProposalStarted ||
                                              state is ProposalSaving ||
                                              state is ProposalSaved ||
                                              state is ProposalLoaded ||
                                              state is ProposalSent) {
                                            _lastSavedAt =
                                                state.proposal?.savedAt;
                                            List<Milestone>? milestones =
                                                state.proposal?.milestones;
                                            if (milestones != null &&
                                                milestones.isNotEmpty) {
                                              return Column(
                                                children: [
                                                  for (Milestone milestone
                                                      in milestones)
                                                    Slidable(
                                                      endActionPane: ActionPane(
                                                        motion:
                                                            const DrawerMotion(),
                                                        children: [
                                                          SlidableAction(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius.circular(
                                                                        16.0)),
                                                            label: 'Delete',
                                                            onPressed:
                                                                (context) {
                                                              context
                                                                  .read<
                                                                      ProposalBloc>()
                                                                  .add(DeleteMilestone(
                                                                      milestone));
                                                            },
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            foregroundColor:
                                                                Colors.white,
                                                            icon: Icons
                                                                .delete_outline,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: MilestoneEntry(
                                                          proposal:
                                                              state.proposal,
                                                          milestone: milestone,
                                                        ),
                                                      ),
                                                    ),
                                                  state.proposal?.milestones !=
                                                              null &&
                                                          state
                                                              .proposal!
                                                              .milestones!
                                                              .isNotEmpty &&
                                                          state.proposal
                                                                  ?.savedAt !=
                                                              null
                                                      ? const Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                AutoSaveStatusWidget()
                                                              ],
                                                            ),
                                                            Gutter()
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('No milestones yet.',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
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
                                ),
                              )
                            : Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 160.0,
                                        child: TextField(
                                          controller: _rateController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            label: Text('Hourly Rate'),
                                            prefixText: '\$',
                                            suffixText: '/hr',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                'Proposal Budget: ${convertIntToCurrency(context.watch<ProposalBloc>().state.proposal?.budgetTotal ?? 0)}'),
                          ],
                        ),
                        const Gutter(),
                        Flexible(
                          child: TextField(
                              controller: _proposalController,
                              scrollPadding: const EdgeInsets.only(bottom: 200),
                              onChanged: (value) {
                                context
                                    .read<ProposalBloc>()
                                    .add(UpdateDescription(value));
                                _startAutosaveTimer(context);
                              },
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 5,
                              maxLines: 7,
                              decoration: const InputDecoration(
                                  label: Text('Proposal'),
                                  hintText: 'Enter your proposal..')),
                        ),
                        const GutterSmall(),
                        const AutoSaveStatusWidget(),
                        const GutterSmall(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //const Gutter(),
                            const Spacer(),
                            Expanded(
                              flex: 6,
                              child: FilledButton.icon(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'Are you sure you want to send this proposal?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge),
                                                  const Gutter(),
                                                  const Text(
                                                    'You will not be able to edit this proposal once it is sent.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const Gutter(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Cancel')),
                                                      ),
                                                      const Gutter(),
                                                      Expanded(
                                                        child:
                                                            FilledButton.icon(
                                                                onPressed: () {
                                                                  context
                                                                      .read<
                                                                          ProposalBloc>()
                                                                      .add(
                                                                        SendProposal(state.proposal!.copyWith(
                                                                            status:
                                                                                ProposalStatus.sent,
                                                                            sentAt: DateTime.now())),
                                                                      );
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                icon: Icon(
                                                                    MdiIcons
                                                                        .sendCircleOutline,
                                                                    size: 20.0),
                                                                label:
                                                                    const Text(
                                                                        'Send')),
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(MdiIcons.sendCircleOutline),
                                  label: const Text('Send Proposal')),
                            ),

                            //   const Flexible(child: SizedBox(width: 32.0))
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              if (state.proposal != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Are you sure you want to delete this proposal?',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              const Gutter(),
                                              const Text(
                                                'You will not be able to recover this proposal once it is deleted.',
                                                textAlign: TextAlign.center,
                                              ),
                                              const Gutter(),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel')),
                                                  ),
                                                  const Gutter(),
                                                  Expanded(
                                                    child: FilledButton.icon(
                                                        style: FilledButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent),
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  ProposalBloc>()
                                                              .add(DeleteProposal(
                                                                  state
                                                                      .proposal));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        label: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        icon: const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            size: 16.0,
                                                            color:
                                                                Colors.white)),
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
                                    .add(const DeleteProposal(null));
                              }
                            },
                            child: Text(
                              state.proposal != null
                                  ? 'Delete Proposal'
                                  : 'Cancel',
                            )),
                      ],
                    )
                  : state is ProposalLoaded || state is ProposalSent
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.widget.project.projectType ==
                                    ProjectType.fixed
                                ? Flexible(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        expandedAlignment: Alignment.center,
                                        // backgroundColor:
                                        //     Theme.of(context)
                                        //         .colorScheme
                                        //         .surface,
                                        title: Row(
                                          // mainAxisSize: MainAxisSize.min,
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
                                          BlocBuilder<ProposalBloc,
                                              ProposalState>(
                                            builder: (context, state) {
                                              // if (state
                                              //     is ProposalSaving) {
                                              //   return const Center(
                                              //       child:
                                              //           CircularProgressIndicator());
                                              // }
                                              if (state is ProposalStarted ||
                                                  state is ProposalSaving ||
                                                  state is ProposalSaved ||
                                                  state is ProposalLoaded ||
                                                  state is ProposalSent) {
                                                _lastSavedAt =
                                                    state.proposal?.savedAt;
                                                List<Milestone>? milestones =
                                                    state.proposal?.milestones;
                                                if (milestones != null &&
                                                    milestones.isNotEmpty) {
                                                  return Column(
                                                    children: [
                                                      for (Milestone milestone
                                                          in milestones)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 8.0),
                                                          child: MilestoneEntry(
                                                            proposal:
                                                                state.proposal,
                                                            milestone:
                                                                milestone,
                                                            readOnly: true,
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              'No milestones yet.',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium),
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
                                    ),
                                  )
                                : Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            width: 160.0,
                                            child: TextField(
                                              controller: _rateController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                label: Text('Hourly Rate'),
                                                prefixText: '\$',
                                                suffixText: '/hr',
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    'Proposal Budget: ${convertIntToCurrency(context.watch<ProposalBloc>().state.proposal?.budgetTotal ?? 0)}'),
                              ],
                            ),
                            const Gutter(),
                            Flexible(
                              child: TextField(
                                  readOnly: true,
                                  controller: _proposalController,
                                  scrollPadding:
                                      const EdgeInsets.only(bottom: 200),
                                  onChanged: (value) {
                                    context
                                        .read<ProposalBloc>()
                                        .add(UpdateDescription(value));
                                    _startAutosaveTimer(context);
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  minLines: 5,
                                  maxLines: 7,
                                  decoration: const InputDecoration(
                                      label: Text('Proposal'),
                                      hintText: 'Enter your proposal..')),
                            ),
                            const GutterSmall()
                          ],
                        )

                      //  else

                      : state is ProposalSending
                          ? SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LoadingAnimationWidget.staggeredDotsWave(
                                      color: Theme.of(context).primaryColor,
                                      size: 24.0),
                                  const Gutter(),
                                  Text('Sending Proposal',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FilledButton.icon(
                                  onPressed: () {
                                    context
                                        .read<ProposalBloc>()
                                        .add(StartProposal(
                                            widget.widget.project.id!,
                                            Proposal(
                                              projectId:
                                                  widget.widget.project.id!,
                                              description:
                                                  _proposalController.text,
                                              freelancerId: context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user!
                                                  .id,
                                              freelancerName: context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user!
                                                  .firstName,
                                              clientId: widget
                                                  .widget.project.clientId,
                                              clientName: widget
                                                  .widget.project.clientName,
                                            )));
                                  },
                                  icon: Icon(MdiIcons.lightningBolt),
                                  label: const Text('Create Proposal'),
                                ),
                              ],
                            ));
    });
  }
}

class AutoSaveStatusWidget extends StatelessWidget {
  const AutoSaveStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProposalBloc, ProposalState>(
      listener: (context, state) {
        if (state is ProposalSaving) {
          _setAutoSaveTimestamp(context);
          Timer.periodic(const Duration(minutes: 1), (timer) {
            _setAutoSaveTimestamp(context);
          });
        }
      },
      builder: (context, state) {
        if (state is ProposalSaving) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        }
        if (state is ProposalStarted) {
          if (state.proposal?.savedAt != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(MdiIcons.contentSaveCheck,
                    size: 14.0, color: Theme.of(context).colorScheme.secondary),
                const GutterTiny(),
                if (_lastSavedAtString != null)
                  Text('Auto-Saved · ${_lastSavedAtString!}',
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}

void _startAutosaveTimer(BuildContext context) {
  _autosaveTimer ??= Timer(const Duration(seconds: 30), () {
    _save(context);
    _cancelAutosaveTimer();
  });
}

void _cancelAutosaveTimer() {
  _autosaveTimer?.cancel();
  _autosaveTimer = null;
}

void _save(BuildContext context) {
  // Save the user's work here.
  context.read<ProposalBloc>().add(
        AutoSaveProposal(context.read<ProposalBloc>().state.proposal!),
      );
}

void _setAutoSaveTimestamp(BuildContext context) {
  _lastSavedAt = DateTime.now();
  _lastSavedAtString = Jiffy.parseFromDateTime(_lastSavedAt!).fromNow();
}

class MilestoneEntry extends StatefulWidget {
  final Proposal? proposal;
  final Milestone milestone;
  final bool? readOnly;
  const MilestoneEntry({
    this.proposal,
    required this.milestone,
    this.readOnly,
    super.key,
  });

  @override
  State<MilestoneEntry> createState() => _MilestoneEntryState();
}

class _MilestoneEntryState extends State<MilestoneEntry> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.milestone.title ?? '';
    _descriptionController.text = widget.milestone.description ?? '';
    _amountController.text = widget.milestone.amount != null
        ? widget.milestone.amount!.toString()
        : '';
    _startDateController.text = widget.milestone.startDate != null
        ? Jiffy.parseFromDateTime(widget.milestone.startDate!).yMMMMd
        : '';
    _dueDateController.text = widget.milestone.dueDate != null
        ? Jiffy.parseFromDateTime(widget.milestone.dueDate!).yMMMMd
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
            begin: Offset(1.0, 0.0),
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOutSine)
      ],
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Card(
              elevation: 0.618,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
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
                                  readOnly: widget.readOnly ?? false,
                                  controller: _titleController,
                                  onChanged: (value) {
                                    context.read<ProposalBloc>().add(
                                        UpdateMilestone(widget.milestone
                                            .copyWith(title: value)));
                                    _startAutosaveTimer(context);
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                      label: Text('Title'),
                                      hintText: 'e.g. Design Phase',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ),
                              ),
                              const GutterSmall(),
                              Expanded(
                                  child: TextField(
                                readOnly: widget.readOnly ?? false,
                                controller: _amountController,
                                onChanged: (value) {
                                  value.isEmpty || value == '0' || value == ''
                                      ? context.read<ProposalBloc>().add(
                                          UpdateMilestone(widget.milestone
                                              .copyWith(amount: 0)))
                                      : context.read<ProposalBloc>().add(
                                          UpdateMilestone(widget.milestone
                                              .copyWith(
                                                  amount: int.parse(value))));
                                  _startAutosaveTimer(context);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    prefixText: '\$',
                                    label: Text('Budget'),
                                    hintText: 'e.g. \$1000',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              )),
                            ],
                          ),
                          const GutterSmall(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  controller: _startDateController,
                                  onTap: widget.readOnly == true
                                      ? null
                                      : () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(
                                                      const Duration(
                                                          days: 365)))
                                              .then((value) {
                                            if (value != null) {
                                              context.read<ProposalBloc>().add(
                                                  UpdateMilestone(
                                                      widget.milestone.copyWith(
                                                          startDate: value)));
                                              _startDateController.text =
                                                  Jiffy.parseFromDateTime(value)
                                                      .yMMMMd;
                                              _startAutosaveTimer(context);
                                            }
                                          });
                                        },
                                  onChanged: (value) {
                                    _startAutosaveTimer(context);
                                  },
                                  decoration: const InputDecoration(
                                      label: Text('Start Date'),
                                      hintText: 'Select a date',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ),
                              ),
                              const GutterSmall(),
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  controller: _dueDateController,
                                  onTap: widget.readOnly == true
                                      ? null
                                      : () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(
                                                      const Duration(
                                                          days: 365)))
                                              .then((value) {
                                            if (value != null) {
                                              context.read<ProposalBloc>().add(
                                                  UpdateMilestone(
                                                      widget.milestone.copyWith(
                                                          dueDate: value)));
                                              _dueDateController.text =
                                                  Jiffy.parseFromDateTime(value)
                                                      .yMMMMd;
                                              _startAutosaveTimer(context);
                                            }
                                          });
                                        },
                                  onChanged: (value) {
                                    _startAutosaveTimer(context);
                                  },
                                  decoration: const InputDecoration(
                                      label: Text('End Date'),
                                      hintText: 'Select a date',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
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
            // if (widget.readOnly == false)
            // Positioned(
            //   right: -8,
            //   top: -8,
            //   child: IconButton.filled(
            //       style: IconButton.styleFrom(
            //         backgroundColor: Colors.red,
            //         fixedSize: const Size(32, 32),
            //         minimumSize: const Size(32, 32),
            //       ),
            //       icon: const Icon(Icons.remove, size: 16),
            //       onPressed: () {}),
            // )
          ],
        ),
      ),
    );
  }
}
