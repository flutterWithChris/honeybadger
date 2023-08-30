import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/theme/cubit/theme_cubit.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            child: SettingsList(
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
                      leading: const Icon(Icons.brightness_6),
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
                            future: SharedPreferences.getInstance()
                                .then((value) => value.getString('themeMode')),
                            builder: (context, snapshot) {
                              var themeMode = snapshot.data;
                              return Row(
                                children: [
                                  Icon(
                                    themeMode == 'light'
                                        ? Icons.light_mode_outlined
                                        : themeMode == 'dark'
                                            ? Icons.dark_mode_rounded
                                            : Icons.settings_outlined,
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
                                Icon(Icons.light_mode_outlined, size: 16.0),
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
                                Icon(Icons.settings_outlined, size: 16.0),
                                GutterSmall(),
                                Text('System'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SettingsTile(
                      title: const Text('Location'),
                      leading: const Icon(Icons.map),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile(
                      title: const Text('Delete Account'),
                      leading: const Icon(Icons.delete),
                      onPressed: (BuildContext context) {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
