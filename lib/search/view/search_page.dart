import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/profile/bloc/profile_bloc.dart';
import 'package:OutsourcedX/profile/model/user.dart';
import 'package:OutsourcedX/search/view/desktop/desktop_search_page.dart';
import 'package:OutsourcedX/search/view/mobile/mobile_client_search_page.dart';
import 'package:OutsourcedX/search/view/mobile/mobile_search_page..dart';
import 'package:OutsourcedX/search/view/tablet/tablet_search_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (context.read<ProfileBloc>().state is ProfileInitial) {
      context.read<ProfileBloc>().add(LoadProfile());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > desktopWidthConstraint) {
        return const DesktopSearchPage();
      } else if (constraints.maxWidth > tabletWidthConstraint) {
        return const TabletSearchPage();
      } else {
        if (context.watch<ProfileBloc>().state.user?.userType ==
            UserType.client) {
          return const MobileClientSearchPage();
        }
        return const MobileSearchPage();
      }
    });
  }
}
