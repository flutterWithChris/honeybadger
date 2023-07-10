import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/search/view/desktop/desktop_search_page.dart';
import 'package:honeybadger/search/view/mobile/mobile_search_page..dart';
import 'package:honeybadger/search/view/tablet/tablet_search_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return const DesktopSearchPage();
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return const TabletSearchPage();
      } else {
        return const MobileSearchPage();
      }
    });
  }
}
