import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:OutsourcedX/search/view/widgets/project_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/constants.dart';
import '../../../core/presentation/system/main_navigation_bar.dart';
import '../../../core/presentation/system/mobile_sliver_app_bar.dart';
import '../../../projects/model/project.dart';

class DesktopSearchPage extends StatefulWidget {
  const DesktopSearchPage({super.key});

  @override
  State<DesktopSearchPage> createState() => _DesktopSearchPageState();
}

class _DesktopSearchPageState extends State<DesktopSearchPage> {
  ProjectType paymentType = ProjectType.fixed;
  List<double> hourlyRateRange = [40, 60];
  List<int> fixedPriceRange = [5000, 10000];
  final TextEditingController _minHourlyRateController =
      TextEditingController();
  final TextEditingController _maxHourlyRateController =
      TextEditingController();
  final TextEditingController _minFixedPriceController =
      TextEditingController();
  final TextEditingController _maxFixedPriceController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                        searchBarTheme: SearchBarThemeData(
                            elevation: const MaterialStatePropertyAll(0),
                            padding: const MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor))),
                    child: SearchBar(
                      hintText: 'Search Projects..',
                      hintStyle: MaterialStatePropertyAll(TextStyle(
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.8))),
                      trailing: [
                        Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    ),
                  ),
                  const GutterTiny(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hourly / Fixes Popup Menu
                      PopupMenuButton(
                        //  icon: Icon(MdiIcons.filterVariant),
                        onSelected: (value) {
                          setState(() {
                            paymentType = value;
                          });
                        },
                        child: Chip(
                          label: Row(
                            children: [
                              Icon(MdiIcons.currencyUsd, size: 16.0),
                              const GutterTiny(),
                              Text(parseEnumName(paymentType.toString())),
                            ],
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          // side: BorderSide.none,
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: ProjectType.hourly,
                            child: Text('Hourly'),
                          ),
                          const PopupMenuItem(
                            value: ProjectType.fixed,
                            child: Text('Fixed Price'),
                          ),
                        ],
                      ),
                      const Gutter(),
                      paymentType == ProjectType.hourly
                          ? PopupMenuButton(
                              elevation: 0.3,
                              //  icon: Icon(MdiIcons.filterVariant),
                              onOpened: () {
                                _minHourlyRateController.text =
                                    hourlyRateRange[0].toStringAsFixed(0);
                                _maxHourlyRateController.text =
                                    hourlyRateRange[1].toStringAsFixed(0);
                              },
                              onSelected: (value) {
                                setState(() {
                                  paymentType = value;
                                });
                              },
                              child: Chip(
                                label: Row(
                                  children: [
                                    Text(
                                        '\$${hourlyRateRange[0].toStringAsFixed(0)} - \$${hourlyRateRange[1].toStringAsFixed(0)}/hr.'),
                                  ],
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                // side: BorderSide.none,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  value: ProjectType.hourly,
                                  child: TextField(
                                    controller: _minHourlyRateController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        prefixText: '\$',
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'Min.'),
                                  ),
                                ),
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  value: ProjectType.hourly,
                                  child: TextField(
                                    controller: _maxHourlyRateController,
                                    decoration: const InputDecoration(
                                        prefixText: '\$',
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'Max.'),
                                  ),
                                ),
                                PopupMenuItem(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                          alignment: Alignment.center,
                                          minimumSize: const Size(80, 32)),
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('Apply'),
                                    ),
                                  ],
                                )),
                              ],
                            )
                          : PopupMenuButton(
                              elevation: 0.3,
                              //  icon: Icon(MdiIcons.filterVariant),
                              onOpened: () {
                                _minFixedPriceController.text =
                                    fixedPriceRange[0].toString();
                                _maxFixedPriceController.text =
                                    fixedPriceRange[1].toString();
                              },
                              onSelected: (value) {
                                setState(() {
                                  paymentType = value;
                                });
                              },
                              child: Chip(
                                label: Row(
                                  children: [
                                    Text(
                                        '${convertIntToMoney(fixedPriceRange[0])} - ${convertIntToMoney(fixedPriceRange[1])}'),
                                  ],
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                // side: BorderSide.none,
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  value: ProjectType.hourly,
                                  child: TextField(
                                    controller: _minFixedPriceController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        prefixText: '\$',
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'Min.'),
                                  ),
                                ),
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  value: ProjectType.hourly,
                                  child: TextField(
                                    controller: _maxFixedPriceController,
                                    decoration: const InputDecoration(
                                        prefixText: '\$',
                                        filled: true,
                                        border: OutlineInputBorder(),
                                        labelText: 'Max.'),
                                  ),
                                ),
                                PopupMenuItem(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                          alignment: Alignment.center,
                                          minimumSize: const Size(80, 32)),
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('Apply'),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                      TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(80, 32)),
                          onPressed: () {},
                          child: const Text('Filters')),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ProjectCard(
                    project: Project(
                      id: '1',
                      clientId: 'l028jt2RgQe5ksneyYdW',
                      clientName: 'Dwight Schrute',
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: ProjectDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: 'Mobile App Development',
                      projectType: ProjectType.fixed,
                      visibility: ProjectVisibility.public,
                      status: ProjectStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ProjectCard(
                    project: Project(
                      id: '2',
                      clientId: 'l028jt2RgQe5ksneyYdW',
                      clientName: 'Angela Martin',
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: ProjectDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: 'Mobile App Development',
                      projectType: ProjectType.fixed,
                      visibility: ProjectVisibility.public,
                      status: ProjectStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ProjectCard(
                    project: Project(
                      id: '3',
                      clientId: 'l028jt2RgQe5ksneyYdW',
                      clientName: 'Kevin Malone',
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: ProjectDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: 'Mobile App Development',
                      projectType: ProjectType.fixed,
                      visibility: ProjectVisibility.public,
                      status: ProjectStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ProjectCard(
                    project: Project(
                      id: '4',
                      clientId: 'l028jt2RgQe5ksneyYdW',
                      clientName: 'Micheal Scott',
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: ProjectDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: 'Mobile App Development',
                      projectType: ProjectType.fixed,
                      visibility: ProjectVisibility.public,
                      status: ProjectStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ProjectCard(
                    project: Project(
                      id: '5',
                      clientId: 'l028jt2RgQe5ksneyYdW',
                      clientName: 'John Doe',
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: ProjectDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: 'Mobile App Development',
                      projectType: ProjectType.fixed,
                      visibility: ProjectVisibility.public,
                      status: ProjectStatus.open,
                      weekEstimate: 10,
                      startDate: DateTime.now().add(const Duration(days: 7)),
                      endDate: DateTime.now().add(const Duration(days: 82)),
                      tags: ['mobile app', 'cross platform', 'veterinarian'],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
