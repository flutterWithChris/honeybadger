import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

class ProfileSetup extends StatelessWidget {
  final PageController pageController;
  const ProfileSetup({required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
          children: [
            Text(
              'Profile Setup',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gutter(),
            const Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(radius: 40),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                )),
                Gutter(),
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              decoration:
                                  InputDecoration(label: Text('First Name')),
                            ),
                          ),
                          Gutter(),
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              decoration:
                                  InputDecoration(label: Text('Last Name')),
                            ),
                          ),
                        ],
                      ),
                      Gutter(),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(label: Text('Email')),
                            ),
                          ),
                          Gutter(),
                          Flexible(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration:
                                  InputDecoration(label: Text('Phone Number')),
                            ),
                          ),
                        ],
                      ),
                      Gutter(),
                    ],
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Flexible(
                  child: SearchBar(
                    hintText: 'I am a...',
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    side: MaterialStatePropertyAll(BorderSide.none),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                    //backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                    shadowColor: MaterialStatePropertyAll(Colors.transparent),
                    // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    surfaceTintColor:
                        MaterialStatePropertyAll(Colors.transparent),
                  ),
                ),
                Gutter(),
                Flexible(
                    child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: Text('Hourly Rate'),
                      hintText: '40',
                      prefixText: '\$',
                      suffixText: '/hr'),
                ))
              ],
            ),
            const Gutter(),
            const TextField(
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(label: Text('Address'))),
            const Gutter(),
            const Row(
              children: [
                Flexible(
                    child: TextField(
                        decoration: InputDecoration(label: Text('City')))),
                Gutter(),
                Flexible(
                    child: TextField(
                        decoration: InputDecoration(label: Text('State')))),
              ],
            ),
            const Gutter(),
            const TextField(
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                  label: Text('Bio'),
                  hintText:
                      'Tell clients what you can do for them. Focus on the benefits of working with you & why that matters to them.'),
            ),
            const Gutter(),
            FractionallySizedBox(
                widthFactor: 0.2,
                child: FilledButton.tonal(
                    onPressed: () async {
                      await pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: const Text('Save Profile'))),
          ]),
    );
  }
}
