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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary,
                                              ),
                                              const GutterTiny(),
                                              Text('Top Rated',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                      )),
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
                    // const Gutter(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Portfolio',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const GutterTiny(),
                          IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AddProjectDialog());
                              },
                              icon: const Icon(Icons.add_circle_rounded))
                        ],
                      ),
                    ),
                    const GutterSmall(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: SizedBox(
                        height: 180,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            List<String> photoLinks = [
                              'https://www.upwork.com/att/download/portfolio/persons/uid/1109088236987375616/profile/projects/files/544fded9-0423-43ab-8a29-78c920bda193',
                              'https://www.upwork.com/att/download/portfolio/persons/uid/1109088236987375616/profile/projects/files/0ccd34d7-2a12-4a18-b532-e1000d0015d2',
                              'https://www.upwork.com/att/download/portfolio/persons/uid/1109088236987375616/profile/projects/files/ac1b3bed-bf87-47df-8edf-c8cf35a58178',
                              'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/db9f1e2a-b618-4b71-8898-64af579fc9ce/TonyLor_CoffeeShopMarket_FINAL01+-+011923+%281%29.jpg?format=750w',
                              'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/7f4a9c80-be3f-4bc8-91ee-efc5055e2f3d/1.jpg?format=750w',
                              'https://www.beachwelcomecenter.com/wp-content/uploads/crabb-bills_building-1_WEB-16x9-1.jpg',
                              'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/1da6ed99-03f3-43bb-9d03-6c13f6110550/3.jpg?format=750w'
                                  'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/b1667257-b7c7-4e4e-932e-f31c1902e30f/6.png?format=750w',
                              'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/6d859112-15bf-4ebc-9ed8-98c28acde02c/1.jpg?format=750w',
                              'https://images.squarespace-cdn.com/content/v1/630dd25ca749cb7575f60864/1664597665853-HJBS77OU03199C2CD6W8/1_View01a.png?format=1500w',
                            ];
                            return Container(
                              height: 180,
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //   image: CachedNetworkImageProvider(
                                //     photoLinks[index],
                                //   ),
                                //   fit: BoxFit.cover,
                                // ),
                                // color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(16.0),
                                    onTap: () async {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: CachedNetworkImage(
                                        imageUrl: photoLinks[index],
                                      ),
                                    )),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Gutter();
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
                      child: Text(
                        'I am a mobile app developer with 5 years of experience in developing mobile applications for both Android and iOS. I have worked with clients from all over the world and have developed a wide range of mobile apps. I have worked with clients from all over the world and have developed a wide range of mobile apps.',
                        style: Theme.of(context).textTheme.bodyMedium,
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
