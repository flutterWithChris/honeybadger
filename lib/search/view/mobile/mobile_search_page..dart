import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/jobs/model/job.dart';
import 'package:honeybadger/jobs/model/job_category.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/search/view/widgets/job_card.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/presentation/system/main_navigation_bar.dart';

class MobileSearchPage extends StatefulWidget {
  const MobileSearchPage({super.key});

  @override
  State<MobileSearchPage> createState() => _MobileSearchPageState();
}

class _MobileSearchPageState extends State<MobileSearchPage> {
  PaymentType paymentType = PaymentType.fixedPrice;
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
                      hintText: 'Search Jobs..',
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
                            value: PaymentType.hourly,
                            child: Text('Hourly'),
                          ),
                          const PopupMenuItem(
                            value: PaymentType.fixedPrice,
                            child: Text('Fixed Price'),
                          ),
                        ],
                      ),
                      const Gutter(),
                      paymentType == PaymentType.hourly
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
                                  value: PaymentType.hourly,
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
                                  value: PaymentType.hourly,
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
                                  value: PaymentType.hourly,
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
                                  value: PaymentType.hourly,
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
                  child: JobCard(
                    job: Job(
                      id: '1',
                      client: User(
                          id: '5',
                          firstName: 'John',
                          lastName: 'Doe',
                          city: 'San Francisco',
                          state: 'CA',
                          photoUrl: '',
                          email: '',
                          ratingCount: 4,
                          rating: 4.5),
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile App Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
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
                  child: JobCard(
                    job: Job(
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
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile App Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
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
                  child: JobCard(
                    job: Job(
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
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile App Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
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
                  child: JobCard(
                    job: Job(
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
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile App Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
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
                  child: JobCard(
                    job: Job(
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
                      title:
                          'Create an app for a Veterinarian\'s office patients.',
                      description:
                          'Flutter Developer needed for a project. We are looking for someone who can work with us long term.\n\nCreating an app for a local veterinarian who\'d like a way for patients to check in and pay through their phone.',
                      budget: 10000,
                      duration: JobDuration.recurring,
                      skills: ['Flutter', 'Dart', 'Firebase'],
                      category: JobCategory(
                        id: '1',
                        name: 'Mobile App Development',
                      ),
                      paymentType: PaymentType.fixedPrice,
                      visibility: JobVisibility.public,
                      status: JobStatus.open,
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
