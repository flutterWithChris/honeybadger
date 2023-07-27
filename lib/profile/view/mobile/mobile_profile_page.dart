import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/jobs/dialogs/add_project_dialog.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileProfilePage extends StatelessWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = User(
        firstName: 'Christian',
        lastName: 'Vergara',
        title: 'Mobile App Developer',
        city: 'Brooklyn',
        country: 'United States',
        state: 'New York',
        skills: ['Flutter', 'Dart', 'Firebase', 'NodeJS', 'MongoDB'],
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
                    child: Column(children: [
                      const Icon(Icons.error_outline, size: 40.0),
                      const GutterSmall(),
                      const Text('Error Loading Profile!'),
                      ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(LoadProfile());
                          },
                          child: const Text('Retry'))
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
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
                                  Text(
                                    state.user.title ?? 'No title set',
                                  ),
                                ],
                              ),
                              const GutterTiny(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                      height: 40.0,
                                      child: FittedBox(
                                        child: Chip(
                                          padding: const EdgeInsets.all(0.0),
                                          label: Row(
                                            children: [
                                              Icon(
                                                MdiIcons.mapMarker,
                                                size: 14.0,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              const GutterSmall(),
                                              Text(
                                                '${state.user.state}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gutter(),
                                  Flexible(
                                    child: SizedBox(
                                      height: 40.0,
                                      child: FittedBox(
                                        child: Chip(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          side: BorderSide.none,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                MdiIcons.trophyAward,
                                                size: 14.0,
                                                color: Colors.white,
                                              ),
                                              const GutterTiny(),
                                              Text('Top Rated',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // BlocBuilder<PaymentsBloc, PaymentsState>(
                    //   builder: (context, state) {
                    //     if (state is PaymentsError) {
                    //       return
                    //     } if (state is PaymentsLoading) {

                    //     }
                    //     if (state is PaymentsLoaded) {
                    //       return const FractionallySizedBox(
                    //         widthFactor: 0.8,
                    //         child: FreelancerActionButtons(),
                    //       );
                    //     }
                    //     return const Center(child: Text('Something Went Wrong...'),);
                    //   },
                    // ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Portfolio',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 160,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: user.skills!.length,
                          itemBuilder: (context, index) {
                            return AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16.0),
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AddProjectDialog());
                                      },
                                      child: const Center(
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )),
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
                      child: Text(
                        'About Me',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const GutterSmall(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'I am a mobile app developer with 5 years of experience in developing mobile applications for both Android and iOS. I have worked with clients from all over the world and have developed a wide range of mobile apps. I have worked with clients from all over the world and have developed a wide range of mobile apps.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Skills',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Gutter(),
                    if (user.skills != null && user.skills!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: 40,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: user.skills!.length,
                            itemBuilder: (context, index) {
                              return Chip(
                                label: Text(user.skills![index]),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const GutterSmall();
                            },
                          ),
                        ),
                      ),
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
