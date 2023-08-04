import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/onboarding/view/pages/profile_setup/bloc/skills/bloc/skill_search_bloc.dart';
import 'package:honeybadger/profile/model/skill.dart';
import 'package:honeybadger/profile/view/widgets/add_project_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Skill> selectedSkills =
        context.watch<OnboardingBloc>().state.user?.skills ?? [];
    User? currentUser = context.read<OnboardingBloc>().state.user;

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
                Text('What are your skills?',
                    style: Theme.of(context).textTheme.bodyLarge),
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
                        context.read<OnboardingBloc>().add(UpdateUser(
                            currentUser!.copyWith(
                                skills: ((currentUser.skills ?? []))
                                  ..add(skill))));
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
                                    tileColor:
                                        isHighlighted ? Colors.grey[200] : null,
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
                        runSpacing: 4.0, // gap between lines
                        children: selectedSkills
                            .map((skill) => Chip(
                                  label: Text(skill.name!),
                                  onDeleted: () {
                                    List<Skill> updatedSkills =
                                        (currentUser?.skills ?? [])
                                          ..remove(skill);

                                    context.read<OnboardingBloc>().add(
                                        UpdateUser(currentUser!
                                            .copyWith(skills: updatedSkills)));
                                  },
                                ))
                            .toList(),
                      )
                    : const SizedBox(),
                selectedSkills.isNotEmpty ? const GutterTiny() : const Gutter(),
                Text('Portfolio',
                    style: Theme.of(context).textTheme.headlineLarge),
                const GutterSmall(),
                Text(
                    'Create projects to add images & links of your past work, if you have any.',
                    style: Theme.of(context).textTheme.bodyLarge),
                const GutterLarge(),
                Row(
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(16.0)),
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
                ),
                const GutterLarge(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () {}, child: const Text('Skip for now')),
                  ],
                )
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
