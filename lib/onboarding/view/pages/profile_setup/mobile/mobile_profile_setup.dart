import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:honeybadger/search/repository/search_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';

import '../../../../../profile/model/category.dart';
import '../../../../../profile/model/user.dart';
import '../../../../bloc/onboarding_bloc.dart';
import '../../../signup_page.dart';

late OverlayEntry _overlayEntry;

class MobileProfileSetup extends StatefulWidget {
  final PageController pageController;
  const MobileProfileSetup({required this.pageController, super.key});

  @override
  State<MobileProfileSetup> createState() => _MobileProfileSetupState();
}

class _MobileProfileSetupState extends State<MobileProfileSetup> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final PhoneNumberEditingController phoneNumberController =
      PhoneNumberEditingController(PhoneNumberUtil(), regionCode: 'US');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _skillsController = TextEditingController();

  final List<String> _skills = [];
  Category? _selectedCategory;
  @override
  void initState() {
    // TODO: implement initState
    User user = context.read<OnboardingBloc>().state.user!;
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    phoneNumberController.text = user.phoneNumber ?? '';
    titleController.text = user.title ?? '';
    hourlyRateController.text = user.hourlyRate?.toString() ?? '';
    addressController.text = user.address ?? '';
    cityController.text = user.city ?? '';
    stateController.text = user.state ?? '';
    bioController.text = user.bio ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).unfocus(),
      child: ListView(
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
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                          radius: 34.0,
                          foregroundImage: CachedNetworkImageProvider(context
                              .watch<OnboardingBloc>()
                              .state
                              .user!
                              .photoUrl!),
                          child: const Icon(Icons.person)),
                      Positioned(
                        right: -10,
                        bottom: -8,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          child: InkWell(
                            onTap: () async {
                              await ImagePicker()
                                  .pickImage(source: ImageSource.gallery)
                                  .then((profilePicture) {
                                if (profilePicture != null) {
                                  context.read<OnboardingBloc>().add(
                                      SetUserProfilePicture(
                                          profilePicture,
                                          context
                                              .read<OnboardingBloc>()
                                              .state
                                              .user!));
                                }
                                return profilePicture;
                              });
                            },
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                const Gutter(),
                Flexible(
                  flex: 3,
                  child: Form(
                    key: _profileFormKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name.';
                                  }
                                  return null;
                                },
                                controller: firstNameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                    label: Text('First Name')),
                              ),
                            ),
                            const Gutter(),
                            Flexible(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name.';
                                  }
                                  return null;
                                },
                                controller: lastNameController,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    label: Text('Last Name')),
                              ),
                            ),
                          ],
                        ),
                        // const Gutter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // TextFormField(
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter your email address.';
            //     }
            //     if (EmailValidator.validate(value) == false) {
            //       return 'Please enter a valid email address.';
            //     }

            //     return null;
            //   },
            //   controller: emailController,
            //   keyboardType: TextInputType.emailAddress,
            //   decoration: const InputDecoration(label: Text('Email')),
            // ),
            const Gutter(),
            Row(
              children: [
                Flexible(
                  child: TypeAheadField(
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(label: Text('Title'))),
                    suggestionsCallback: (query) async {
                      return await _searchCategories(query);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.name!),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      /// Show 'No Results Found
                      /// And chip with 'Add $suggestion'
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No Results Found',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const GutterSmall(),
                            OutlinedButton.icon(
                              onPressed: () {
                                titleController.text =
                                    titleController.value.text.trim();
                              },
                              icon: const Icon(Icons.add_circle_rounded),
                              label: Text(titleController.value.text.trim()),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context) => const ListTile(
                      title: Text('Loading...'),
                    ),
                    onSuggestionSelected: (suggestion) {
                      print('Suggetion selected: $suggestion');
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setState(() {
                          titleController.text = suggestion.name!;
                        });
                      });
                    },
                  ),
                ),
                // const TitleSelection(),
                const Gutter(),
                Flexible(
                    child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your hourly rate.';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid hourly rate.';
                    }
                    return null;
                  },
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
            TypeAheadField(
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _skillsController,
                    decoration: const InputDecoration(label: Text('Skills'))),
                suggestionsCallback: (query) {
                  return [
                    'Python',
                    'Java',
                    'C++',
                    'C#',
                    'JavaScript',
                    'HTML',
                    'CSS',
                    'Flutter',
                    'Dart',
                    'React',
                    'React Native',
                    'Angular',
                    'Vue',
                    'Node.js',
                  ].where((suggestion) => suggestion.toLowerCase().contains(
                      query.toLowerCase().trim().replaceAll(' ', '')));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                itemSeparatorBuilder: (context, index) => const Divider(),
                onSuggestionSelected: (suggestion) {
                  _skillsController.clear();
                  if (!_skills.contains(suggestion)) {
                    _skills.add(suggestion);
                  }
                }),
            _skills.isNotEmpty ? const Gutter() : const SizedBox(),

            Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: _skills
                  .map((skill) => Chip(
                        label: Text(skill),
                        onDeleted: () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        },
                      ))
                  .toList(),
            ),
            const Gutter(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bio.';
                }
                return null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 150.0),
              controller: bioController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(
                  label: Text('Bio'),
                  hintText:
                      'Tell clients what you can do for them. Focus on the benefits of working with you & why that matters to them.'),
            ),
            // const TextField(
            //   minLines: 5,
            //   maxLines: 7,
            //   decoration: InputDecoration(
            //     label: Text('Skills'),
            //     hintText:
            //         'Type your skills here. Ex: Python, Graphic Design, etc.',
            //   ),
            // ),
            const Gutter(),
            // Text('Portfolio', style: Theme.of(context).textTheme.headlineLarge),
            // const GutterSmall(),
            // Text(
            //     'Create projects to add images & links of your past work, if you have any.',
            //     style: Theme.of(context).textTheme.bodyLarge),
            // const Gutter(),
            // Row(
            //   children: [
            //     Flexible(
            //       child: FractionallySizedBox(
            //         widthFactor: 0.5,
            //         child: AspectRatio(
            //           aspectRatio: 1,
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.grey),
            //                 borderRadius: BorderRadius.circular(16.0)),
            //             child: InkWell(
            //               onTap: () {
            //                 showDialog(
            //                   context: context,
            //                   builder: (context) {
            //                     return const AddProjectDialog();
            //                   },
            //                 );
            //               },
            //               child: Center(
            //                 child: Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Icon(Icons.add_circle_outline_rounded,
            //                         size: 16, color: Colors.grey[600]!),
            //                     const GutterSmall(),
            //                     const Text('Create Project',
            //                         style: TextStyle(fontSize: 16)),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            FractionallySizedBox(
                widthFactor: 0.618,
                child: FilledButton(
                    onPressed: () async {
                      bool categoryIsValid = _selectedCategory != null;

                      if (_profileFormKey.currentState!.validate() &&
                          categoryIsValid) {
                        context.read<OnboardingBloc>().add(UpdateUser(context
                            .read<OnboardingBloc>()
                            .state
                            .user!
                            .copyWith(
                              firstName: firstNameController.value.text.trim(),
                              lastName: lastNameController.value.text.trim(),
                              email: emailController.value.text.trim(),
                              phoneNumber:
                                  phoneNumberController.value.text.trim(),
                              title: titleController.value.text.trim(),
                              hourlyRate: double.parse(
                                  hourlyRateController.value.text.trim()),
                              address: addressController.value.text.trim(),
                              city: cityController.value.text.trim(),
                              state: stateController.value.text.trim(),
                              bio: bioController.value.text.trim(),
                            )));
                        await widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      } else {
                        if (categoryIsValid == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                  content: Text('Please select a category.')));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                                content: Text(
                                    'Please fill out all required fields.')));
                      }
                    },
                    child: const Text('Submit'))),
          ]),
    );
  }
}

Future<List<Category>> _searchCategories(String query) {
  return SearchRepository().searchCategories(query).then((value) =>
      value.hits.map((hit) => Category.fromAlgoliaSearch(hit)).toList());
}

class TitleSelection extends StatefulWidget {
  const TitleSelection({Key? key}) : super(key: key);

  @override
  _TitleSelectionState createState() => _TitleSelectionState();
}

class _TitleSelectionState extends State<TitleSelection> {
  final titleKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  List<String> suggestions = [
    'Mobile Developer',
    'Graphic Designer',
    'Software Engineer'
  ];
  List<String> visibleSuggestions = [];
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    _overlayEntry = OverlayEntry(builder: (context) {
      final renderBox =
          titleKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);

      return Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: visibleSuggestions
                .map((suggestion) => ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        titleController.text = suggestion;
                        visibleSuggestions = [];
                        _overlayEntry.markNeedsBuild();
                        _focusNode.unfocus(); // close keyboard
                      },
                    ))
                .toList(),
          ),
        ).animate().slideY(
              duration: 800.ms,
              begin: 0.5,
              end: 0,
              curve: Curves.easeInOutCubic,
            ),
      );
    });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Overlay.of(context).insert(_overlayEntry);
    } else {
      _overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SearchBar(
        key: titleKey,
        controller: titleController,
        hintText: 'I am a...',
        focusNode: _focusNode,
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        side: const MaterialStatePropertyAll(BorderSide.none),
        shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)))),
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
        onChanged: (query) {
          setState(() {
            visibleSuggestions = suggestions
                .where((suggestion) =>
                    suggestion.toLowerCase().contains(query.toLowerCase()))
                .toList();
          });
          _overlayEntry.markNeedsBuild();
        },
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
