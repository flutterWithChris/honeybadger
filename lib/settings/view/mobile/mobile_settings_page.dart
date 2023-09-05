import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/theme/cubit/theme_cubit.dart';
import 'package:outsourcedx/globals.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/settings/cubit/bug_report_cubit.dart';
import 'package:outsourcedx/settings/cubit/settings_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/bug.dart';

class MobileSettingsPage extends StatelessWidget {
  const MobileSettingsPage({super.key});

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
                          SettingsTile(
                            title: const Text('Email Address'),
                            leading: const Icon(Icons.email_outlined),
                            onPressed: (BuildContext context) {},
                          ),
                          SettingsTile(
                              title: const Text('Name'),
                              leading: const Icon(Icons.person_2_outlined),
                              onPressed: (BuildContext context) {}),
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
                                      child: const Text('Delete'),
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
                                  );
                                }),
                            leading: const Icon(Icons.info_outline),
                            onPressed: (BuildContext context) {},
                          ),
                          SettingsTile(
                            title: const Text('Privacy Policy'),
                            leading: const Icon(Icons.privacy_tip_outlined),
                            onPressed: (BuildContext context) {},
                          ),
                          SettingsTile(
                            title: const Text('Terms of Service'),
                            leading: const Icon(Icons.description_outlined),
                            onPressed: (BuildContext context) {},
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
      content: BlocBuilder<BugReportCubit, BugReportState>(
        builder: (context, state) {
          if (state is BugReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe the bug you encountered below.'),
              const Gutter(),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bug Title',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'e.g. App crashes when I click on...',
                ),
              ),
              const Gutter(),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bug Description',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText:
                      'e.g. I was trying to send a proposal & it gave me a sending error before crashing.',
                ),
                maxLines: 5,
              ),
            ],
          );
        },
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
            context.read<SettingsCubit>().reportBug(
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
