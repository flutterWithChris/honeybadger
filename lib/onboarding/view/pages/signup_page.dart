import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create Your Account.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Gutter(),
          Wrap(
            spacing: 12.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: const Icon(FontAwesomeIcons.google, size: 20.0),
              ),
              FilledButton.tonal(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black87,
                ),
                onPressed: () {},
                child: const Icon(FontAwesomeIcons.apple, size: 20.0),
              ),
              FilledButton(
                onPressed: () {},
                child: const Icon(FontAwesomeIcons.github, size: 20.0),
              ),
            ],
          ),
          const GutterSmall(),
          const Text('or',
              style: TextStyle(color: Colors.grey, fontSize: 18.0)),
          const GutterSmall(),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.magicWandSparkles, size: 16.0),
              label: const Text('Send a Magic Link'),
              style: ElevatedButton.styleFrom(elevation: 0.6)),
        ],
      ),
    ));
  }
}
