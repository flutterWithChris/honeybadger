import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:image_picker/image_picker.dart';

class SkillsAndExperiencePage extends StatefulWidget {
  final PageController pageController;

  const SkillsAndExperiencePage({required this.pageController, super.key});

  @override
  State<SkillsAndExperiencePage> createState() =>
      _SkillsAndExperiencePageState();
}

class _SkillsAndExperiencePageState extends State<SkillsAndExperiencePage> {
  final List<String> _skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
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
                const Gutter(),
                Text('What are your skills?',
                    style: Theme.of(context).textTheme.bodyLarge),
                const Gutter(),
                TypeAheadField(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    textFieldConfiguration: const TextFieldConfiguration(
                        decoration: InputDecoration(label: Text('Skills'))),
                    suggestionsCallback: (query) {
                      return [
                        'Python',
                        'Java',
                        'C++',
                        'C#',
                        'JavaScript',
                        'HTML',
                        'CSS',
                        'Flutter',
                        'Dart',
                        'React',
                        'React Native',
                        'Angular',
                        'Vue',
                        'Node.js',
                      ].where((suggestion) => suggestion.toLowerCase().contains(
                          query.toLowerCase().trim().replaceAll(' ', '')));
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(title: Text(suggestion));
                    },
                    itemSeparatorBuilder: (context, index) => const Divider(),
                    onSuggestionSelected: (suggestion) {
                      if (!_skills.contains(suggestion)) {
                        _skills.add(suggestion);
                      }
                    }),
                const Gutter(),
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
                // const TextField(
                //   minLines: 5,
                //   maxLines: 7,
                //   decoration: InputDecoration(
                //     label: Text('Skills'),
                //     hintText:
                //         'Type your skills here. Ex: Python, Graphic Design, etc.',
                //   ),
                // ),
                const Gutter(),
                Text('Portfolio',
                    style: Theme.of(context).textTheme.headlineLarge),
                const Gutter(),
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
                                    const Text('Create Project',
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
                )
              ]);
        }
      }),
    ));
  }
}

class AddProjectDialog extends StatelessWidget {
  const AddProjectDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                const Gutter(),
                Text('Add Project',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Gutter(),
                const TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                const Row(
                  children: [
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project Start'),
                        ),
                      ),
                    ),
                    Gutter(),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project End'),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gutter(),
                const TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Project Description'),
                  ),
                ),
                const Gutter(),
                const TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    label: Text('Project Link'),
                  ),
                ),
                const Gutter(),
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: Colors.grey[600]!),
                          const GutterSmall(),
                          const Text('Drag & Drop Images',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gutter(),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    const Gutter(),
                  ],
                )
              ]);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                const Gutter(),
                Text('Add Project',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Gutter(),
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                const Row(
                  children: [
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project Start'),
                        ),
                      ),
                    ),
                    Gutter(),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project End'),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gutter(),
                const TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Project Description'),
                  ),
                ),
                const Gutter(),
                const TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    label: Text('Project Link'),
                  ),
                ),
                const Gutter(),
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: Colors.grey[600]!),
                          const GutterSmall(),
                          const Text('Drag & Drop Images',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gutter(),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    const Gutter(),
                  ],
                )
              ]);
        } else {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                const Gutter(),
                Text('Add Project',
                    style: Theme.of(context).textTheme.headlineMedium),
                const GutterLarge(),
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: ActionChip(
                      side: BorderSide.none,
                      label: const Text('Project Start'),
                      onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 3650)),
                          lastDate: DateTime.now()),
                    )),
                    Flexible(
                        child: ActionChip(
                      side: BorderSide.none,
                      label: const Text('Project End'),
                      onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 3650)),
                          lastDate: DateTime.now()),
                    )),
                  ],
                ),
                const Gutter(),
                const TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Project Description'),
                  ),
                ),
                const Gutter(),
                const TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    label: Text('Project Link'),
                  ),
                ),
                const Gutter(),
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> image = await picker.pickMultiImage();
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
                          const Text('Add Images',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gutter(),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    const Gutter(),
                  ],
                )
              ]);
        }
      }),
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
