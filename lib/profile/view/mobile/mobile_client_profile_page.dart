import 'package:outsourcedx/profile/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileClientProfilePage extends StatelessWidget {
  const MobileClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          MobileSliverAppBar(),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileError) {
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
                                context.read<ProfileBloc>().add(LoadProfile());
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'))
                        ]),
                  ),
                );
              }
              if (state is ProfileLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (state is ProfileLoaded) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              foregroundImage: CachedNetworkImageProvider(
                                  state.user.photoUrl!),
                              child: const Icon(Icons.person, size: 40)),
                          const Gutter(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  '${state.user.firstName!} ${state.user.lastName!}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 34.0,
                                    child: FittedBox(
                                      child: Chip(
                                        visualDensity: VisualDensity.compact,
                                        label: Text(
                                          state.user.title ?? 'No title set',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gutter(),
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
                        ],
                      ),
                    ),

                    // Communication Preferences
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'Communication Preferences',
                    //         style: Theme.of(context).textTheme.titleLarge,
                    //       ),
                    //       const Spacer(),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           'Edit',
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .bodyMedium
                    //               ?.copyWith(color: Colors.blue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'About Me',
                        style: Theme.of(context).textTheme.titleLarge,
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
                      child: Text(
                        'Reviews',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    state.user.reviews != null && state.user.reviews!.isNotEmpty
                        ? ReviewList(
                            user: state.user,
                          )
                        : // show empty state
                        const EmptyReviewsWidget(),
                    const Gutter(),
                    // if (user.skills != null && user.skills!.isNotEmpty)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: SizedBox(
                    //       height: 40,
                    //       child: ListView.separated(
                    //         shrinkWrap: true,
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: user.skills!.length,
                    //         itemBuilder: (context, index) {
                    //           return Chip(
                    //             label: Text(user.skills![index]),
                    //           );
                    //         },
                    //         separatorBuilder: (context, index) {
                    //           return const GutterSmall();
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    const Gutter(),
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

class EmptyReviewsWidget extends StatelessWidget {
  const EmptyReviewsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Reviews Yet',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gutter(),
          Text(
            'This user has no reviews yet.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  final User user;
  const ReviewList({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: user.reviews!.map((review) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Show star rating
              Row(
                children: [
                  Row(
                    children: List.generate(
                      review.rating!,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.0,
                      ),
                    ),
                  ),
                  const GutterSmall(),
                  Text(
                    '${review.rating}.0',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const GutterSmall(),
              Row(
                children: [
                  Text(
                    'Job: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  // TODO: Make this the job title
                  Text(
                    review.projectTitle!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const GutterSmall(),
              Text(
                '"${review.review!}"',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Gutter(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // TODO: Make this the author image
                      CircleAvatar(
                        radius: 24,
                        foregroundImage:
                            CachedNetworkImageProvider(review.authorPhoto!),
                      ),
                      const Gutter(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO: Make this the author name
                          Text(
                            review.authorName!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            review.authorTitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        Jiffy.parseFromDateTime(
                                DateTime.parse(review.createdAt ?? ''))
                            .fromNow(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const Gutter(),

              const Divider(),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class FreelancerActionButtons extends StatelessWidget {
  const FreelancerActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, shape: const CircleBorder()),
              onPressed: () {},
              child: Icon(
                MdiIcons.emailOutline,
                size: 20.0,
              )),
        ),
        const Gutter(),
        Expanded(
          flex: 7,
          child: FilledButton(
            onPressed: () {},
            child: const Text('Hire Me'),
          ),
        ),
      ],
    );
  }
}
