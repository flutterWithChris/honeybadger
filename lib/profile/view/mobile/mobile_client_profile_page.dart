import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileClientProfilePage extends StatelessWidget {
  const MobileClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = User(
        firstName: 'Christian',
        lastName: 'Vergara',
        title: 'Mobile App Developer',
        city: 'Brooklyn',
        country: 'United States',
        state: 'New York',
        hourlyRate: 50,
        rating: 4.7,
        bio:
            'I am a mobile app developer with 5 years of experience in developing mobile applications for both Android and iOS. I have worked with clients from all over the world and have developed a wide range of mobile apps. I have worked with clients from all over the world and have developed a wide range of mobile apps.',
        photoUrl:
            'https://www.upwork.com/profile-portraits/c1rFySS3sCUYKZbae39D0j1ENTk1Q68MI2fCkWY56buZZ9_EEH1NIOdj02eZ25D2co');

    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
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
                          const CircleAvatar(
                              radius: 40,
                              foregroundImage: CachedNetworkImageProvider(
                                  'https://www.upwork.com/profile-portraits/c1rFySS3sCUYKZbae39D0j1ENTk1Q68MI2fCkWY56buZZ9_EEH1NIOdj02eZ25D2co'),
                              child: Icon(Icons.person, size: 40)),
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
                                    children: [
                                      Icon(
                                        MdiIcons.mapMarker,
                                        size: 14.0,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      const GutterTiny(),
                                      Text(
                                        '${state.user.state}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Communication Preferences',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Edit',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                        'I am a mobile app developer with 5 years of experience in developing mobile applications for both Android and iOS. I have worked with clients from all over the world and have developed a wide range of mobile apps. I have worked with clients from all over the world and have developed a wide range of mobile apps.',
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
                    user.reviews != null && user.reviews!.isNotEmpty
                        ? ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: user.reviews!.map((review) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // TODO: Make this the author image
                                        CircleAvatar(
                                          radius: 20,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                                  review.authorId!),
                                        ),
                                        const Gutter(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // TODO: Make this the author name
                                            Text(
                                              review.authorId!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              review.createdAt!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Gutter(),
                                    Text(
                                      review.review!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const Gutter(),
                                    Row(
                                      children: [
                                        Text(
                                          'Job: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        // TODO: Make this the job title
                                        Text(
                                          review.authorId!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const Gutter(),
                                    Row(
                                      children: [
                                        Text(
                                          'Rating: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          review.rating.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        : // show empty state
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
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
                          ),
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
