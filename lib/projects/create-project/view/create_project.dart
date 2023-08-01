import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            const MobileSliverAppBar(),
            SliverPadding(
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
                      decoration: const InputDecoration(
                        labelText: 'Project Title',
                        hintText: 'Enter a title for your project',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gutter(),
                    TextFormField(
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
                      decoration: const InputDecoration(
                        labelText: 'Project Category',
                        hintText: 'Enter a category for your project',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gutter(),
                    Row(
                      children: [
                        Text('Project Type',
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: RadioListTile.adaptive(
                              title: const Text('Fixed'),
                              value: 'fixed',
                              groupValue: 'fixed',
                              onChanged: (value) {}),
                        ),
                        Flexible(
                          child: RadioListTile.adaptive(
                              title: const Text('Hourly'),
                              value: 'hourly',
                              groupValue: 'fixed',
                              onChanged: (value) {}),
                        ),
                      ],
                    ),
                    TextFormField(
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
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(
                                days:
                                    365))); // TODO: Add a year to the last date
                      },
                      decoration: const InputDecoration(
                        labelText: 'Project Deadline',
                        hintText: 'Enter a deadline for your project',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gutter(),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Project Tags',
                        hintText: 'Enter tags for your project',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gutter(),
                    TextFormField(
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
                              onPressed: () {},
                              icon: const Icon(Icons.add),
                              label: const Text('Create Project')),
                        ),
                      ],
                    ),
                  ],
                ))
              ])),
            )
          ],
        ));
  }
}
