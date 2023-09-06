import 'dart:io';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/theme/cubit/theme_cubit.dart';
import 'package:outsourcedx/globals.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/view/mobile/mobile_profile_page.dart';
import 'package:outsourcedx/settings/cubit/bug_report_cubit.dart';
import 'package:outsourcedx/settings/cubit/settings_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../onboarding/bloc/onboarding_bloc.dart';
import '../../models/bug.dart';

class MobileSettingsPage extends StatefulWidget {
  const MobileSettingsPage({super.key});

  @override
  State<MobileSettingsPage> createState() => _MobileSettingsPageState();
}

class _MobileSettingsPageState extends State<MobileSettingsPage> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          MobileSliverAppBar(),
          SliverFillRemaining(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SettingsLoaded || state is SettingsInitial) {
                  return SettingsList(
                    lightTheme: SettingsThemeData(
                        settingsListBackground:
                            Theme.of(context).scaffoldBackgroundColor),
                    darkTheme: SettingsThemeData(
                        settingsListBackground:
                            Theme.of(context).scaffoldBackgroundColor),
                    sections: [
                      SettingsSection(
                        title: const Text('General'),
                        tiles: [
                          SettingsTile(
                            title: const Text('Brightness'),
                            description: const Text('Light/Dark Mode'),
                            leading: const Icon(Icons.brightness_6_outlined),
                            trailing: PopupMenuButton(
                              onSelected: (value) async {
                                context
                                    .read<ThemeCubit>()
                                    .changeBrightness(value == 'light'
                                        ? ThemeMode.light
                                        : value == 'dark'
                                            ? ThemeMode.dark
                                            : ThemeMode.system);
                              },
                              child: FutureBuilder(
                                  future: SharedPreferences.getInstance().then(
                                      (value) => value.getString('themeMode')),
                                  builder: (context, snapshot) {
                                    var themeMode = snapshot.data;
                                    return Row(
                                      children: [
                                        Icon(
                                          themeMode == 'light'
                                              ? Icons.light_mode_outlined
                                              : themeMode == 'dark'
                                                  ? Icons.dark_mode_rounded
                                                  : Icons.phone_iphone,
                                          size: 16.0,
                                        ),
                                        const GutterSmall(),
                                        Text(
                                            themeMode == 'light'
                                                ? 'Light'
                                                : themeMode == 'dark'
                                                    ? 'Dark'
                                                    : 'System',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    );
                                  }),
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'light',
                                  child: Row(
                                    children: [
                                      Icon(Icons.light_mode_outlined,
                                          size: 16.0),
                                      GutterSmall(),
                                      Text('Light'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'dark',
                                  child: Row(
                                    children: [
                                      Icon(Icons.dark_mode_rounded, size: 16.0),
                                      GutterSmall(),
                                      Text('Dark'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'system',
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone_iphone_outlined,
                                          size: 16.0),
                                      GutterSmall(),
                                      Text('System'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text(
                          'Account',
                        ),
                        tiles: [
                          // SettingsTile(
                          //   title: const Text('Email Address'),
                          //   leading: const Icon(Icons.email_outlined),
                          //   onPressed: (BuildContext context) async {
                          //     await showDialog(
                          //       context: context,
                          //       builder: (context) {
                          //         final TextEditingController
                          //             _emailController = TextEditingController(
                          //                 text: context
                          //                     .read<ProfileBloc>()
                          //                     .state
                          //                     .user!
                          //                     .email);
                          //         return AlertDialog(
                          //           title: const Text('Change Email Address'),
                          //           content: const Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               TextField(
                          //                 decoration: InputDecoration(
                          //                   border: OutlineInputBorder(),
                          //                   labelText: 'New Email Address',
                          //                   floatingLabelBehavior:
                          //                       FloatingLabelBehavior.always,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: const Text('Cancel'),
                          //             ),
                          //             FilledButton(
                          //               onPressed: () async {
                          //                 context
                          //                     .read<SettingsCubit>()
                          //                     .updateEmail('email');
                          //                 Navigator.pop(context);
                          //               },
                          //               child: const Text('Change'),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   },
                          // ),
                          SettingsTile(
                              title: const Text('Name'),
                              leading: const Icon(Icons.person_2_outlined),
                              onPressed: (BuildContext context) async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const EditNameDialog());
                              }),
                          SettingsTile(
                              title: const Text('Title'),
                              leading: const Icon(Icons.title_outlined),
                              onPressed: (context) async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => const EditTitleDialog(),
                                );
                              }),
                          SettingsTile(
                            title: const Text(
                              'Bio',
                            ),
                            leading: const Icon(Icons.info_outline_rounded),
                            onPressed: (context) async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return const EditBioDialog();
                                },
                              );
                            },
                          ),
                          SettingsTile(
                            title: const Text('Address'),
                            leading: const Icon(Icons.location_on_outlined),
                            onPressed: (context) async {
                              MapBoxPlace? selectedPlace;
                              final PlacesSearch placesSearch = PlacesSearch(
                                apiKey: dotenv.env['MAPBOX_API_KEY']!,
                                limit: 5,
                                types: [PlaceType.address],
                              );
                              // show address dialog
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Change Address'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Autocomplete<MapBoxPlace>(
                                          displayStringForOption: (option) =>
                                              option.placeName!,
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) async {
                                            if (textEditingValue.text == '') {
                                              return [];
                                            }
                                            List<MapBoxPlace>? matchingPlaces =
                                                await placesSearch.getPlaces(
                                                    textEditingValue.text);

                                            return matchingPlaces ?? [];
                                          },
                                          onSelected: (MapBoxPlace place) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              final textEditingController =
                                                  TextEditingController
                                                      .fromValue(
                                                TextEditingValue.empty,
                                              );
                                              textEditingController.value =
                                                  TextEditingValue.empty;
                                            });

                                            setState(() {
                                              selectedPlace = place;
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
                                          optionsViewBuilder: (BuildContext
                                                  context,
                                              AutocompleteOnSelected<
                                                      MapBoxPlace>
                                                  onSelected,
                                              Iterable<MapBoxPlace> options) {
                                            return Material(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              elevation: 4.0,
                                              child: SizedBox(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  itemCount: options.isNotEmpty
                                                      ? options.length
                                                      : 1,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    if (options.isEmpty) {
                                                      return const ListTile(
                                                        title: Text(
                                                            'No results found'),
                                                      );
                                                    }
                                                    final MapBoxPlace option =
                                                        options
                                                            .elementAt(index);
                                                    bool isHighlighted =
                                                        AutocompleteHighlightedOption
                                                                .of(context) ==
                                                            index;
                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0)),
                                                        tileColor: isHighlighted
                                                            ? Theme.of(context)
                                                                .cardColor
                                                            : null,
                                                        title: Text(
                                                            option.placeName!),
                                                        // subtitle: option.description == null
                                                        //     ? null
                                                        //     : Text(
                                                        //         option.description!,
                                                        //         maxLines: 2,
                                                        //         style:
                                                        //             TextStyle(color: Colors.grey[600]!),
                                                        //       ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              TextEditingController
                                                  textEditingController,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            if (selectedPlace == null) {
                                              textEditingController.text =
                                                  context
                                                          .read<ProfileBloc>()
                                                          .state
                                                          .user
                                                          ?.address ??
                                                      '';
                                            }
                                            return TextFormField(
                                              validator: (value) {
                                                if (selectedPlace == null &&
                                                    context
                                                            .read<
                                                                OnboardingBloc>()
                                                            .state
                                                            .user
                                                            ?.address ==
                                                        null) {
                                                  return 'Please enter your address.';
                                                }
                                                return null;
                                              },
                                              onTap: () {
                                                // clear validation error on tap
                                              },
                                              controller: textEditingController,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                  label: const Text('Address'),
                                                  hintText:
                                                      'Please enter your address..',
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  suffixIcon: IconButton(
                                                      onPressed: () {
                                                        textEditingController
                                                            .clear();
                                                        setState(() {
                                                          selectedPlace = null;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.clear))),
                                              onFieldSubmitted: (String value) {
                                                onFieldSubmitted();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () async {
                                          // context
                                          //     .read<SettingsCubit>()
                                          //     .updateTitle(
                                          //         titleController.value.text);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Change'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SettingsTile(
                            title: const Text('Delete Account'),
                            leading: const Icon(Icons.delete_outline_rounded),
                            onPressed: (BuildContext context) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Account'),
                                  content: const Text(
                                      'Are you sure you want to delete your account forever? (Cannot be undone).'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () async {
                                        context
                                            .read<SettingsCubit>()
                                            .deleteAccount();
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.clear();
                                        context.go('/onboarding');
                                      },
                                      child: const Text('Delete',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text(
                          'About',
                        ),
                        tiles: [
                          SettingsTile(
                            title: const Text('Version'),
                            description: FutureBuilder(
                                future: PackageInfo.fromPlatform(),
                                builder: (context, snapshot) {
                                  var packageInfo = snapshot.data;

                                  return Text(
                                    packageInfo?.version ?? '',
                                  )
                                      .animate(
                                        target: clicked ? 0.0 : 1.0,
                                      )
                                      .shimmer(
                                          color: Colors.white,
                                          duration: const Duration(seconds: 1));
                                }),
                            leading: const Icon(Icons.info_outline),
                            onPressed: (BuildContext context) async {
                              setState(() {
                                clicked = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              setState(() {
                                clicked = false;
                              });
                            },
                          ),
                          SettingsTile(
                            title: const Text('Privacy Policy'),
                            leading: const Icon(Icons.privacy_tip_outlined),
                            onPressed: (BuildContext context) {
                              context.push('/settings/privacy-policy');
                            },
                          ),
                          SettingsTile(
                            title: const Text('Terms of Service'),
                            leading: const Icon(Icons.description_outlined),
                            onPressed: (BuildContext context) {
                              context.push('/settings/terms-of-service');
                            },
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text(
                          'Support',
                        ),
                        tiles: [
                          SettingsTile(
                            title: const Text('Contact Us'),
                            leading: const Icon(Icons.contact_support_outlined),
                            onPressed: (BuildContext context) async {
                              // launch email url
                              Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'support@outsourcedx.com',
                                query: encodeQueryParameters(<String, String>{
                                  'subject': 'OutsourcedX Support',
                                  'body': 'Hi, I need help with...',
                                }),
                              );

                              await launchUrl(emailLaunchUri,
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            },
                          ),
                          SettingsTile(
                            title: const Text('Report a Bug'),
                            leading: const Icon(Icons.bug_report_outlined),
                            onPressed: (BuildContext context) async {
                              // Show bug report dialog
                              await showDialog(
                                context: context,
                                builder: (context) => const BugReportDialog(),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Something Went Wrong...'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BugReportDialog extends StatefulWidget {
  const BugReportDialog({
    super.key,
  });

  @override
  State<BugReportDialog> createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<BugReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report a Bug'),
      content: BlocConsumer<BugReportCubit, BugReportState>(
        listenWhen: (previous, current) =>
            current is BugReportLoading || current is BugReportLoaded,
        listener: (context, state) {
          if (state is BugReportLoaded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is BugReportLoading) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe the bug you encountered below.'),
              const Gutter(),
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bug Title',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'e.g. App crashes when I click on...',
                ),
              ),
              const Gutter(),
              Flexible(
                child: TextField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bug Description',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText:
                        'e.g. I was trying to send a proposal & it gave me a sending error before crashing.',
                  ),
                  maxLines: 5,
                ),
              ),
            ],
          );
        },
      ),
      actions: context.watch<BugReportCubit>().state is BugReportLoading
          ? []
          : [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  context.read<BugReportCubit>().reportBug(
                        Bug(
                          userId: context.read<ProfileBloc>().state.user!.id,
                          platform: Platform.isAndroid ? 'Android' : 'iOS',
                          title: _titleController.value.text,
                          description: _descriptionController.value.text,
                          images: [],
                          date: DateTime.now().toIso8601String(),
                          status: BugStatus.pending,
                        ),
                      );
                },
                child: const Text('Report'),
              ),
            ],
    );
  }
}
