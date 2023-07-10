import 'package:flutter/material.dart';

class MobileSliverAppBar extends StatelessWidget {
  const MobileSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      //expandedHeight: 80,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 48.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.hive_outlined, size: 30.0, color: Colors.blue[600]),
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
    );
  }
}
