import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/projects/bloc/projects_bloc.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/model/project_category.dart';
import 'package:jiffy/jiffy.dart';

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
  ProjectType _projectType = ProjectType.fixed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            const MobileSliverAppBar(),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsError) {
                  return const SliverFillRemaining(child: Text('Error'));
                }
                if (state is ProjectLoading) {
                  return const SliverFillRemaining(child: Text('Loading...'));
                }
                if (state is ProjectSending) {
                  return const SliverFillRemaining(child: Text('Sending...'));
                }
                if (state is ProjectCreated) {
                  return const SliverFillRemaining(child: Text('Created'));
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
                            decoration: const InputDecoration(
                              labelText: 'Project Description',
                              hintText: 'Enter a description for your project',
                              border: OutlineInputBorder(),
                            ),
                            minLines: 5,
                            maxLines: 10,
                          ),
                          const Gutter(),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _deliverablesController,
                            decoration: const InputDecoration(
                              labelText: 'Project Deliverables',
                              hintText:
                                  'Clearly define the deliverables for your project. Describe exactly what you expect to receive from the freelancer.',
                              border: OutlineInputBorder(),
                            ),
                            minLines: 5,
                            maxLines: 10,
                          ),
                          const Gutter(),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: _categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Project Category',
                              hintText: 'Enter a category for your project',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const Gutter(),
                          Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, top: 16.0),
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
                                          groupValue: parseEnumName(_projectType
                                              .toString()
                                              .capitalize),
                                          onChanged: (value) {
                                            setState(() {
                                              _projectType = ProjectType.fixed;
                                            });
                                          }),
                                    ),
                                    Flexible(
                                      child: RadioListTile.adaptive(
                                          title: const Text('Hourly'),
                                          value: 'Hourly',
                                          groupValue: parseEnumName(_projectType
                                              .toString()
                                              .capitalize),
                                          onChanged: (value) {
                                            setState(() {
                                              _projectType = ProjectType.hourly;
                                            });
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
                                  _deadlineController.text = Jiffy.parse(
                                          value.toString().split(' ')[0])
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
                              labelText: 'Project Tags',
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
                                      context
                                          .read<ProjectsBloc>()
                                          .add(CreateProject(
                                              project: Project(
                                            title: _titleController.value.text,
                                            description: _descriptionController
                                                .value.text,
                                            deliverables:
                                                _deliverablesController
                                                    .value.text,
                                            category: ProjectCategory(
                                                name: _categoryController
                                                    .value.text),
                                            projectType: _projectType,
                                            budget: double.parse(
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
                                          )));
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
