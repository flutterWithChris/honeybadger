import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MobileViewProposalPage extends StatelessWidget {
  final Proposal proposal;
  const MobileViewProposalPage({super.key, required this.proposal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            const MobileSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      'Proposal from ${proposal.freelancerName!.split(' ').first}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const GutterTiny(),
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
                    Text(
                      proposal.description!,
                    ),
                    // Freelancer profile card
                    const Gutter(),
                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
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
                                    image: CachedNetworkImageProvider(
                                        proposal.freelancerAvatar!),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const GutterSmall(),
                                      SizedBox(
                                        height: 24.0,
                                        child: FittedBox(
                                          child: Chip(
                                            side: BorderSide.none,
                                            visualDensity:
                                                VisualDensity.compact,
                                            backgroundColor: Theme.of(context)
                                                .indicatorColor,
                                            padding: EdgeInsets.zero,
                                            labelPadding: const EdgeInsets.only(
                                                right: 12.0),
                                            avatar: const Icon(Icons.star,
                                                color: Colors.amber),
                                            label: Text(
                                              '4.9',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.work_rounded,
                                            size: 14.0),
                                        const GutterSmall(),
                                        Text(
                                          '4 jobs completed',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
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
                    ),
                    const Gutter(),
                    Row(
                      children: [
                        const Icon(Icons.timeline),
                        const Gutter(),
                        Text('Milestones',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    MilestoneTimeline(proposal: proposal),
                    const GutterTiny(),
                    BlocBuilder<PaymentsBloc, PaymentsState>(
                      builder: (context, state) {
                        if (state is PaymentsError) {
                          return FilledButton.icon(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.red),
                            icon: Icon(MdiIcons.alertCircle),
                            label: const Text('Reload Payments'),
                            onPressed: () {
                              context.read<PaymentsBloc>().add(LoadPayments(
                                  user:
                                      context.read<ProfileBloc>().state.user!));
                            },
                          );
                        }
                        if (state is PaymentsLoading) {
                          return FilledButton.icon(
                            icon: LoadingAnimationWidget.staggeredDotsWave(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                        return FilledButton.icon(
                          icon: Icon(MdiIcons.cashCheck),
                          label: const Text('Accept & Fund Milestone'),
                          onPressed: () {
                            context.read<PaymentsBloc>().add(SendPayment(
                                amount: proposal.milestones!.first.amount!,
                                description: 'Milestone: ${proposal.title}',
                                client: context.read<ProfileBloc>().state.user!,
                                freelancerId: proposal.freelancerId!,
                                freelancerStripeAccountId:
                                    proposal.freelancerStripeAccountId!,
                                proposal: proposal,
                                context: context));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
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
                  color: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 5.0),
                  child: Text(
                    '${i + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ),
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(6),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(left: 16.0, bottom: 0),
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
                    SizedBox(
                      height: 32.0,
                      child: FittedBox(
                        child: Chip(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 0.0),
                          side: BorderSide.none,
                          backgroundColor: Theme.of(context).primaryColor,
                          label: Text(
                            convertIntToCurrency(
                              proposal.milestones![i].amount!,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
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
                    proposal.milestones![i].description ??
                        'Here\'s an example description of what we will achieve in this milestone. What will I deliver to you?',
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
