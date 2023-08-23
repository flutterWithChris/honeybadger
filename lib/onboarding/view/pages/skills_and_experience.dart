import 'package:outsourcedx/profile/portfolio/widgets/portfolio_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:outsourcedx/auth/bloc/auth_bloc.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/onboarding/bloc/onboarding_bloc.dart';
import 'package:outsourcedx/onboarding/view/pages/profile_setup/bloc/skills/bloc/skill_search_bloc.dart';
import 'package:outsourcedx/profile/model/portfolio_project.dart';
import 'package:outsourcedx/profile/model/skill.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:outsourcedx/profile/view/widgets/add_project_dialog.dart';

import '../../../profile/model/user.dart';

class SkillsAndExperiencePage extends StatefulWidget {
  final PageController pageController;

  const SkillsAndExperiencePage({required this.pageController, super.key});

  @override
  State<SkillsAndExperiencePage> createState() =>
      _SkillsAndExperiencePageState();
}

class _SkillsAndExperiencePageState extends State<SkillsAndExperiencePage> {
  Skill? newSkill;
  List<Skill> selectedSkills = [];
  List<PortfolioProject> portfolioProjects = [];

  @override
  void initState() {
    selectedSkills = context.read<OnboardingBloc>().state.user?.skills ?? [];
    print('Selected Skills: ${selectedSkills.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = context.watch<OnboardingBloc>().state.user;
    if (selectedSkills.isEmpty && currentUser?.skills != null) {
      selectedSkills = currentUser!.skills!;
    }
    print('Current User: ${currentUser?.skills?.length}');
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                // Text(
                //   'Skills & Experience',
                //   style: Theme.of(context).textTheme.headlineLarge,
                // ),
                // const SizedBox(height: 24),
                // Text('What are your skills?',
                //     style: Theme.of(context).textTheme.bodyLarge),
                // const Gutter(),
                // const TextField(
                //   minLines: 5,
                //   maxLines: 7,
                //   decoration: InputDecoration(
                //     label: Text('Skills'),
                //     hintText:
                //         'Type your skills here. Ex: Python, Graphic Design, etc.',
                //   ),
                // ),
                // const Gutter(),
                Text('Portfolio',
                    style: Theme.of(context).textTheme.headlineLarge),
                const Gutter(),
                Text(
                    'Create projects to add images & links of your past work, if you have any.',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Gutter(),
                Row(
                  children: [
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AddProjectDialog();
                            },
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline_rounded,
                                  size: 16, color: Colors.grey[600]!),
                              const GutterSmall(),
                              const Text('Create Project',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]);
        }
        if (constraints.maxWidth > tabletWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                Text(
                  'Skills & Experience',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),
                Text('What are your skills?',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Gutter(),
                const TextField(
                  minLines: 5,
                  maxLines: 7,
                  decoration: InputDecoration(
                    label: Text('Skills'),
                    hintText:
                        'Type your skills here. Ex: Python, Graphic Design, etc.',
                  ),
                ),
                const Gutter(),
                Text('Portfolio',
                    style: Theme.of(context).textTheme.headlineLarge),
                const Gutter(),
                Text(
                    'Create projects to add images & links of your past work, if you have any.',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Gutter(),
                Row(
                  children: [
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AddProjectDialog();
                            },
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline_rounded,
                                  size: 16, color: Colors.grey[600]!),
                              const GutterSmall(),
                              const Text('Create Project',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]);
        } else {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              children: [
                Text(
                  'Skills & Experience',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const GutterSmall(),
                Text('Enter your skills below. You can add more later.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Gutter(),
                // Skills Autocomplete
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
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
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
                              const InputDecoration(label: Text('Skills')),
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                Row(
                  children: [
                    Text('Portfolio',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const GutterTiny(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded,
                          size: 24),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AddProjectDialog();
                          },
                        );
                      },
                    )
                  ],
                ),
                const GutterSmall(),
                Text(
                    'Create projects to add images & links of your past work, if you have any.',
                    style: Theme.of(context).textTheme.bodyMedium),
                const Gutter(),
                BlocBuilder<PortfolioBloc, PortfolioState>(
                  builder: (context, state) {
                    if (state is PortfolioError) {
                      return const Text('Error loading portfolio!');
                    }
                    if (state is PortfolioLoading ||
                        state is PortfolioUpdated) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is PortfolioInitial ||
                        state.projects == null ||
                        state.projects!.isEmpty) {
                      return Row(
                        children: [
                          Flexible(
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AddProjectDialog();
                                        },
                                      );
                                    },
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_circle_outline_rounded,
                                              size: 16,
                                              color: Colors.grey[600]!),
                                          const GutterSmall(),
                                          const Text('Add Project',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is PortfolioError) {
                      return const Text('Error loading portfolio!');
                    } else if (state is PortfolioLoaded) {
                      return SizedBox(
                        height: 200,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.projects.length,
                          itemBuilder: (BuildContext context, int index) {
                            final PortfolioProject project =
                                state.projects.elementAt(index);
                            return Stack(
                              children: [
                                if (project.images != null)
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Row(
                                        children: [
                                          IconButton.filled(
                                              style: IconButton.styleFrom(
                                                  minimumSize:
                                                      const Size(32, 32),
                                                  fixedSize: const Size(32, 32),
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                context
                                                    .read<PortfolioBloc>()
                                                    .add(DeleteProject(
                                                        project: project,
                                                        userId: context
                                                            .read<AuthBloc>()
                                                            .state
                                                            .user!
                                                            .uid));
                                              },
                                              color: Colors.white,
                                              icon: const Icon(Icons.remove,
                                                  size: 16)),
                                          // IconButton.filled(
                                          //     onPressed: () {}, icon: const Icon(Icons.edit)),
                                        ],
                                      )),
                                PortfolioCard(project: project),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const GutterSmall();
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const GutterLarge(),
                (context.read<PortfolioBloc>().state.projects != null &&
                            context
                                .read<PortfolioBloc>()
                                .state
                                .projects!
                                .isNotEmpty) ||
                        selectedSkills.isNotEmpty
                    ? FilledButton(
                        onPressed: () async {
                          context.read<OnboardingBloc>().add(UpdateUser(
                              currentUser!.copyWith(skills: selectedSkills)));
                          await widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next'))
                    : OutlinedButton(
                        onPressed: () async {
                          context.read<OnboardingBloc>().add(UpdateUser(
                              currentUser!.copyWith(skills: selectedSkills)));
                          await widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Skip for now'))
              ]);
        }
      }),
    ));
  }
}

class SkillsInput extends StatefulWidget {
  const SkillsInput({Key? key}) : super(key: key);

  @override
  _SkillsInputState createState() => _SkillsInputState();
}

class _SkillsInputState extends State<SkillsInput> {
  final List<String> _skills = [];
  final TextEditingController _controller = TextEditingController();

  void _addSkill(String skill) {
    setState(() {
      _skills.add(skill.trim());
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Skills',
                hintText:
                    'Type your skills here, separated by commas or press enter. Ex: Python, Graphic Design, etc.',
              ),
              onChanged: (value) {
                if (value.endsWith(',')) {
                  _addSkill(value.substring(
                      0, value.length - 1)); // Remove the comma at the end
                }
              },
              onSubmitted: (value) {
                _addSkill(value);
              },
            ),
            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: _skills
                  .map((skill) => Chip(
                        label: Text(skill),
                        onDeleted: () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
