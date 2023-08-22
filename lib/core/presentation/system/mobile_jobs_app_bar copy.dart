import 'package:flutter/material.dart';

class ClientProjectsSliverAppBar extends StatelessWidget {
  const ClientProjectsSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        floating: true,
        pinned: true,
        centerTitle: true,
        leadingWidth: 40,
        // leading: const CircleAvatar(
        //   child: Icon(Icons.person),
        // ),
        title: Theme.of(context).brightness == Brightness.light
            ? Image.asset(
                'assets/logos/OutsourcedX_black_logo.png',
                height: 40,
              )
            : Image.asset(
                'assets/logos/OutsourcedX_White.png',
                height: 40,
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ],
        bottom: const TabBar(
          tabs: [
            Tab(
              text: 'Active',
            ),
            Tab(
              text: 'Open',
            ),
            Tab(
              text: 'Completed',
            ),
          ],
        ));
  }
}
