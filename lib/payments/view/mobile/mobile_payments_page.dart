import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobilePaymentsPage extends StatelessWidget {
  const MobilePaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            const MobileSliverAppBar(),
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(MdiIcons.rocketLaunchOutline,
                        size: 72.0,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[500]
                            : Colors.grey[600]),
                    const Gutter(),
                    Text('Zero Today, Hero Tomorrow.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600])),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
