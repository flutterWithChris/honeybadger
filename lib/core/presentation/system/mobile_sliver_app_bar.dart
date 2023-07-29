import 'package:flutter/material.dart';

class MobileSliverAppBar extends StatelessWidget {
  const MobileSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //floating: true,
      //pinned: true,
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
                Image.asset(
                  'assets/honeybee_logo.png',
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF1E2223)
                      : Colors.white,
                  height: 18,
                ),
                Text('Honeybee', style: Theme.of(context).textTheme.titleLarge),
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
