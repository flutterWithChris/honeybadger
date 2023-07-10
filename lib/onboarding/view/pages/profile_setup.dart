import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/onboarding/bloc/onboarding_bloc.dart';
import 'package:honeybadger/onboarding/view/pages/signup_page.dart';

class ProfileSetup extends StatefulWidget {
  final PageController pageController;
  const ProfileSetup({required this.pageController, super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == OnboardingStatus.failure) {
              return const Center(
                child: Text('Error Onboarding...'),
              );
            } else if (state.status == OnboardingStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == OnboardingStatus.loaded) {
              return LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > tabletWidthConstraint) {
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48.0, vertical: 24.0),
                      children: [
                        Text(
                          'Profile Setup',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const GutterLarge(),
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
                                  const CircleAvatar(radius: 40),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: _firstNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              label: Text('First Name')),
                                        ),
                                      ),
                                      const Gutter(),
                                      Flexible(
                                        child: TextField(
                                          controller: _lastNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              label: Text('Last Name')),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gutter(),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                              label: Text('Email')),
                                        ),
                                      ),
                                      const Gutter(),
                                      Flexible(
                                        child: TextField(
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                              label: Text('Phone Number')),
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
                        Row(
                          children: [
                            Flexible(
                              child: SearchBar(
                                controller: _titleController,
                                hintText: 'I am a...',
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.zero),
                                side: const MaterialStatePropertyAll(
                                    BorderSide.none),
                                shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                //backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                shadowColor: const MaterialStatePropertyAll(
                                    Colors.transparent),
                                // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                surfaceTintColor:
                                    const MaterialStatePropertyAll(
                                        Colors.transparent),
                              ),
                            ),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                              controller: _hourlyRateController,
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
                        const TextField(
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.streetAddress,
                            decoration:
                                InputDecoration(label: Text('Address'))),
                        const Gutter(),
                        Row(
                          children: [
                            Flexible(
                                child: TextField(
                                    controller: _cityController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('City')))),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                                    controller: _stateController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('State')))),
                          ],
                        ),
                        const Gutter(),
                        TextField(
                          controller: _bioController,
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
                            widthFactor: 0.2,
                            child: FilledButton.tonal(
                                onPressed: () async {
                                  await widget.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                                child: const Text('Save Profile'))),
                      ]);
                } else if (constraints.maxWidth > desktopWidthConstraint) {
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48.0, vertical: 24.0),
                      children: [
                        Text(
                          'Profile Setup',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const GutterLarge(),
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
                                  const CircleAvatar(radius: 40),
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: _firstNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              label: Text('First Name')),
                                        ),
                                      ),
                                      const Gutter(),
                                      Flexible(
                                        child: TextField(
                                          controller: _lastNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              label: Text('Last Name')),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gutter(),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                              label: Text('Email')),
                                        ),
                                      ),
                                      const Gutter(),
                                      Flexible(
                                        child: TextField(
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                              label: Text('Phone Number')),
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
                        Row(
                          children: [
                            Flexible(
                              child: SearchBar(
                                controller: _titleController,
                                hintText: 'I am a...',
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.zero),
                                side: const MaterialStatePropertyAll(
                                    BorderSide.none),
                                shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                //backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                shadowColor: const MaterialStatePropertyAll(
                                    Colors.transparent),
                                // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                surfaceTintColor:
                                    const MaterialStatePropertyAll(
                                        Colors.transparent),
                              ),
                            ),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                              controller: _hourlyRateController,
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
                            controller: _addressController,
                            keyboardType: TextInputType.streetAddress,
                            decoration:
                                const InputDecoration(label: Text('Address'))),
                        const Gutter(),
                        Row(
                          children: [
                            Flexible(
                                child: TextField(
                                    controller: _cityController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('City')))),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                                    controller: _stateController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('State')))),
                          ],
                        ),
                        const Gutter(),
                        TextField(
                          controller: _bioController,
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
                            widthFactor: 0.2,
                            child: FilledButton.tonal(
                                onPressed: () async {
                                  await widget.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                                child: const Text('Save Profile'))),
                      ]);
                } else {
                  return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
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
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
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
                                          controller: _firstNameController,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: const InputDecoration(
                                              label: Text('First Name')),
                                        ),
                                      ),
                                      const Gutter(),
                                      Flexible(
                                        child: TextField(
                                          controller: _lastNameController,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              label: Text('Last Name')),
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
                        Flexible(
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(label: Text('Email')),
                          ),
                        ),
                        const Gutter(),
                        Flexible(
                          child: TextField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                label: Text('Phone Number')),
                          ),
                        ),
                        const Gutter(),
                        Row(
                          children: [
                            Flexible(
                              child: SearchBar(
                                controller: _titleController,
                                hintText: 'I am a...',
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.zero),
                                side: const MaterialStatePropertyAll(
                                    BorderSide.none),
                                shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                //backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                shadowColor: const MaterialStatePropertyAll(
                                    Colors.transparent),
                                // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                                surfaceTintColor:
                                    const MaterialStatePropertyAll(
                                        Colors.transparent),
                              ),
                            ),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                              controller: _hourlyRateController,
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
                            controller: _addressController,
                            keyboardType: TextInputType.streetAddress,
                            decoration:
                                const InputDecoration(label: Text('Address'))),
                        const Gutter(),
                        Row(
                          children: [
                            Flexible(
                                child: TextField(
                                    controller: _cityController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('City')))),
                            const Gutter(),
                            Flexible(
                                child: TextField(
                                    controller: _stateController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                        label: Text('State')))),
                          ],
                        ),
                        const Gutter(),
                        TextField(
                          controller: _bioController,
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
                                  context
                                      .read<OnboardingBloc>()
                                      .add(UpdateUser(state.user!.copyWith(
                                        firstName:
                                            _firstNameController.value.text,
                                        lastName:
                                            _lastNameController.value.text,
                                        email: _emailController.value.text,
                                        phoneNumber:
                                            _phoneNumberController.value.text,
                                        title: _titleController.value.text,
                                        hourlyRate: double.parse(
                                            _hourlyRateController.value.text),
                                        address: _addressController.value.text,
                                        city: _cityController.value.text,
                                        state: _stateController.value.text,
                                        bio: _bioController.value.text,
                                      )));
                                  await widget.pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                                child: const Text('Save Profile'))),
                      ]);
                }
              });
            } else {
              return const Center(child: Text('Something went wrong...'));
            }
          },
        ),
      ),
    );
  }
}
