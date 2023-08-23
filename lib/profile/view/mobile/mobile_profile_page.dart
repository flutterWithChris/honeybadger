import 'package:outsourcedx/onboarding/view/pages/profile_setup/bloc/skills/bloc/skill_search_bloc.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:outsourcedx/profile/portfolio/widgets/portfolio_card.dart';
import 'package:outsourcedx/profile/view/mobile/mobile_client_profile_page.dart';
import 'package:outsourcedx/profile/view/widgets/add_project_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/presentation/drawers/main_drawer.dart';
import '../../model/skill.dart';

class MobileProfilePage extends StatelessWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          MobileSliverAppBar(
            iconOnly: true,
          ),
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
                              radius: 42.0,
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
                          Flexible(
                            child: IconButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const EditNameAndTitleDialog());
                                },
                                icon: const Icon(Icons.edit_rounded)),
                          )
                        ],
                      ),
                    ),

                    //   const GutterTiny(),

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
                                      const GutterTiny(),
                                      IconButton(
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AddProjectDialog());
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline_rounded))
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
                                      IconButton(
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AddProjectDialog());
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline_rounded))
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
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      IconButton(
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AddProjectDialog());
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline_rounded))
                                    ],
                                  ),
                                ),
                                const GutterSmall(),
                                portfolioState.projects.isEmpty
                                    // Display placeholder portfolio card
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: SizedBox(
                                          height: 180,
                                          width: 180,
                                          child: Card(
                                            //color: Colors.transparent,
                                            child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                onTap: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const AddProjectDialog());
                                                },
                                                child: const Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        size: 20.0,
                                                      ),
                                                      GutterSmall(),
                                                      Text('Add Projects'),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      )
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
                    const GutterSmall(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'About Me',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const GutterTiny(),
                          IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const EditBioDialog());
                              },
                              icon: const Icon(Icons.edit_rounded))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        state.user.bio ?? 'No bio set',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const GutterSmall(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Skills',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const GutterTiny(),
                          IconButton(
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const AddSkillsDialog());
                              },
                              icon:
                                  const Icon(Icons.add_circle_outline_rounded))
                        ],
                      ),
                    ),
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
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Reviews',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    state.user.reviews != null && state.user.reviews!.isNotEmpty
                        ? ReviewList(
                            user: state.user,
                          )
                        : // show empty state
                        const EmptyReviewsWidget(),
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

class EditNameAndTitleDialog extends StatefulWidget {
  const EditNameAndTitleDialog({super.key});

  @override
  State<EditNameAndTitleDialog> createState() => _EditNameAndTitleDialogState();
}

class _EditNameAndTitleDialogState extends State<EditNameAndTitleDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    firstNameController.text =
        context.read<ProfileBloc>().state.user?.firstName ?? '';
    lastNameController.text =
        context.read<ProfileBloc>().state.user?.lastName ?? '';
    titleController.text = context.read<ProfileBloc>().state.user?.title ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(label: Text('First Name')),
            ),
            const Gutter(),
            TextFormField(
              controller: lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(label: Text('Last Name')),
            ),
            const Gutter(),
            TextFormField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(label: Text('Title')),
            ),
            const Gutter(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(UpdateProfile(
                                user: context
                                    .read<ProfileBloc>()
                                    .state
                                    .user!
                                    .copyWith(
                                        firstName:
                                            firstNameController.value.text,
                                        lastName: lastNameController.value.text,
                                        title: titleController.value.text)));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save')),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EditBioDialog extends StatefulWidget {
  const EditBioDialog({super.key});

  @override
  State<EditBioDialog> createState() => _EditBioDialogState();
}

class _EditBioDialogState extends State<EditBioDialog> {
  final TextEditingController bioController = TextEditingController();
  @override
  void initState() {
    bioController.text =
        context.read<ProfileBloc>().state.user?.bio ?? 'No bio set';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: bioController,
              // initialValue: context.read<ProfileBloc>().state.user?.bio,
              textCapitalization: TextCapitalization.sentences,
              minLines: 5,
              maxLines: 12,
              decoration: const InputDecoration(label: Text('Bio')),
            ),
            const Gutter(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(UpdateProfile(
                                user: context
                                    .read<ProfileBloc>()
                                    .state
                                    .user!
                                    .copyWith(bio: bioController.value.text)));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save')),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddSkillsDialog extends StatefulWidget {
  const AddSkillsDialog({super.key});

  @override
  State<AddSkillsDialog> createState() => _AddSkillsDialogState();
}

class _AddSkillsDialogState extends State<AddSkillsDialog> {
  final List<Skill> selectedSkills = [];
  Skill? newSkill;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<SkillSearchBloc, SkillSearchState>(
              builder: (context, state) {
                if (state is SkillSearchFailure) {
                  return const Text('Error loading skills!');
                }
                return Autocomplete<Skill>(
                  displayStringForOption: (option) => option.name!,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable.empty();
                    }
                    List<Skill> matchingSkills = [];
                    if (state.skills != null && state.skills!.isNotEmpty) {
                      matchingSkills = state.skills?.toList() ?? [];
                      for (Skill skill in matchingSkills) {
                        print('Found Skill: ${skill.name}');
                      }
                    }
                    if (matchingSkills.isEmpty) {
                      newSkill = Skill(
                          name: textEditingValue.text.trim(),
                          description: null);
                      return [newSkill!];
                    }
                    return matchingSkills;
                  },
                  onSelected: (Skill skill) {
                    if (skill == newSkill) {
                      BlocProvider.of<SkillSearchBloc>(context)
                          .add(AddSkill(skill: skill));
                    }
                    setState(() {
                      selectedSkills.add(skill);
                    });
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<Skill> onSelected,
                      Iterable<Skill> options) {
                    return Material(
                      borderRadius: BorderRadius.circular(16.0),
                      elevation: 4.0,
                      child: SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Skill option = options.elementAt(index);
                            bool isHighlighted =
                                AutocompleteHighlightedOption.of(context) ==
                                    index;
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                tileColor: isHighlighted
                                    ? Theme.of(context).cardColor
                                    : null,
                                leading: option == newSkill
                                    ? const Icon(Icons.add)
                                    : null,
                                title: option == newSkill
                                    ? Text.rich(
                                        TextSpan(
                                          text: 'Add ',
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "'${option.name}'",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' as a new skill',
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(option.name!),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: textEditingController,
                      onChanged: (value) {
                        // Debounce search

                        if (value.isNotEmpty) {
                          context
                              .read<SkillSearchBloc>()
                              .add(SearchSkills(query: value.trim()));
                        }
                      },
                      focusNode: focusNode,
                      decoration:
                          const InputDecoration(label: Text('Search Skills')),
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                );
              },
            ),
            selectedSkills.isNotEmpty ? const Gutter() : const SizedBox(),
            selectedSkills.isNotEmpty
                ? Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 2.0, // gap between lines
                    children: selectedSkills
                        .map((skill) => Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                skill.name!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onDeleted: () {
                                setState(() {
                                  selectedSkills.remove(skill);
                                });
                              },
                            ))
                        .toList(),
                  )
                : const SizedBox(),
            const Gutter(),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          onPressed: () {
                            List<Skill>? currentSkills =
                                context.read<ProfileBloc>().state.user?.skills;
                            context.read<ProfileBloc>().add(UpdateProfile(
                                user: context
                                    .read<ProfileBloc>()
                                    .state
                                    .user!
                                    .copyWith(
                                        skills: currentSkills != null &&
                                                currentSkills.isNotEmpty
                                            ? currentSkills + selectedSkills
                                            : selectedSkills)));
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save')),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
              ],
            )
          ],
        ),
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
          child: FilledButton(
              style: FilledButton.styleFrom(
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
