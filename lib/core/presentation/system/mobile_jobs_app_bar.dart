import 'package:flutter/material.dart';

class MobileJobsSliverAppBar extends StatelessWidget {
  const MobileJobsSliverAppBar({super.key});

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
              text: 'Applied',
            ),
            Tab(text: 'Completed')
          ],
        ));
  }
}
