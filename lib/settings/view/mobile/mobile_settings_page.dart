import 'package:OutsourcedX/core/presentation/system/main_navigation_bar.dart';
import 'package:OutsourcedX/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
                        child: Row(
                          children: [
                            Text(
                              Theme.of(context).brightness == Brightness.light
                                  ? 'Light'
                                  : 'Dark',
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            child: Text('Light'),
                          ),
                          const PopupMenuItem(
                            child: Text('Dark'),
                          ),
                          const PopupMenuItem(
                            child: Text('System Default'),
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
