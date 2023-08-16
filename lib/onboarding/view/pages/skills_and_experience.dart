import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:OutsourcedX/auth/bloc/auth_bloc.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/onboarding/bloc/onboarding_bloc.dart';
import 'package:OutsourcedX/onboarding/view/pages/profile_setup/bloc/skills/bloc/skill_search_bloc.dart';
import 'package:OutsourcedX/profile/model/portfolio_project.dart';
import 'package:OutsourcedX/profile/model/skill.dart';
import 'package:OutsourcedX/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:OutsourcedX/profile/view/widgets/add_project_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

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
                            return PortfolioCard(project: project);
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

class ViewPortfolioProjectDialog extends StatefulWidget {
  final PortfolioProject project;
  const ViewPortfolioProjectDialog({required this.project, super.key});

  @override
  State<ViewPortfolioProjectDialog> createState() =>
      _ViewPortfolioProjectDialogState();
}

class _ViewPortfolioProjectDialogState
    extends State<ViewPortfolioProjectDialog> {
  List<String> _images = [];
  List<XFile> _newImages = [];
  String projectLink = '';
  var _previewData;
  final TextEditingController _projectLinkController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  DateTime? _projectStart;
  DateTime? _projectEnd;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool imageValid = true;

  @override
  void initState() {
    // TODO: implement initState
    _projectNameController.text = widget.project.title ?? '';
    _projectDescriptionController.text = widget.project.description ?? '';
    _projectLinkController.text = widget.project.url ?? '';
    _projectStart = widget.project.startDate;
    _projectEnd = widget.project.endDate;
    _images = widget.project.images ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocConsumer<PortfolioBloc, PortfolioState>(
        listenWhen: (previous, current) =>
            previous is PortfolioLoading && current is PortfolioLoaded,
        listener: (context, state) async {
          if (state is PortfolioLoaded) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is PortfolioError) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                  size: 72,
                ),
                const Gutter(),
                const Text('Error Loading Portfolio..',
                    style: TextStyle(fontSize: 18)),
                const Gutter(),
                FilledButton(
                  onPressed: () {
                    context.read<PortfolioBloc>().add(LoadPortfolio(
                        userId: context.read<AuthBloc>().state.user!.uid));
                  },
                  child: const Text('Retry'),
                )
              ]),
            );
          }
          if (state is PortfolioLoading) {
            return const Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: CircularProgressIndicator(),
              ),
            ]);
          }
          if (state is PortfolioLoaded || state is PortfolioInitial) {
            return Form(
              key: formKey,
              child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  children: [
                    Text('View Project',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const Gutter(),
                    TextFormField(
                      controller: _projectNameController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Project Name'),
                      ),
                    ),
                    const Gutter(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 3,
                            child: ActionChip(
                              side: BorderSide.none,
                              label: _projectStart != null
                                  ? Text(Jiffy.parseFromDateTime(_projectStart!)
                                      .yMMMd)
                                  : const Text('Project Start'),
                              onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 3650)),
                                      lastDate: DateTime.now())
                                  .then((value) => setState(() {
                                        _projectStart = value;
                                      })),
                            )),
                        const Expanded(child: Center(child: Text('to'))),
                        Flexible(
                            flex: 3,
                            child: ActionChip(
                              side: BorderSide.none,
                              label: _projectEnd != null
                                  ? Text(Jiffy.parseFromDateTime(_projectEnd!)
                                      .yMMMd)
                                  : const Text('Ongoing'),
                              onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 3650)),
                                      lastDate: DateTime.now())
                                  .then((value) => setState(() {
                                        _projectEnd = value;
                                      })),
                            )),
                      ],
                    ),
                    const Gutter(),
                    TextFormField(
                      controller: _projectDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        label: Text('Project Description'),
                      ),
                    ),
                    const Gutter(),
                    TextFormField(
                      controller: _projectLinkController,
                      validator: (value) {
                        if (value != null) {
                          try {
                            var url = Uri.parse(value);
                          } catch (e) {
                            return 'Please enter a valid URL';
                          }
                        }
                        return null;
                      },
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        label: Text('Project Link'),
                        prefixText: 'https://',
                      ),
                    ),
                    const Gutter(),
                    Row(
                      children: [
                        Text('Images',
                            style: Theme.of(context).textTheme.titleLarge),
                        const GutterTiny(),
                        IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              List<XFile> selectedImages =
                                  await picker.pickMultiImage();
                              if (selectedImages.isNotEmpty) {
                                print('images selected');
                                setState(() {
                                  _newImages += selectedImages;
                                });
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded,
                                size: 20)),
                      ],
                    ),
                    const GutterSmall(),
                    SizedBox(
                      height: 200,
                      child: _images.isNotEmpty
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        height: 200,
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    children: [
                                                      Card(
                                                        child: SizedBox(
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl:
                                                                      _images[
                                                                          index]),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 2.0,
                                                        left: 2.0,
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child:
                                                              IconButton.filled(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close_rounded,
                                                                      size:
                                                                          16)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CachedNetworkImage(
                                              imageUrl: _images[index] ?? ''),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4.0,
                                      left: 4.0,
                                      child: SizedBox(
                                        height: 28,
                                        child: FittedBox(
                                          child: Opacity(
                                            opacity: 0.8,
                                            child: IconButton.filled(
                                                style: IconButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    foregroundColor:
                                                        Colors.white),
                                                onPressed: () {
                                                  setState(() {
                                                    _images.removeAt(index);
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.remove_rounded,
                                                    size: 24)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // TODO: Mark as cover
                                    index == 0
                                        ? Positioned(
                                            bottom: 0,
                                            child: SizedBox(
                                              child: Container(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                height: 48,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const GutterSmall(),
                            )
                          : Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: imageValid
                                          ? Colors.grey
                                          : Theme.of(context)
                                              .colorScheme
                                              .error),
                                  borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  List<XFile> selectedImages =
                                      await picker.pickMultiImage();
                                  if (selectedImages.isNotEmpty) {
                                    print('images selected');
                                    setState(() {
                                      _newImages = selectedImages;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.add_circle_outline_rounded,
                                    //     size: 16, color: Colors.grey[600]!),
                                    // const GutterSmall(),
                                    imageValid
                                        ? const SizedBox()
                                        : const Icon(Icons.error_rounded,
                                            size: 20, color: Colors.redAccent),
                                    imageValid
                                        ? const SizedBox()
                                        : const GutterSmall(),
                                    Text(
                                        imageValid
                                            ? 'No Images Selected'
                                            : 'Please add at least one image',
                                        style: const TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const Gutter(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                        const Gutter(),
                        FilledButton(
                            onPressed: () {
                              if (_images.isEmpty) {
                                setState(() {
                                  imageValid = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please select at least one image')));
                                return;
                              }
                              if (formKey.currentState!.validate()) {
                                context.read<PortfolioBloc>().add(UpdateProject(
                                    project: PortfolioProject(
                                      title: _projectNameController.value.text
                                          .trim(),
                                      description: _projectDescriptionController
                                          .text
                                          .trim(),
                                      url: _projectLinkController.value.text
                                          .trim(),
                                      startDate: _projectStart,
                                      endDate: _projectEnd,
                                    ),
                                    images: _newImages,
                                    userId: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .uid));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please fill in all fields')));
                              }
                            },
                            child: const Text('Save Changes')),
                        const Gutter(),
                      ],
                    )
                  ]),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class PortfolioCard extends StatelessWidget {
  final PortfolioProject project;
  const PortfolioCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return ViewPortfolioProjectDialog(
                  project: project,
                );
              },
            );
          },
          child: Stack(
            children: [
              if (project.images != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      project.images![0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                      stops: const [0.0, 0.9],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Row(
                    children: [
                      IconButton.filled(
                          style: IconButton.styleFrom(
                              minimumSize: const Size(32, 32),
                              fixedSize: const Size(32, 32),
                              backgroundColor: Colors.red.withOpacity(0.8)),
                          onPressed: () {
                            context.read<PortfolioBloc>().add(DeleteProject(
                                project: project,
                                userId:
                                    context.read<AuthBloc>().state.user!.uid));
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.remove, size: 16)),
                      // IconButton.filled(
                      //     onPressed: () {}, icon: const Icon(Icons.edit)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
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
