import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/message/app_bar/mobile_messages_app_bar.dart';
import 'package:honeybadger/message/view/desktop/desktop_messages_page.dart';
import 'package:honeybadger/message/view/mobile/mobile_messages_page.dart';
import 'package:honeybadger/message/view/tablet/tablet_messages_page.dart';

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
