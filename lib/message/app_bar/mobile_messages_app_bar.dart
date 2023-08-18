import 'package:flutter/material.dart';

class MobileMessagesSliverAppBar extends StatelessWidget {
  const MobileMessagesSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        floating: true,
        pinned: true,
        centerTitle: true,
        leadingWidth: 40,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/logos/OutsourcedX_black_logo.png'
                : 'assets/logos/OutsourcedX_White.png',
            height: 40,
          ),
        ),
        bottom: const TabBar(
          tabs: [
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Archived',
            ),
          ],
        ));
  }
}
