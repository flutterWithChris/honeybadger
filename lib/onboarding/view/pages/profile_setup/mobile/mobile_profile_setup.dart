import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/onboarding/view/pages/signup_page.dart';

import '../../../../bloc/onboarding_bloc.dart';

class MobileProfileSetup extends StatefulWidget {
  final PageController pageController;
  const MobileProfileSetup({required this.pageController, super.key});

  @override
  State<MobileProfileSetup> createState() => _MobileProfileSetupState();
}

class _MobileProfileSetupState extends State<MobileProfileSetup> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController hourlyRateController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Setup',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const UserTypeInputChip(),
            ],
          ),
          const Gutter(),
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(radius: 34.0),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  ],
                ),
              )),
              const Gutter(),
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: firstNameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                                label: Text('First Name')),
                          ),
                        ),
                        const Gutter(),
                        Flexible(
                          child: TextField(
                            controller: lastNameController,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            decoration:
                                const InputDecoration(label: Text('Last Name')),
                          ),
                        ),
                      ],
                    ),
                    const Gutter(),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(label: Text('Email')),
          ),
          const Gutter(),
          TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(label: Text('Phone Number')),
          ),
          const Gutter(),
          Row(
            children: [
              Flexible(
                child: SearchBar(
                  controller: titleController,
                  hintText: 'I am a...',
                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  side: const MaterialStatePropertyAll(BorderSide.none),
                  shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
                  //backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                  shadowColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  surfaceTintColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                ),
              ),
              const Gutter(),
              Flexible(
                  child: TextField(
                controller: hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    label: Text('Hourly Rate'),
                    hintText: '40',
                    prefixText: '\$',
                    suffixText: '/hr'),
              ))
            ],
          ),
          const Gutter(),
          TextField(
              textCapitalization: TextCapitalization.words,
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(label: Text('Address'))),
          const Gutter(),
          Row(
            children: [
              Flexible(
                  child: TextField(
                      controller: cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(label: Text('City')))),
              const Gutter(),
              Flexible(
                  child: TextField(
                      controller: stateController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(label: Text('State')))),
            ],
          ),
          const Gutter(),
          TextField(
            controller: bioController,
            textCapitalization: TextCapitalization.sentences,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
                label: Text('Bio'),
                hintText:
                    'Tell clients what you can do for them. Focus on the benefits of working with you & why that matters to them.'),
          ),
          const Gutter(),
          FractionallySizedBox(
              widthFactor: 0.618,
              child: FilledButton.tonal(
                  onPressed: () async {
                    context.read<OnboardingBloc>().add(UpdateUser(
                        context.read<OnboardingBloc>().state.user!.copyWith(
                              firstName: firstNameController.value.text,
                              lastName: lastNameController.value.text,
                              email: emailController.value.text,
                              phoneNumber: phoneNumberController.value.text,
                              title: titleController.value.text,
                              hourlyRate:
                                  double.parse(hourlyRateController.value.text),
                              address: addressController.value.text,
                              city: cityController.value.text,
                              state: stateController.value.text,
                              bio: bioController.value.text,
                            )));
                    await widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: const Text('Save Profile'))),
        ]);
  }
}
