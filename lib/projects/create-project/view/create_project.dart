import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/projects/bloc/projects_bloc.dart';
import 'package:outsourcedx/projects/model/project.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../onboarding/view/pages/profile_setup/bloc/bloc/category_search_bloc.dart';
import '../../../profile/model/category.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deliverablesController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  List<Category> selectedCategories = [];
  ProjectType _projectType = ProjectType.fixed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
      slivers: [
        MobileSliverAppBar(),
        BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            if (state is ProjectsError) {
              return SliverFillRemaining(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_rounded,
                    size: 72.0,
                    color: Colors.red,
                  ),
                  const Gutter(),
                  Text('Error loading projects!',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const Gutter(),
                  FilledButton.icon(
                      onPressed: () {
                        context.read<ProjectsBloc>().add(LoadProjects(
                            user: context.read<ProfileBloc>().state.user!));
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Reload Projects')),
                ],
              ));
            }
            if (state is ProjectsLoading) {
              return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).iconTheme.color!,
                          size: 40.0),
                      const Gutter(),
                      Text('Loading...',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  )));
            }
            if (state is ProjectSending) {
              return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).iconTheme.color!,
                          size: 40.0),
                      const Gutter(),
                      Text('Creating Project...',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  )));
            }
            if (state is ProjectCreated) {
              return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 72.0,
                        color: Colors.lightGreen,
                      ),
                      const Gutter(),
                      Text('Project Created!',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const Gutter(),
                      FilledButton.icon(
                          onPressed: () {
                            context.go('/projects');
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('View Active Projects')),
                    ],
                  )));
            }
            if (state is ProjectsLoaded) {
              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Text('Create Project',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Gutter(),
                  Form(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title for your project';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Project Title',
                          hintText: 'Enter a title for your project',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description for your project';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Project Description',
                          hintText: 'Enter a description for your project',
                          border: OutlineInputBorder(),
                        ),
                        minLines: 5,
                        maxLines: 10,
                      ),
                      // const Gutter(),
                      // TextFormField(
                      //   textCapitalization: TextCapitalization.sentences,
                      //   controller: _deliverablesController,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter deliverables for your project';
                      //     }
                      //     return null;
                      //   },
                      //   decoration: const InputDecoration(
                      //     labelText: 'Project Deliverables',
                      //     hintText:
                      //         'Clearly define the deliverables for your project. Describe exactly what you expect to receive from the freelancer.',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   minLines: 5,
                      //   maxLines: 10,
                      // ),
                      const Gutter(),
                      BlocBuilder<CategorySearchBloc, CategorySearchState>(
                        builder: (context, state) {
                          Category? newCategory;
                          List<Category> categories = state.categories ?? [];
                          String _displayStringForOption(Category option) =>
                              option.name ?? '';
                          return Autocomplete<Category>(
                            displayStringForOption: _displayStringForOption,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) async {
                              if (textEditingValue.text == '') {
                                return const Iterable.empty();
                              }
                              if (textEditingValue.text != '') {
                                context.read<CategorySearchBloc>().add(
                                    SearchCategories(
                                        query: textEditingValue.text));
                              }
                              List<Category> matchingCategories =
                                  state.categories ?? [];

                              if (matchingCategories.isEmpty) {
                                newCategory = Category(
                                  name: textEditingValue.text.trim(),
                                );
                                matchingCategories.add(newCategory!);
                              }

                              return matchingCategories;
                            },
                            onSelected: (Category category) {
                              if (category == newCategory) {
                                context
                                    .read<CategorySearchBloc>()
                                    .add(AddCategory(category: category));
                                // Clear text field
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  final textEditingController =
                                      TextEditingController.fromValue(
                                    TextEditingValue.empty,
                                  );
                                  textEditingController.value =
                                      TextEditingValue.empty;
                                });
                              }
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                final textEditingController =
                                    TextEditingController.fromValue(
                                  TextEditingValue.empty,
                                );
                                textEditingController.value =
                                    TextEditingValue.empty;
                              });

                              if (selectedCategories.length >= 3) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'You can only select up to 3 categories.')));
                                return;
                              }
                              print('Categories: $categories');
                              setState(() {
                                selectedCategories.add(category);
                              });
                              // var currentUser =
                              //     context.read<OnboardingBloc>().state.user!;
                              // List<Category> updatedCategories =
                              //     (currentUser.categories ?? [])..add(category);
                              // context.read<OnboardingBloc>().add(UpdateUser(
                              //       currentUser.copyWith(
                              //         categories: updatedCategories,
                              //       ),
                              //     ));
                              // Print categories that are being added
                              // print('Categories being added:');
                              // for (Category category in updatedCategories) {
                              //   print(category.name);
                              // }
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<Category> onSelected,
                                Iterable<Category> options) {
                              return Material(
                                borderRadius: BorderRadius.circular(16.0),
                                elevation: 4.0,
                                child: SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount:
                                        options.isNotEmpty ? options.length : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (options.isEmpty) {
                                        return const ListTile(
                                          title: Text('No results found'),
                                        );
                                      }
                                      final Category option =
                                          options.elementAt(index);
                                      bool isHighlighted =
                                          AutocompleteHighlightedOption.of(
                                                  context) ==
                                              index;
                                      return GestureDetector(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: ListTile(
                                          leading: option == newCategory
                                              ? const Icon(Icons.add)
                                              : null,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          tileColor: isHighlighted
                                              ? Theme.of(context).cardColor
                                              : null,
                                          title: option == newCategory
                                              ? Text.rich(TextSpan(
                                                  text: 'Add ',
                                                  children: [
                                                    TextSpan(
                                                      text: newCategory!.name!,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              : Text(option.name!),
                                          subtitle: option.description == null
                                              ? null
                                              : Text(
                                                  option.description!,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey[600]!),
                                                ),
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
                                validator: (value) {
                                  if (selectedCategories.isEmpty) {
                                    return 'Please enter at least one category.';
                                  }
                                  return null;
                                },
                                controller: textEditingController,
                                textCapitalization: TextCapitalization.words,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  label: Text('Categories'),
                                  hintText: 'Add a category..',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                              );
                            },
                          );
                        },
                      ),
                      selectedCategories.isNotEmpty
                          ? const GutterSmall()
                          : const SizedBox(),
                      selectedCategories.isEmpty
                          ? const SizedBox()
                          : Row(
                              // spacing: 8.0,
                              // alignment: WrapAlignment.start,
                              children: selectedCategories
                                  .map((category) => Chip(
                                        padding: const EdgeInsets.all(8.0),
                                        visualDensity: VisualDensity.compact,
                                        label: Text(
                                          category.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        onDeleted: () {
                                          // Remove category from user
                                          var currentUser = context
                                              .read<ProfileBloc>()
                                              .state
                                              .user!;
                                          setState(() {
                                            selectedCategories =
                                                selectedCategories
                                                  ..remove(category);
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                      const Gutter(),
                      Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16.0),
                              child: Row(
                                children: [
                                  Text('Project Type',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RadioListTile.adaptive(
                                      title: const Text('Fixed'),
                                      value: 'Fixed',
                                      groupValue: parseEnumName(
                                          _projectType.toString().capitalize),
                                      onChanged: (value) {
                                        setState(() {
                                          _projectType = ProjectType.fixed;
                                        });
                                      }),
                                ),
                                Flexible(
                                  child: RadioListTile.adaptive(
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey),
                                      title: Badge(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          offset: const Offset(-64, -24),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          label: Text('Coming Soon',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .canvasColor)),
                                          child: const Text(
                                            'Hourly',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                      value: 'Hourly',
                                      groupValue: parseEnumName(
                                          _projectType.toString().capitalize),
                                      onChanged: (value) {
                                        // setState(() {
                                        //   _projectType = ProjectType.hourly;
                                        // });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _budgetController,
                        validator: (value) {
                          // Check if value is less than 25 for hourly projects
                          // Check if value is less than 250 for fixed projects
                          if (value == null || value.isEmpty) {
                            return 'Please enter a budget for your project';
                          } else if (int.parse(value) < 250) {
                            return 'Please enter a budget of at least \$250';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          labelText: 'Project Budget',
                          hintText: ' Enter a budget. Minimum \$250',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _deadlineController,
                        readOnly: true,
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)))
                              .then((value) {
                            if (value != null) {
                              _deadlineController.text =
                                  Jiffy.parse(value.toString().split(' ')[0])
                                      .yMMMd;
                            }
                          }); // TODO: Add a year to the last date
                        },
                        decoration: const InputDecoration(
                          labelText: 'Project Deadline',
                          hintText: 'Enter a deadline for your project',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _tagsController,
                        decoration: const InputDecoration(
                          labelText: 'Project Categories',
                          hintText: 'Enter tags for your project',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gutter(),
                      TextFormField(
                        controller: _skillsController,
                        decoration: const InputDecoration(
                          labelText: 'Project Skills',
                          hintText: 'Enter skills for your project',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gutter(),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                                onPressed: () {
                                  context.read<ProjectsBloc>().add(
                                        CreateProject(
                                          project: Project(
                                              title:
                                                  _titleController.value.text,
                                              description: _descriptionController
                                                  .value.text,
                                              deliverables: _deliverablesController
                                                  .value.text,
                                              category: _categoryController
                                                  .value.text,
                                              projectType: _projectType,
                                              budget: int.parse(
                                                  _budgetController.value.text),
                                              deadline: Jiffy.parse(
                                                      _deadlineController
                                                          .value.text,
                                                      pattern: 'MMM do, yyyy')
                                                  .dateTime,
                                              tags: _tagsController.value.text
                                                  .split(','),
                                              skills: _skillsController.value.text
                                                  .split(','),
                                              status: ProjectStatus.open,
                                              createdAt: DateTime.now()),
                                          user: context
                                              .read<ProfileBloc>()
                                              .state
                                              .user!,
                                        ),
                                      );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Create Project')),
                          ),
                        ],
                      ),
                    ],
                  ))
                ])),
              );
            }
            return const SliverFillRemaining(
              child: Center(
                child: Text('Something went wrong...'),
              ),
            );
          },
        )
      ],
    ));
  }
}
