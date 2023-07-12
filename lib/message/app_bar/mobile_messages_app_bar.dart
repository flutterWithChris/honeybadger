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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.hive_outlined,
                      size: 30.0, color: Colors.blue[600]),
                  Text('Honeybadger',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ],
          ),
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
              text: 'Archived',
            ),
          ],
        ));
  }
}
