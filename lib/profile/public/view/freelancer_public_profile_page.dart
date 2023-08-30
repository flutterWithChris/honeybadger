import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/globals.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:outsourcedx/profile/portfolio/widgets/portfolio_card.dart';
import 'package:outsourcedx/profile/public/bloc/bloc/freelancer_public_profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../view/mobile/mobile_client_profile_page.dart';

class FreelancerPublicProfilePage extends StatelessWidget {
  final String userId;
  const FreelancerPublicProfilePage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          MobileSliverAppBar(),
          BlocBuilder<FreelancerPublicProfileBloc,
              FreelancerPublicProfileState>(
            builder: (context, state) {
              if (state is FreelancerPublicProfileError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 40.0),
                          const GutterSmall(),
                          const Text('Error Loading Profile!'),
                          const Gutter(),
                          FilledButton.icon(
                              onPressed: () {
                                //  context.read<FreelancerPublicProfileBloc>().add(LoadFreelancerPublicProfile(userId: state.userId!)));
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'))
                        ]),
                  ),
                );
              }
              if (state is FreelancerPublicProfileLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (state is FreelancerPublicProfileLoaded) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 36.0,
                              foregroundImage: CachedNetworkImageProvider(
                                  state.user.photoUrl!),
                              child: const Icon(Icons.person, size: 40)),
                          const Gutter(),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    '${state.user.firstName!} ${state.user.lastName!}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8.0,
                                  children: [
                                    Chip(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      labelPadding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 0.0),
                                      label: Text(
                                        state.user.title ?? 'No title set',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          MdiIcons.mapMarker,
                                          size: 12.0,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        const GutterTiny(),
                                        Text(
                                          state.user.address!
                                              .split(',')[2]
                                              .split(RegExp(r'\d+'))[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FilledButton.icon(
                          onPressed: () async {
                            Uri emailUri = Uri(
                                scheme: 'mailto',
                                path: '${state.user.email}',
                                query: encodeQueryParameters({
                                  'subject': 'Hey, ${state.user.firstName}!',
                                }));

                            await launchUrl(emailUri,
                                mode: LaunchMode.externalApplication);
                          },
                          icon: const Icon(Icons.email_rounded, size: 20.0),
                          label: const Text('Contact Me')),
                    ),
                    const GutterTiny(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: BlocBuilder<PortfolioBloc, PortfolioState>(
                        builder: (context, portfolioState) {
                          if (portfolioState is PortfolioError) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Portfolio',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                const GutterSmall(),
                                const Icon(Icons.error_outline, size: 40.0),
                                const GutterSmall(),
                                const Text('Error Loading Portfolio!'),
                                const Gutter(),
                                FilledButton.icon(
                                    onPressed: () {
                                      context.read<PortfolioBloc>().add(
                                          LoadPortfolio(
                                              userId: state.user.id!));
                                    },
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text('Retry'))
                              ],
                            );
                          }
                          if (portfolioState is PortfolioLoading) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Portfolio',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const GutterTiny(),
                                    ],
                                  ),
                                ),
                                const GutterSmall(),
                                const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              ],
                            );
                          }
                          if (portfolioState is PortfolioLoaded) {
                            if (portfolioState.projects.isEmpty) {
                              return const SizedBox();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const GutterSmall(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.folderOpenOutline,
                                        size: 18.0,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      const GutterSmall(),
                                      Text(
                                        'Portfolio',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const GutterTiny(),
                                    ],
                                  ),
                                ),
                                const GutterSmall(),
                                portfolioState.projects.isEmpty
                                    // Display placeholder portfolio card
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 180,
                                        child: ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              portfolioState.projects.length,
                                          itemBuilder: (context, index) {
                                            return SizedBox(
                                              height: 180,
                                              child: PortfolioCard(
                                                  project: portfolioState
                                                      .projects[index]),
                                            ).animate().slideX(
                                                begin: -1.0,
                                                end: 0.0,
                                                curve: Curves.easeOutSine,
                                                duration: const Duration(
                                                    milliseconds: 400));
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Gutter();
                                          },
                                        ),
                                      )
                              ],
                            );
                          }
                          return const Center(
                            child: Text('Something Went Wrong...'),
                          );
                        },
                      ),
                    ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.informationOutline,
                            size: 18.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const GutterSmall(),
                          Text(
                            'About Me',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const GutterTiny(),
                        ],
                      ),
                    ),
                    const GutterSmall(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        state.user.bio ?? 'No bio set',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.certificateOutline,
                            size: 18.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const GutterSmall(),
                          Text(
                            'Skills',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const GutterTiny(),
                        ],
                      ),
                    ),
                    const GutterSmall(),
                    if (state.user.skills != null &&
                        state.user.skills!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 40,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: state.user.skills!.length,
                            itemBuilder: (context, index) {
                              return Chip(
                                label: Text(state.user.skills![index].name!),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const GutterSmall();
                            },
                          ),
                        ),
                      ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.starOutline,
                            size: 18.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const GutterSmall(),
                          Text('Reviews',
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ),
                    state.user.reviews != null && state.user.reviews!.isNotEmpty
                        ? ReviewList(
                            user: state.user,
                          )
                        : // show empty state
                        const EmptyReviewsWidget(),
                  ]),
                );
              }
              return const SliverFillRemaining(
                child: Center(
                  child: Text('Something Went Wrong...'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
