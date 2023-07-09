import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

class MainSliverAppBar extends StatelessWidget {
  const MainSliverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      // toolbarHeight: 80,
      leadingWidth: 240,
      flexibleSpace: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          const GutterLarge(),
          TextButton(
              onPressed: () {},
              child: Text(
                'Home',
                style: Theme.of(context).textTheme.titleMedium,
              )),
          const GutterLarge(),
          TextButton(
              onPressed: () {},
              child: Text(
                'About',
                style: Theme.of(context).textTheme.titleMedium,
              )),
          const GutterLarge(),
          TextButton(
              onPressed: () {},
              child: Text(
                'Contact',
                style: Theme.of(context).textTheme.titleMedium,
              )),
          const GutterLarge(),
        ]),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 12.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(Icons.pets, size: 30.0, color: Colors.grey[800]),
            Text('Honeybadger', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Login')),
        const Gutter(),
        ElevatedButton(
            onPressed: () {}, style: null, child: const Text('Sign Up')),
        const Gutter(),
      ],
    );
  }
}
