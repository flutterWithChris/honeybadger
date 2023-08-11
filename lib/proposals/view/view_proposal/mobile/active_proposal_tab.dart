import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/proposals/bloc/proposal_bloc.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:list_ext/list_ext.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ActiveProposalTab extends StatelessWidget {
  final Proposal proposal;
  const ActiveProposalTab({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    proposal.milestones!.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    print('Proposal: ${proposal.id}');
    print(context.watch<ProposalBloc>().state.proposals.toString());
    Proposal? currentProposal = context
        .watch<ProposalBloc>()
        .state
        .proposals
        ?.firstWhereOrNull((element) => element.id == proposal.id);
    print('Current proposal: $currentProposal');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FreelancerInfoCard(proposal: proposal),
          const Gutter(),
          Row(
            children: [
              const Icon(Icons.timeline),
              const Gutter(),
              Text('Milestones', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          MilestoneTimeline(proposal: currentProposal ?? proposal),
          BlocConsumer<PaymentsBloc, PaymentsState>(
            listener: (context, state) {
              if (state is PaymentSent) {
                context.read<ProposalBloc>().add(AcceptProposal(proposal));
                context
                    .read<ProposalBloc>()
                    .add(FundMilestone(proposal.milestones!.first, proposal));
                scaffoldKey.currentState!.showSnackBar(
                  const SnackBar(
                    content: Text('Payment sent!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PaymentsError) {
                return FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(MdiIcons.alertCircle),
                  label: const Text('Reload Payments'),
                  onPressed: () {
                    context.read<PaymentsBloc>().add(LoadPayments(
                        user: context.read<ProfileBloc>().state.user!));
                  },
                );
              }
              if (state is PaymentsLoading) {
                return FilledButton.icon(
                  icon: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 18.0),
                  label: const Text('Loading...'),
                  onPressed: () {
                    scaffoldKey.currentState!.showSnackBar(
                      const SnackBar(
                        content: Text('Payments are loading...'),
                      ),
                    );
                  },
                );
              }
              bool milestoneWaitingForPayment = proposal.milestones!.any(
                  (element) =>
                      element.funded == true && element.isPaid != true);
              if (milestoneWaitingForPayment) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.green),
                            icon: const Icon(
                              Icons.lock_open_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            label: const Text(
                              'Release Milestone Payment',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              context.read<PaymentsBloc>().add(SendPayment(
                                  amount: proposal.milestones!.first.amount!,
                                  description: 'Milestone: ${proposal.title}',
                                  client:
                                      context.read<ProfileBloc>().state.user!,
                                  freelancerId: proposal.freelancerId!,
                                  freelancerStripeAccountId:
                                      proposal.freelancerStripeAccountId!,
                                  proposal: proposal,
                                  context: context));
                            },
                          ),
                        ),
                      ],
                    ),
                    // const GutterTiny(),
                    // Text(
                    //   'A 5% fee will be added',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodySmall
                    //       ?.copyWith(
                    //         fontStyle: FontStyle.italic,
                    //       ),
                    // ),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            icon: Icon(MdiIcons.cashCheck),
                            label: const Text('Accept & Fund First Milestone'),
                            onPressed: () {
                              context.read<PaymentsBloc>().add(SendPayment(
                                  amount: proposal.milestones!.first.amount!,
                                  description: 'Milestone: ${proposal.title}',
                                  client:
                                      context.read<ProfileBloc>().state.user!,
                                  freelancerId: proposal.freelancerId!,
                                  freelancerStripeAccountId:
                                      proposal.freelancerStripeAccountId!,
                                  proposal: proposal,
                                  context: context));
                            },
                          ),
                        ),
                      ],
                    ),
                    const GutterTiny(),
                    Text(
                      'A 5% fee will be added',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                );
              }
            },
          ),
          const Gutter(),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Budget: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: convertIntToCurrency(proposal.budgetTotal!),
                ),
              ],
            ),
          ),
          const GutterSmall(),
          // Freelancer profile card
          Text(
            proposal.description!,
          ),

          const GutterTiny(),
        ],
      ),
    );
  }
}

class FreelancerInfoCard extends StatelessWidget {
  const FreelancerInfoCard({
    super.key,
    required this.proposal,
  });

  final Proposal proposal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(proposal.freelancerAvatar!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gutter(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        proposal.freelancerName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const GutterSmall(),
                      SizedBox(
                        height: 24.0,
                        child: FittedBox(
                          child: Chip(
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Theme.of(context).indicatorColor,
                            padding: EdgeInsets.zero,
                            labelPadding: const EdgeInsets.only(right: 12.0),
                            avatar: const Icon(Icons.star, color: Colors.amber),
                            label: Text(
                              '4.9',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    // 'Member since ${Jiffy(proposal.freelancerMemberSince).format('MMM do, yyyy')}',
                    'Member Since ${Jiffy.parseFromDateTime(DateTime(2023, 8, 8)).yMMMd}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Row(
                      children: [
                        const Icon(Icons.work_rounded, size: 14.0),
                        const GutterSmall(),
                        Text(
                          '4 jobs completed',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded)
            ],
          ),
        ),
      ),
    );
  }
}

class MilestoneTimeline extends StatelessWidget {
  const MilestoneTimeline({
    super.key,
    required this.proposal,
  });

  final Proposal proposal;

  @override
  Widget build(BuildContext context) {
    // Order milestones by date
    proposal.milestones!.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < proposal.milestones!.length; i++)
          TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: i == 0,
            isLast: i == proposal.milestones!.length - 1,
            indicatorStyle: IndicatorStyle(
              indicatorXY: 0.35,
              width: 18,
              indicator: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: proposal.milestones![i].funded == true
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
                child: proposal.milestones![i].isPaid == true
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Icon(MdiIcons.checkBold,
                            size: 12.0, color: Colors.white),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 5.3),
                        child: Text(
                          '${i + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: proposal.milestones![i].isPaid ==
                                              true ||
                                          proposal.milestones![i].funded == true
                                      ? Colors.white
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 6.0),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 8.0, bottom: 0),
                childrenPadding:
                    const EdgeInsets.only(left: 16.0, bottom: 16.0),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${proposal.milestones![i].title} ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32.0,
                          child: FittedBox(
                            child: Chip(
                              visualDensity: VisualDensity.compact,
                              padding: proposal.milestones![i].funded != true &&
                                      proposal.milestones![i].isPaid != true
                                  ? const EdgeInsets.only(left: 8.0, right: 8.0)
                                  : const EdgeInsets.only(
                                      left: 4.0, right: 8.0),
                              labelPadding:
                                  proposal.milestones![i].funded != true &&
                                          proposal.milestones![i].isPaid != true
                                      ? const EdgeInsets.only(right: 0.0)
                                      : const EdgeInsets.only(
                                          right: 4.0,
                                        ),
                              side: BorderSide.none,
                              backgroundColor:
                                  proposal.milestones![i].funded == true
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                              avatar: proposal.milestones![i].funded == true
                                  ? proposal.milestones![i].workSubmission !=
                                              null &&
                                          proposal.milestones![i].isPaid != true
                                      ? Icon(MdiIcons.fileCheck)
                                      : proposal.milestones![i].isPaid != true
                                          ? Icon(MdiIcons.cashCheck)
                                          : Icon(MdiIcons.checkBold)
                                  : null,
                              label: Text(
                                proposal.milestones![i].funded == true
                                    ? proposal.milestones![i].workSubmission !=
                                                null &&
                                            proposal.milestones![i].isPaid !=
                                                true
                                        ? 'Awaiting Review'
                                        : proposal.milestones![i].isPaid != true
                                            ? 'Funded'
                                            : 'Completed'
                                    : convertIntToCurrency(
                                        proposal.milestones![i].amount!,
                                      ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          proposal.milestones![i].funded == true
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 12, color: Theme.of(context).primaryColor),
                    const GutterSmall(),
                    Text(
                      Jiffy.parseFromDateTime(proposal.milestones![i].dueDate!)
                              .MMMMEEEEd ??
                          '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                children: [
                  Text(
                    //  proposal.milestones![i].description ??
                    // 'Here\'s an example description of what we will achieve in this milestone. What will I deliver to you?',
                    i == 0
                        ? 'This marks the start of the project. I will begin working towards the next milestone.'
                        : i == 1
                            ? 'All screens & visual elements complete. Using mock data to simulate functionality.'
                            : i == 2
                                ? 'Database is built and connected to the app. Displaying real data & connecting to APIs.'
                                : i == 3
                                    ? 'Begin beta testing the app for bugs & issues. While preparing for release to the app stores.'
                                    : 'Null',

                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
