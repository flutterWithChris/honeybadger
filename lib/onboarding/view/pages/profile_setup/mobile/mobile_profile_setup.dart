import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/onboarding/view/pages/profile_setup/bloc/bloc/category_search_bloc.dart';
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
  final TextEditingController categoryController = TextEditingController();

  List<String> selectedSkills = [];
  List<Category> selectedCategories = [];
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
    return Form(
      key: _profileFormKey,
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
                  child: TextFormField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(label: Text('Title')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your title.';
                      }
                      return null;
                    },
                  ),
                ),
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
            BlocBuilder<CategorySearchBloc, CategorySearchState>(
              builder: (context, state) {
                List<Category> categories = state.categories ?? [];
                String _displayStringForOption(Category option) =>
                    option.name ?? '';
                return Autocomplete<Category>(
                  displayStringForOption: _displayStringForOption,
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text == '') {
                      return const Iterable.empty();
                    }
                    return state.categories
                            ?.where((category) => category.name!
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList() ??
                        [];
                  },
                  onSelected: (Category category) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final textEditingController =
                          TextEditingController.fromValue(
                        TextEditingValue.empty,
                      );
                      textEditingController.value = TextEditingValue.empty;
                    });
                    setState(() {
                      selectedCategories.add(category);
                      print('Categories: $categories');
                    });
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<Category> onSelected,
                      Iterable<Category> options) {
                    return Material(
                      borderRadius: BorderRadius.circular(16.0),
                      elevation: 4.0,
                      child: SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Category option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.name!),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration:
                          const InputDecoration(label: Text('Categories')),
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                );
              },
            ),

            selectedCategories.isNotEmpty
                ? const GutterSmall()
                : const SizedBox(),
            selectedCategories.isEmpty
                ? const SizedBox()
                : Wrap(
                    spacing: 8.0,
                    children: selectedCategories
                        .map((category) => Chip(
                              label: Text(category.name!),
                              onDeleted: () {
                                setState(() {
                                  selectedCategories.remove(category);
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
            const Gutter(),
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

Future<List<Category>> _searchCategories(String query) async {
  print('Searching categories for $query');
  var hits = await SearchRepository().searchCategories(query).then((value) =>
      value.hits.map((hit) => Category.fromAlgoliaSearch(hit)).toList());
  print('Found ${hits.length} categories for $query');
  return hits;
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
