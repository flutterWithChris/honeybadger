import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/projects/model/project.dart';
import 'package:honeybadger/projects/model/project_category.dart';
import 'package:honeybadger/search/view/widgets/Project_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileSearchPage extends StatefulWidget {
  const MobileSearchPage({super.key});

  @override
  State<MobileSearchPage> createState() => _MobileSearchPageState();
}

class _MobileSearchPageState extends State<MobileSearchPage> {
  ProjectType projectType = ProjectType.fixed;
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
      floatingActionButton: inProduction == false
          ? FloatingActionButton(
              onPressed: () {
                context.push('/create-project');
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
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
                  Theme(
                    data: Theme.of(context).copyWith(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hourly / Fixes Popup Menu
                        PageTransitionSwitcher(
                          duration: 400.ms,
                          // reverse: true,
                          transitionBuilder:
                              (child, primaryAnimation, secondaryAnimation) {
                            return SharedAxisTransition(
                              animation: primaryAnimation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.vertical,
                              child: child,
                            );
                          },
                          child: projectType == ProjectType.hourly
                              ? PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  key: const ValueKey('hourlyPopupMenu'),
                                  //  icon: Icon(MdiIcons.filterVariant),
                                  onSelected: (value) {
                                    setState(() {
                                      projectType = value;
                                    });
                                  },
                                  child: Chip(
                                    label: Row(
                                      children: [
                                        projectType == ProjectType.hourly
                                            ? Icon(
                                                MdiIcons.clockTimeFourOutline,
                                                size: 14.0)
                                            : Icon(
                                                MdiIcons.cashLock,
                                                size: 14.0,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                        const GutterTiny(),
                                        Text(parseEnumName(
                                            projectType.toString())),
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
                                )
                              : PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  key: const ValueKey('fixedPopupMenu'),
                                  //  icon: Icon(MdiIcons.filterVariant),
                                  onSelected: (value) {
                                    setState(() {
                                      projectType = value;
                                    });
                                  },
                                  child: Chip(
                                    label: Row(
                                      children: [
                                        projectType == ProjectType.hourly
                                            ? Icon(
                                                MdiIcons.clockTimeFourOutline,
                                                size: 14.0)
                                            : Icon(
                                                MdiIcons.cashLock,
                                                size: 14.0,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                        const GutterTiny(),
                                        Text(parseEnumName(
                                            projectType.toString())),
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
                        ),
                        const Gutter(),
                        PageTransitionSwitcher(
                          duration: 400.ms,
                          // reverse: true,
                          transitionBuilder:
                              (child, primaryAnimation, secondaryAnimation) {
                            return SharedAxisTransition(
                              animation: primaryAnimation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.vertical,
                              child: child,
                            );
                          },
                          child: ProjectType == ProjectType.hourly
                              ? PopupMenuButton(
                                  key: const ValueKey('hourly'),
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
                                      projectType = value;
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
                                  key: const ValueKey('fixed'),
                                  elevation: 0.3,
                                  surfaceTintColor: Colors.transparent,
                                  //  icon: Icon(MdiIcons.filterVariant),
                                  onOpened: () {
                                    _minFixedPriceController.text =
                                        fixedPriceRange[0].toString();
                                    _maxFixedPriceController.text =
                                        fixedPriceRange[1].toString();
                                  },
                                  onSelected: (value) {
                                    setState(() {
                                      projectType = value;
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
                        ),
                        const Gutter(),
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(80, 32)),
                            onPressed: () {},
                            child: const Text('Filters')),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: sampleProjectCards.length,
              (context, index) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ProjectCard(
                      project: sampleProjectCards[index].project,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

List<ProjectCard> sampleProjectCards = [
  ProjectCard(
    project: Project(
      id: '1',
      client: User(
          id: 'ronswanson',
          firstName: 'John',
          lastName: 'Doe',
          city: 'San Francisco',
          state: 'CA',
          photoUrl: '',
          email: '',
          ratingCount: 4,
          rating: 4.5),
      title: 'Create an app for a Veterinarian\'s office patients.',
      description:
          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
      budget: 12000,
      duration: ProjectDuration.recurring,
      skills: ['Flutter', 'Dart', 'Firebase'],
      category: ProjectCategory(
        id: '1',
        name: 'Mobile App Development',
      ),
      projectType: ProjectType.fixed,
      visibility: ProjectVisibility.public,
      status: ProjectStatus.open,
      weekEstimate: 10,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 82)),
      tags: ['mobile app', 'cross platform', 'veterinarian'],
    ),
  ),
  ProjectCard(
    project: Project(
      id: '2',
      client: User(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          city: 'San Francisco',
          state: 'CA',
          photoUrl: '',
          email: '',
          ratingCount: 4,
          rating: 4.5),
      title: 'Graphic design work for a new mobile app we\'re working on.',
      description:
          'Needing a graphic designer to help us with a new mobile app we\'re working on. We\'re looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
      budget: 8000,
      duration: ProjectDuration.recurring,
      skills: ['Illustrator', 'Photoshop', 'Adobe XD'],
      category: ProjectCategory(
        id: '1',
        name: 'Graphic Design',
      ),
      projectType: ProjectType.fixed,
      visibility: ProjectVisibility.public,
      status: ProjectStatus.open,
      weekEstimate: 10,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 82)),
      tags: ['mobile app', 'cross platform', 'veterinarian'],
    ),
  ),
  ProjectCard(
    project: Project(
      id: '3',
      client: User(
          id: '2',
          firstName: 'John',
          lastName: 'Doe',
          city: 'San Francisco',
          state: 'CA',
          photoUrl: '',
          email: '',
          ratingCount: 4,
          rating: 4.5),
      title: 'Create a landing page with Framer.',
      description:
          'Our company, , is looking for a Framer expert to help us create a landing page for our new product. Should include animations and be responsive. While also being SEO friendly.',
      budget: 10000,
      duration: ProjectDuration.recurring,
      skills: ['Framer', 'React', 'Javascript'],
      category: ProjectCategory(
        id: '1',
        name: 'Web Development',
      ),
      projectType: ProjectType.fixed,
      visibility: ProjectVisibility.public,
      status: ProjectStatus.open,
      weekEstimate: 10,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 82)),
      tags: ['mobile app', 'cross platform', 'veterinarian'],
    ),
  ),
  ProjectCard(
    project: Project(
      id: '4',
      client: User(
          id: '3',
          firstName: 'John',
          lastName: 'Doe',
          city: 'San Francisco',
          state: 'CA',
          photoUrl: '',
          email: '',
          ratingCount: 4,
          rating: 4.5),
      title: 'Create an app for a Veterinarian\'s office patients.',
      description:
          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
      budget: 10000,
      duration: ProjectDuration.recurring,
      skills: ['Flutter', 'Dart', 'Firebase'],
      category: ProjectCategory(
        id: '1',
        name: 'Mobile App Development',
      ),
      projectType: ProjectType.fixed,
      visibility: ProjectVisibility.public,
      status: ProjectStatus.open,
      weekEstimate: 10,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 82)),
      tags: ['mobile app', 'cross platform', 'veterinarian'],
    ),
  ),
  ProjectCard(
    project: Project(
      id: '5',
      client: User(
          id: '4',
          firstName: 'John',
          lastName: 'Doe',
          city: 'San Francisco',
          state: 'CA',
          photoUrl: '',
          email: '',
          ratingCount: 4,
          rating: 4.5),
      title: 'Create an app for a Veterinarian\'s office patients.',
      description:
          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
      budget: 10000,
      duration: ProjectDuration.recurring,
      skills: ['Flutter', 'Dart', 'Firebase'],
      category: ProjectCategory(
        id: '1',
        name: 'Mobile App Development',
      ),
      projectType: ProjectType.fixed,
      visibility: ProjectVisibility.public,
      status: ProjectStatus.open,
      weekEstimate: 10,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 82)),
      tags: ['mobile app', 'cross platform', 'veterinarian'],
    ),
  ),
];
