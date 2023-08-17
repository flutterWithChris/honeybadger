import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/core/presentation/system/main_navigation_bar.dart';
import 'package:OutsourcedX/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/projects/model/project.dart';
import 'package:OutsourcedX/search/bloc/search_bloc.dart';
import 'package:OutsourcedX/search/view/widgets/Project_card.dart';

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
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        print('Keyboard event: $event');
        print(' Key Pressed: ${event.logicalKey}');
        if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
            event.isKeyPressed(LogicalKeyboardKey.accept)) {
          print('Searching for: ${_searchController.value.text}');
          context.read<SearchBloc>().add(LoadSearch(
                context.read<ProfileBloc>().state.user!,
                query: _searchController.value.text,
              ));
        }
      },
      child: Scaffold(
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
            MobileSliverAppBar(),
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
                              textStyle: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color)),
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor))),
                      child: SearchBar(
                        controller: _searchController,
                        // onSubmitted: (value) {
                        //   context.read<SearchBloc>().add(LoadSearch(
                        //         context.read<ProfileBloc>().state.user!,
                        //         query: value,
                        //       ));
                        // },
                        // onChanged: (value) {
                        //   //
                        //   context.read<SearchBloc>().add(LoadSearch(
                        //         context.read<ProfileBloc>().state.user!,
                        //         query: value,
                        //       ));
                        // },
                        hintText:
                            context.watch<ProfileBloc>().state is ProfileLoaded
                                ? 'Search Projects..'
                                : null,
                        hintStyle: MaterialStatePropertyAll(TextStyle(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.8))),
                        trailing: [
                          IconButton(
                              onPressed: () {
                                print(
                                    'Searching for: ${_searchController.value.text}');
                                context.read<SearchBloc>().add(LoadSearch(
                                      context.read<ProfileBloc>().state.user!,
                                      query: _searchController.value.text,
                                    ));
                              },
                              icon: const Icon(Icons.search_rounded)),
                        ],
                      ),
                    ),
                    const GutterSmall(),
                    // Theme(
                    //   data: Theme.of(context).copyWith(),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       // Hourly / Fixes Popup Menu
                    //       PageTransitionSwitcher(
                    //         duration: 400.ms,
                    //         // reverse: true,
                    //         transitionBuilder:
                    //             (child, primaryAnimation, secondaryAnimation) {
                    //           return SharedAxisTransition(
                    //             animation: primaryAnimation,
                    //             secondaryAnimation: secondaryAnimation,
                    //             transitionType: SharedAxisTransitionType.vertical,
                    //             child: child,
                    //           );
                    //         },
                    //         child: projectType == ProjectType.hourly
                    //             ? PopupMenuButton(
                    //                 padding: EdgeInsets.zero,
                    //                 key: const ValueKey('hourlyPopupMenu'),
                    //                 //  icon: Icon(MdiIcons.filterVariant),
                    //                 onSelected: (value) {
                    //                   setState(() {
                    //                     projectType = value;
                    //                   });
                    //                 },
                    //                 child: Chip(
                    //                   label: Row(
                    //                     children: [
                    //                       projectType == ProjectType.hourly
                    //                           ? Icon(
                    //                               MdiIcons.clockTimeFourOutline,
                    //                               size: 14.0)
                    //                           : Icon(
                    //                               MdiIcons.cashLock,
                    //                               size: 14.0,
                    //                               color: Theme.of(context)
                    //                                   .iconTheme
                    //                                   .color,
                    //                             ),
                    //                       const GutterTiny(),
                    //                       Text(parseEnumName(
                    //                           projectType.toString())),
                    //                     ],
                    //                   ),
                    //                   visualDensity: VisualDensity.compact,
                    //                   padding: EdgeInsets.zero,
                    //                   // side: BorderSide.none,
                    //                 ),
                    //                 itemBuilder: (context) => [
                    //                   const PopupMenuItem(
                    //                     value: ProjectType.hourly,
                    //                     child: Text('Hourly'),
                    //                   ),
                    //                   const PopupMenuItem(
                    //                     value: ProjectType.fixed,
                    //                     child: Text('Fixed Price'),
                    //                   ),
                    //                 ],
                    //               )
                    //             : PopupMenuButton(
                    //                 padding: EdgeInsets.zero,
                    //                 key: const ValueKey('fixedPopupMenu'),
                    //                 //  icon: Icon(MdiIcons.filterVariant),
                    //                 onSelected: (value) {
                    //                   setState(() {
                    //                     projectType = value;
                    //                   });
                    //                 },
                    //                 child: Chip(
                    //                   label: Row(
                    //                     children: [
                    //                       projectType == ProjectType.hourly
                    //                           ? Icon(
                    //                               MdiIcons.clockTimeFourOutline,
                    //                               size: 14.0)
                    //                           : Icon(
                    //                               MdiIcons.cashLock,
                    //                               size: 14.0,
                    //                               color: Theme.of(context)
                    //                                   .iconTheme
                    //                                   .color,
                    //                             ),
                    //                       const GutterTiny(),
                    //                       Text(parseEnumName(
                    //                           projectType.toString())),
                    //                     ],
                    //                   ),
                    //                   visualDensity: VisualDensity.compact,
                    //                   padding: EdgeInsets.zero,
                    //                   // side: BorderSide.none,
                    //                 ),
                    //                 itemBuilder: (context) => [
                    //                   const PopupMenuItem(
                    //                     value: ProjectType.hourly,
                    //                     child: Text('Hourly'),
                    //                   ),
                    //                   const PopupMenuItem(
                    //                     value: ProjectType.fixed,
                    //                     child: Text('Fixed Price'),
                    //                   ),
                    //                 ],
                    //               ),
                    //       ),
                    //       const Gutter(),
                    // PageTransitionSwitcher(
                    //   duration: 400.ms,
                    //   // reverse: true,
                    //   transitionBuilder:
                    //       (child, primaryAnimation, secondaryAnimation) {
                    //     return SharedAxisTransition(
                    //       animation: primaryAnimation,
                    //       secondaryAnimation: secondaryAnimation,
                    //       transitionType: SharedAxisTransitionType.vertical,
                    //       child: child,
                    //     );
                    //   },
                    //   child: projectType == ProjectType.hourly
                    //       ? PopupMenuButton(
                    //           key: const ValueKey('hourly'),
                    //           elevation: 0.3,
                    //           //  icon: Icon(MdiIcons.filterVariant),
                    //           onOpened: () {
                    //             _minHourlyRateController.text =
                    //                 hourlyRateRange[0].toStringAsFixed(0);
                    //             _maxHourlyRateController.text =
                    //                 hourlyRateRange[1].toStringAsFixed(0);
                    //           },
                    //           onSelected: (value) {
                    //             setState(() {
                    //               projectType = value;
                    //             });
                    //           },
                    //           child: Chip(
                    //             label: Row(
                    //               children: [
                    //                 Text(
                    //                     '\$${hourlyRateRange[0].toStringAsFixed(0)} - \$${hourlyRateRange[1].toStringAsFixed(0)}/hr.'),
                    //               ],
                    //             ),
                    //             visualDensity: VisualDensity.compact,
                    //             padding: EdgeInsets.zero,
                    //             // side: BorderSide.none,
                    //           ),
                    //           itemBuilder: (context) => [
                    //             PopupMenuItem(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 4.0),
                    //               value: ProjectType.hourly,
                    //               child: TextField(
                    //                 controller: _minHourlyRateController,
                    //                 autofocus: true,
                    //                 decoration: const InputDecoration(
                    //                     prefixText: '\$',
                    //                     filled: true,
                    //                     border: OutlineInputBorder(),
                    //                     labelText: 'Min.'),
                    //               ),
                    //             ),
                    //             PopupMenuItem(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 4.0),
                    //               value: ProjectType.hourly,
                    //               child: TextField(
                    //                 controller: _maxHourlyRateController,
                    //                 decoration: const InputDecoration(
                    //                     prefixText: '\$',
                    //                     filled: true,
                    //                     border: OutlineInputBorder(),
                    //                     labelText: 'Max.'),
                    //               ),
                    //             ),
                    //             PopupMenuItem(
                    //                 child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 FilledButton(
                    //                   style: FilledButton.styleFrom(
                    //                       alignment: Alignment.center,
                    //                       minimumSize: const Size(80, 32)),
                    //                   onPressed: () {
                    //                     context.pop();
                    //                   },
                    //                   child: const Text('Apply'),
                    //                 ),
                    //               ],
                    //             )),
                    //           ],
                    //         )
                    //       : PopupMenuButton(
                    //           key: const ValueKey('fixed'),
                    //           elevation: 0.3,
                    //           surfaceTintColor: Colors.transparent,
                    //           //  icon: Icon(MdiIcons.filterVariant),
                    //           onOpened: () {
                    //             _minFixedPriceController.text =
                    //                 fixedPriceRange[0].toString();
                    //             _maxFixedPriceController.text =
                    //                 fixedPriceRange[1].toString();
                    //           },
                    //           onSelected: (value) {
                    //             setState(() {
                    //               projectType = value;
                    //             });
                    //           },
                    //           child: Chip(
                    //             label: Row(
                    //               children: [
                    //                 Text(
                    //                     '${convertIntToMoney(fixedPriceRange[0])} - ${convertIntToMoney(fixedPriceRange[1])}'),
                    //               ],
                    //             ),
                    //             visualDensity: VisualDensity.compact,
                    //             padding: EdgeInsets.zero,
                    //             // side: BorderSide.none,
                    //           ),
                    //           itemBuilder: (context) => [
                    //             PopupMenuItem(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 4.0),
                    //               value: ProjectType.hourly,
                    //               child: TextField(
                    //                 controller: _minFixedPriceController,
                    //                 autofocus: true,
                    //                 decoration: const InputDecoration(
                    //                     prefixText: '\$',
                    //                     filled: true,
                    //                     border: OutlineInputBorder(),
                    //                     labelText: 'Min.'),
                    //               ),
                    //             ),
                    //             PopupMenuItem(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 8.0, vertical: 4.0),
                    //               value: ProjectType.hourly,
                    //               child: TextField(
                    //                 controller: _maxFixedPriceController,
                    //                 decoration: const InputDecoration(
                    //                     prefixText: '\$',
                    //                     filled: true,
                    //                     border: OutlineInputBorder(),
                    //                     labelText: 'Max.'),
                    //               ),
                    //             ),
                    //             PopupMenuItem(
                    //                 child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 FilledButton(
                    //                   style: FilledButton.styleFrom(
                    //                       alignment: Alignment.center,
                    //                       minimumSize: const Size(80, 32)),
                    //                   onPressed: () {
                    //                     context.pop();
                    //                   },
                    //                   child: const Text('Apply'),
                    //                 ),
                    //               ],
                    //             )),
                    //           ],
                    //         ),
                    // ),
                    //       const Gutter(),
                    //       TextButton(
                    //           style: TextButton.styleFrom(
                    //               padding: EdgeInsets.zero,
                    //               minimumSize: const Size(80, 32)),
                    //           onPressed: () {},
                    //           child: const Text('Filters')),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchError || profileState is ProfileError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 72.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                              ),
                              const Gutter(),
                              Text('Error Searching Projects..',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.grey[500]
                                              : Colors.grey[600])),
                              const Gutter(),
                              FilledButton(
                                  onPressed: () => context
                                      .read<SearchBloc>()
                                      .add(LoadSearch(context
                                          .read<ProfileBloc>()
                                          .state
                                          .user!)),
                                  child: const Text('Retry'))
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is SearchLoading ||
                        profileState is ProfileLoading) {
                      return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (state is SearchLoaded &&
                        profileState is ProfileLoaded) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: state.projects?.length,
                          (context, index) => Column(
                            children: [
                              index == 0 ? const Divider() : const SizedBox(),
                              index == 0
                                  ? const GutterSmall()
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ProjectCard(
                                  project: state.projects![index],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SliverFillRemaining(
                          child: Center(child: Text('Something went wrong!')));
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

List<ProjectCard> sampleProjectCards = [
  ProjectCard(
    project: Project(
      id: '1',
      clientId: 'l028jt2RgQe5ksneyYdW',
      clientName: 'Dwight Schrute',
      title: 'Create an app for a Veterinarian\'s office patients.',
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
  ProjectCard(
    project: Project(
      id: '2',
      clientId: 'l028jt2RgQe5ksneyYdW',
      clientName: 'Angela Martin',
      title: 'Create an app for a Veterinarian\'s office patients.',
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
  ProjectCard(
    project: Project(
      id: '3',
      clientId: 'l028jt2RgQe5ksneyYdW',
      clientName: 'Kevin Malone',
      title: 'Create an app for a Veterinarian\'s office patients.',
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
  ProjectCard(
    project: Project(
      id: '4',
      clientId: 'l028jt2RgQe5ksneyYdW',
      clientName: 'Micheal Scott',
      title: 'Create an app for a Veterinarian\'s office patients.',
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
  ProjectCard(
    project: Project(
      id: '5',
      clientId: 'l028jt2RgQe5ksneyYdW',
      clientName: 'John Doe',
      title: 'Create an app for a Veterinarian\'s office patients.',
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
];
