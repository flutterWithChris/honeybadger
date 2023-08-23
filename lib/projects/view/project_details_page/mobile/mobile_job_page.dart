import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/globals.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/projects/bloc/projects_bloc.dart';
import 'package:outsourcedx/projects/view/widgets/project_status_chip.dart';
import 'package:outsourcedx/proposals/bloc/proposal_bloc.dart';
import 'package:outsourcedx/proposals/model/milestone.dart';
import 'package:outsourcedx/proposals/model/proposal.dart';
import 'package:outsourcedx/proposals/view/view_proposal/mobile/active_proposal_tab.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:list_ext/list_ext.dart';
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
  static Proposal? _proposal;

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
    _proposal = context.watch<ProposalBloc>().state.proposal;
    print('Proposal: ${_proposal?.status}');

    final NumberFormat numberFormat = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            MobileSliverAppBar(),
            _proposal == null ||
                    _proposal?.status == ProposalStatus.draft ||
                    _proposal?.status == null
                ? ProjectDetailsView(project: widget.project)
                : SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          child: Hero(
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
                        ),
                        const GutterSmall(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Hero(
                            tag: '${widget.project.id}-title',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(widget.project.title!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ),
                          ),
                        ),
                        const GutterSmall(),
                        if (_proposal != null)
                          TabBar(padding: EdgeInsets.zero, tabs: [
                            if (_proposal?.status == ProposalStatus.accepted)
                              const Tab(text: 'Active Proposal')
                            else
                              const Tab(
                                text: 'Proposal',
                              ),
                            const Tab(
                              text: 'Details',
                            ),
                          ]),
                      ],
                    ),
                  ),
            if (_proposal != null && _proposal?.status != ProposalStatus.draft)
              BlocBuilder<ProposalBloc, ProposalState>(
                builder: (context, state) {
                  if (state is ProposalsError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Error loading Proposal...'),
                            const Gutter(),
                            FilledButton.icon(
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                              onPressed: () {
                                context.read<ProposalBloc>().add(LoadProposal(
                                    widget.project.id!,
                                    context
                                        .read<ProfileBloc>()
                                        .state
                                        .user!
                                        .id!));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state.proposal == null) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  if (state is ProposalLoading) {
                    return SliverToBoxAdapter(
                      child: Center(
                        heightFactor: 1.0,
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 30.0),
                      ),
                    );
                  }
                  if (state is ProposalLoaded && state.proposal != null) {
                    return SliverFillRemaining(
                      child: TabBarView(children: [
                        FreelancerActiveProposalTab(
                            project: widget.project, proposal: state.proposal!),
                        ProjectDetailsTab(project: widget.project),
                      ]),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Center(
                        heightFactor: 1.0,
                        child: Text('Something Went Wrong...'),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsTab extends StatefulWidget {
  final Project project;

  const ProjectDetailsTab({super.key, required this.project});

  @override
  State<ProjectDetailsTab> createState() => _ProjectDetailsTabState();
}

class _ProjectDetailsTabState extends State<ProjectDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
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
                      convertIntToCurrency(widget.project.budget!.toInt()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
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
                  Text(parseEnumName(widget.project.projectType.toString()),
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            ProjectStatusChip(project: widget.project)
          ],
        ),
        const GutterSmall(),
        // Row(
        //   children: [
        //     widget.project.startDate != null
        //         ? Text.rich(
        //             TextSpan(
        //                 text: 'Start:  ',
        //                 children: [
        //                   TextSpan(
        //                       text: Jiffy.parseFromDateTime(
        //                               widget.project.startDate!)
        //                           .yMMMMd,
        //                       style: const TextStyle(
        //                           fontWeight: FontWeight.normal))
        //                 ],
        //                 style: const TextStyle(fontWeight: FontWeight.bold)),
        //           )
        //         : const Text.rich(
        //             TextSpan(
        //                 text: 'Start:  ',
        //                 children: [
        //                   TextSpan(
        //                       text: 'N/A',
        //                       style: TextStyle(fontWeight: FontWeight.normal))
        //                 ],
        //                 style: TextStyle(fontWeight: FontWeight.bold)),
        //           ),
        //     const GutterSmall(),
        //     widget.project.endDate != null
        //         ? Text.rich(
        //             TextSpan(
        //                 text: 'End:  ',
        //                 children: [
        //                   TextSpan(
        //                       text: Jiffy.parseFromDateTime(
        //                               widget.project.endDate!)
        //                           .yMMMMd,
        //                       style: const TextStyle(
        //                           fontWeight: FontWeight.normal))
        //                 ],
        //                 style: const TextStyle(fontWeight: FontWeight.bold)),
        //           )
        //         : const Text.rich(
        //             TextSpan(
        //                 text: 'End:  ',
        //                 children: [
        //                   TextSpan(
        //                       text: 'N/A',
        //                       style: TextStyle(fontWeight: FontWeight.normal))
        //                 ],
        //                 style: TextStyle(fontWeight: FontWeight.bold)),
        //           ),
        //   ],
        // ),
        //const GutterSmall(),
        Text('Project Description',
            style: Theme.of(context).textTheme.titleMedium),
        const GutterTiny(),
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
        if (widget.project.status == ProjectStatus.open)
          CreateProposalSection(
            project: widget.project,
          ),
        IgnorePointer(
          ignoring: widget.project.clientTotalSpend == null ? true : false,
          child: ExpansionTile(
            trailing: widget.project.clientTotalSpend != null
                ? null
                : const SizedBox(),
            tilePadding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: widget.project.clientProfilePicture != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                        widget.project.clientProfilePicture!),
                  )
                : const Icon(Icons.person_rounded),
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
                        if (widget.project.clientRating != null)
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
                                      '${widget.project.clientRating.toString()} ',
                                  children: [
                                    TextSpan(
                                        text:
                                            '(${widget.project.clientReviewCount.toString()})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                  ])),
                            ],
                          )
                        else
                          Text('No reviews yet',
                              style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MdiIcons.mapMarkerOutline, size: 14.0),
                        const GutterTiny(),
                        Text('${widget.project.clientLocation}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            children: [
              if (widget.project.clientTotalSpend != null)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 8.0, right: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total Spend:',
                              style: Theme.of(context).textTheme.titleSmall),
                          const GutterTiny(),
                          Text(
                              convertIntToCurrency(
                                  widget.project.clientTotalSpend!),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      if (widget.project.clientIndustry != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Industry:',
                                style: Theme.of(context).textTheme.titleSmall),
                            const GutterTiny(),
                            Text('${widget.project.clientIndustry}',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                    ],
                  ),
                ),
              const GutterTiny(),
            ],
          ),
        ),
        // Text('Client', style: Theme.of(context).textTheme.titleSmall),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.center,
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(MdiIcons.tools, size: 24.0),
          ),
          title: Text('Skills', style: Theme.of(context).textTheme.titleLarge),
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
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
        if (widget.project.tags != null && widget.project.tags!.isNotEmpty)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            expandedAlignment: Alignment.center,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(MdiIcons.tagText, size: 24.0),
            ),
            title: Text('Tags', style: Theme.of(context).textTheme.titleLarge),
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
    );
  }
}

class ProjectDetailsView extends StatefulWidget {
  final Project project;

  const ProjectDetailsView({super.key, required this.project});

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
          delegate: SliverChildListDelegate([
        Column(
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
                          convertIntToCurrency(widget.project.budget!.toInt()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                      Text(parseEnumName(widget.project.projectType.toString()),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                ProjectStatusChip(project: widget.project)
              ],
            ),
            const Gutter(),
            Text('Project Description',
                style: Theme.of(context).textTheme.titleMedium),
            const GutterTiny(),
            Hero(
              tag: '${widget.project.id}-description',
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                child: Text(widget.project.description!,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CreateProposalSection(
                project: widget.project,
              ),
            ),
            IgnorePointer(
              ignoring: widget.project.clientTotalSpend == null ? true : false,
              child: ExpansionTile(
                trailing: widget.project.clientTotalSpend != null
                    ? null
                    : const SizedBox(),
                tilePadding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).colorScheme.surface,
                leading: widget.project.clientProfilePicture != null
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.project.clientProfilePicture!),
                      )
                    : const Icon(Icons.person_rounded),
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
                            if (widget.project.clientRating != null)
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
                                          '${widget.project.clientRating.toString()} ',
                                      children: [
                                        TextSpan(
                                            text:
                                                '(${widget.project.clientReviewCount.toString()})',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall)
                                      ])),
                                ],
                              )
                            else
                              Text('No reviews yet',
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(MdiIcons.mapMarkerOutline, size: 14.0),
                            const GutterTiny(),
                            Text('${widget.project.clientLocation}',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  if (widget.project.clientTotalSpend != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 8.0, right: 16.0),
                      child: Wrap(
                        spacing: 8.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Total Spend:',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const GutterTiny(),
                              Text(
                                  convertIntToCurrency(
                                      widget.project.clientTotalSpend!),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          if (widget.project.clientIndustry != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Industry:',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                const GutterTiny(),
                                Text('${widget.project.clientIndustry}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                        ],
                      ),
                    ),
                  const GutterTiny(),
                ],
              ),
            ),
            // Text('Client', style: Theme.of(context).textTheme.titleSmall),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              expandedAlignment: Alignment.center,
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(MdiIcons.tools, size: 24.0),
              ),
              title:
                  Text('Skills', style: Theme.of(context).textTheme.titleLarge),
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
            if (widget.project.tags != null && widget.project.tags!.isNotEmpty)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                expandedAlignment: Alignment.center,
                backgroundColor: Theme.of(context).colorScheme.surface,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(MdiIcons.tagText, size: 24.0),
                ),
                title:
                    Text('Tags', style: Theme.of(context).textTheme.titleLarge),
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
      ])),
    );
  }
}

class FreelancerActiveProposalTab extends StatefulWidget {
  final Project project;
  final Proposal proposal;
  const FreelancerActiveProposalTab(
      {super.key, required this.project, required this.proposal});

  @override
  State<FreelancerActiveProposalTab> createState() =>
      _FreelancerActiveProposalTabState();
}

class _FreelancerActiveProposalTabState
    extends State<FreelancerActiveProposalTab> {
  @override
  Widget build(BuildContext context) {
    Milestone activeMilestone = widget.proposal.activeMilestoneId != null
        ? widget.proposal.milestones!.firstWhere(
            (element) => element.id == widget.proposal.activeMilestoneId)
        : widget.proposal.milestones!.first;
    bool activeMilestoneWorkSubmitted = activeMilestone.workSubmission != null;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timeline),
                  const Gutter(),
                  Text('Milestones',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text.rich(
                  TextSpan(
                      text: 'Total Budget: ',
                      children: [
                        TextSpan(
                          text: convertIntToCurrency(
                              widget.project.budget!.toInt()),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),

              // Text('Status: ',
              //     style: Theme.of(context)
              //         .textTheme
              //         .titleSmall
              //         ?.copyWith(fontWeight: FontWeight.bold)),
              // const GutterTiny(),
            ],
          ),
          MilestoneTimeline(proposal: widget.proposal),
          const GutterTiny(),
          if (widget.project.status == ProjectStatus.inProgress &&
              widget.proposal.status == ProposalStatus.accepted)
            if (activeMilestoneWorkSubmitted && activeMilestone.isPaid != true)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        // height: 80,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.fileCheck, size: 20.0),
                                      const Gutter(),
                                      Text('Work Submitted for Review',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ],
                                  ),
                                  const GutterSmall(),
                                  Text(
                                      'You have submitted work for review. Please wait for your client to review your work and request payment.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const Gutter(),
                ],
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: Icon(MdiIcons.progressCheck),
                          label: const Text('Submit Work & Request Payment'),
                          onPressed: () {
                            context.push(
                                '/project/${widget.project.id}/submit-work',
                                extra: {
                                  0: widget.project,
                                  1: widget.proposal,
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Gutter(),
                ],
              ),
          Text('Description', style: Theme.of(context).textTheme.titleLarge),
          const GutterSmall(),
          Text(widget.proposal.description!),
        ],
      ),
    );
  }
}

class SubmitWorkDialog extends StatefulWidget {
  const SubmitWorkDialog({super.key});

  @override
  State<SubmitWorkDialog> createState() => _SubmitWorkDialogState();
}

class _SubmitWorkDialogState extends State<SubmitWorkDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlFieldController = TextEditingController();
  final List<PlatformFile> _files = [];
  final List<PlatformFile> _images = [];
  bool filesUploading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static Project? project;

  @override
  Widget build(BuildContext context) {
    project = context.watch<ProjectsBloc>().state.projects?.firstWhereOrNull(
        (element) =>
            element.id ==
            context.watch<ProposalBloc>().state.proposal?.projectId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Work'),
      ),
      body:
          BlocConsumer<ProposalBloc, ProposalState>(listener: (context, state) {
        if (state is ProposalUpdated) {
          context.pop();
        }
      }, builder: (context, state) {
        if (state is ProposalsError) {
          return const Center(
            child: Text('Error loading Proposal...'),
          );
        }
        if (state is ProposalLoading || project == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                heightFactor: 1.0,
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Theme.of(context).colorScheme.onSurface, size: 30.0),
              ),
            ],
          );
        }
        if (state is ProposalLoaded && project != null) {
          print('Project: $project');
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Text('Submit Work', style: Theme.of(context).textTheme.titleLarge),
                // const GutterSmall(),
                Text(
                    'You can submit work to your client for review and request payment for the milestone.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Gutter(),
                Text('Work Description',
                    style: Theme.of(context).textTheme.titleMedium),
                const GutterSmall(),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 2,
                  maxLines: 7,
                  decoration: const InputDecoration(
                      hintText:
                          'Enter a description of the work you are submitting'),
                ),
                const GutterSmall(),
                Text('URL', style: Theme.of(context).textTheme.titleMedium),
                const GutterSmall(),
                TextFormField(
                  textCapitalization: TextCapitalization.none,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (Uri.parse(value).isAbsolute == false) {
                        return 'Please enter a valid URL. Must start with https://';
                      }
                    }
                    return null;
                  },
                  controller: _urlFieldController,
                  decoration: const InputDecoration(
                      hintText:
                          'e.g. https://github.com/username/project-name'),
                ),
                Row(
                  children: [
                    Text('Attachments',
                        style: Theme.of(context).textTheme.titleMedium),
                    const GutterTiny(),
                    if (filesUploading == true)
                      Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: LoadingAnimationWidget.discreteCircle(
                          size: 14.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    else
                      IconButton(
                        onPressed: () async {
                          await showAttachmentTypeSheet(context);
                        },
                        icon: const Icon(Icons.add_circle_rounded),
                      ),
                  ],
                ),
                if (_files.isEmpty && _images.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await showAttachmentTypeSheet(context);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                const GutterSmall(),
                                Text('Add Files',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                if (_images.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 16.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image.file(
                                        File(_images[index].path!),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _images.removeAt(index);
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                if (_files.isNotEmpty || _images.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Text('Files',
                      //         style: Theme.of(context).textTheme.titleMedium),
                      //     const GutterTiny(),
                      //     IconButton(
                      //       onPressed: () async {
                      //         await showAttachmentTypeSheet(context);
                      //       },
                      //       icon: const Icon(Icons.add_circle_rounded),
                      //     ),
                      //   ],
                      // ),
                      if (_files.isNotEmpty)
                        Column(
                          children: [
                            for (var file in _files)
                              Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        label: 'Delete',
                                        onPressed: (context) {
                                          setState(() {
                                            _files.remove(file);
                                          });
                                        },
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_outline,
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    child: ListTile(
                                      leading: file.extension == 'pdf'
                                          ? const Icon(Icons.picture_as_pdf)
                                          : const Icon(Icons.file_present),
                                      title: Text(
                                        file.name ?? 'No title',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(formatBytes(file.size, 1)),
                                      trailing: IconButton(
                                        style: IconButton.styleFrom(
                                            //   minimumSize: Size.zero,
                                            // fixedSize: const Size(24, 24),
                                            padding: EdgeInsets.zero),
                                        onPressed: () {
                                          setState(() {
                                            _files.remove(file);
                                          });
                                        },
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                    ],
                  ),
                const Gutter(),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: Icon(MdiIcons.progressCheck),
                        label: const Text('Submit Work & Request Payment'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProposalBloc>().add(SubmitWork(
                                  proposal: state.proposal!,
                                  milestone: state.proposal!.milestones!
                                      .where((element) =>
                                          element.id ==
                                          state.proposal!.activeMilestoneId)
                                      .first,
                                  description:
                                      _descriptionController.value.text,
                                  files: _files,
                                  images: _images,
                                  urls: [_urlFieldController.value.text],
                                ));
                          } else {
                            scaffoldKey.currentState!
                                .showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red,
                                    content: Row(
                                      children: [
                                        Icon(Icons.error,
                                            color: Colors.white, size: 20.0),
                                        GutterSmall(),
                                        Text('Please correct any errors!',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    duration: Duration(seconds: 2)));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      }),
    );
  }

  Future<void> showAttachmentTypeSheet(BuildContext context) async {
    final FilePickerResult? file = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      onFileLoading: (status) {
        if (status == FilePickerStatus.picking) {
          setState(() {
            filesUploading = true;
          });
        } else if (status == FilePickerStatus.done) {
          setState(() {
            filesUploading = false;
          });
        }
      },
    );
    if (file != null) {
      // If any files are images, add them to the images list
      // If any files are not images, add them to the files list
      if (file.files.any((element) =>
          element.extension == 'jpg' ||
          element.extension == 'jpeg' ||
          element.extension == 'png')) {
        setState(() {
          _urlFieldController.value.text.isNotEmpty
              ? _images.addAll(file.files
                  .where((element) =>
                      element.extension == 'jpg' ||
                      element.extension == 'jpeg' ||
                      element.extension == 'png')
                  .toList())
              : _images.addAll(file.files
                  .where((element) =>
                      element.extension == 'jpg' ||
                      element.extension == 'jpeg' ||
                      element.extension == 'png')
                  .toList());
          file.files.removeWhere((element) =>
              element.extension == 'jpg' ||
              element.extension == 'jpeg' ||
              element.extension == 'png');
          if (file.files.isNotEmpty) {
            _files.addAll(file.files);
          }
        });
      } else {
        setState(() {
          _files.addAll(file.files);
        });
      }
    } else {
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 20.0),
              GutterSmall(),
              Text('No file selected.'),
            ],
          ),
          duration: Duration(seconds: 2)));
    }
  }
}

class CreateProposalSection extends StatefulWidget {
  final Project project;
  const CreateProposalSection({
    required this.project,
    super.key,
  });

  @override
  State<CreateProposalSection> createState() => _CreateProposalSectionState();
}

class _CreateProposalSectionState extends State<CreateProposalSection> {
  final TextEditingController _proposalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalBloc, ProposalState>(builder: (context, state) {
      if ((state is ProposalStarted ||
              state is ProposalSent ||
              state is ProposalLoaded) &&
          _proposalController.value.text == '') {
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
                        widget.project.projectType == ProjectType.fixed
                            ? Flexible(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    controller: _expansionTileController,
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
                                            if (_expansionTileController
                                                    .isExpanded ==
                                                false) {
                                              _expansionTileController.expand();
                                            }
                                            context.read<ProposalBloc>().add(
                                                AddMilestone(Milestone(
                                                    id: const Uuid().v4(),
                                                    projectId:
                                                        widget.project.id!,
                                                    funded: false)));
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
                            Expanded(
                              child: FilledButton.icon(
                                  onPressed: () async {
                                    if (_proposalController
                                        .value.text.isEmpty) {
                                      scaffoldKey.currentState!.showSnackBar(
                                          const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Row(
                                                children: [
                                                  Icon(Icons.error,
                                                      color: Colors.red,
                                                      size: 20.0),
                                                  GutterSmall(),
                                                  Text(
                                                      'Please enter a proposal.'),
                                                ],
                                              ),
                                              duration: Duration(seconds: 2)));
                                      return;
                                    }
                                    if (state.proposal?.milestones == null ||
                                        state.proposal!.milestones!.isEmpty) {
                                      scaffoldKey.currentState!.showSnackBar(
                                          const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Row(
                                                children: [
                                                  Icon(Icons.error,
                                                      color: Colors.red,
                                                      size: 20.0),
                                                  GutterSmall(),
                                                  Text(
                                                      'Please add at least one milestone.'),
                                                ],
                                              ),
                                              duration: Duration(seconds: 2)));
                                      return;
                                    }
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
                  : (state is ProposalLoaded && state.proposal != null) ||
                          state is ProposalSent
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.project.projectType == ProjectType.fixed
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
                                            widget.project.id!,
                                            Proposal(
                                              projectId: widget.project.id!,
                                              description:
                                                  _proposalController.text,
                                              freelancerId: context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user!
                                                  .id,
                                              freelancerStripeAccountId: context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user!
                                                  .stripeAccountId,
                                              freelancerName:
                                                  '${context.read<ProfileBloc>().state.user!.firstName} ${context.read<ProfileBloc>().state.user!.lastName}',
                                              clientId: widget.project.clientId,
                                              clientName:
                                                  widget.project.clientName,
                                              status: ProposalStatus.draft,
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
