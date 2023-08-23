import 'package:flutter/material.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/message/app_bar/mobile_messages_app_bar.dart';
import 'package:outsourcedx/message/view/desktop/desktop_messages_page.dart';
import 'package:outsourcedx/message/view/mobile/mobile_messages_page.dart';
import 'package:outsourcedx/message/view/tablet/tablet_messages_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > desktopWidthConstraint) {
            return const DesktopMessagesPage();
          } else if (constraints.maxWidth > tabletWidthConstraint) {
            return const TabletMessagesPage();
          } else {
            return const MobileMessagesPage();
          }
        },
      ),
    );
  }
}
