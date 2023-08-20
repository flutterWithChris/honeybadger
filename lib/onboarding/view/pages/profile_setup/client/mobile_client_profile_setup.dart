import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:OutsourcedX/search/repository/search_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../profile/model/category.dart';
import '../../../../../profile/model/user.dart';
import '../../../../bloc/onboarding_bloc.dart';
import '../../../signup_page.dart';

late OverlayEntry _overlayEntry;

class MobileClientProfileSetup extends StatefulWidget {
  final PageController pageController;
  const MobileClientProfileSetup({required this.pageController, super.key});

  @override
  State<MobileClientProfileSetup> createState() =>
      _MobileClientProfileSetupState();
}

class _MobileClientProfileSetupState extends State<MobileClientProfileSetup> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  List<String> selectedSkills = [];
  List<Category> selectedCategories = [];
  CommunicationPreference? communicationPreference;
  bool communicationPreferenceError = false;

  @override
  void initState() {
    // TODO: implement initState
    User user = context.read<OnboardingBloc>().state.user!;
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    titleController.text = user.title ?? '';
    companyController.text = user.company?.toString() ?? '';
    addressController.text = user.address ?? '';
    cityController.text = user.city ?? '';
    stateController.text = user.state ?? '';
    bioController.text = user.bio ?? '';
    selectedCategories =
        context.read<OnboardingBloc>().state.user?.categories ?? [];
    communicationPreference =
        context.read<OnboardingBloc>().state.user?.communicationPreference;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text('First Name')),
                        ),
                      ),
                      const Gutter(),
                      Expanded(
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text('Last Name')),
                        ),
                      ),
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
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('Title'),
                        hintText: 'e.g. Founder'),
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
                    controller: companyController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text('Company'),
                        hintText: 'e.g. Google'),
                  ),
                )
              ],
            ),
            const Gutter(),
            // BlocBuilder<CategorySearchBloc, CategorySearchState>(
            //   builder: (context, state) {
            //     Category? newCategory;
            //     List<Category> categories = state.categories ?? [];
            //     String _displayStringForOption(Category option) =>
            //         option.name ?? '';
            //     return Autocomplete<Category>(
            //       displayStringForOption: _displayStringForOption,
            //       optionsBuilder: (TextEditingValue textEditingValue) async {
            //         if (textEditingValue.text == '') {
            //           return const Iterable.empty();
            //         }
            //         List<Category> matchingCategories = state.categories
            //                 ?.where((category) => category.name!
            //                     .toLowerCase()
            //                     .contains(textEditingValue.text.toLowerCase()))
            //                 .toList() ??
            //             [];

            //         if (matchingCategories.isEmpty) {
            //           newCategory = Category(
            //             name: textEditingValue.text.trim(),
            //           );
            //           matchingCategories.add(newCategory!);
            //         }

            //         return matchingCategories;
            //       },
            //       onSelected: (Category category) {
            //         if (category == newCategory) {
            //           context
            //               .read<CategorySearchBloc>()
            //               .add(AddCategory(category: category));
            //         }
            //         WidgetsBinding.instance.addPostFrameCallback((_) {
            //           final textEditingController =
            //               TextEditingController.fromValue(
            //             TextEditingValue.empty,
            //           );
            //           textEditingController.value = TextEditingValue.empty;
            //         });

            //         if (selectedCategories.length >= 3) {
            //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //               content:
            //                   Text('You can only select up to 3 industries.')));
            //           return;
            //         }
            //         print('Categories: $categories');
            //         setState(() {
            //           selectedCategories.add(category);
            //         });
            //         // var currentUser =
            //         //     context.read<OnboardingBloc>().state.user!;
            //         // List<Category> updatedCategories =
            //         //     (currentUser.categories ?? [])..add(category);
            //         // context.read<OnboardingBloc>().add(UpdateUser(
            //         //       currentUser.copyWith(
            //         //         categories: updatedCategories,
            //         //       ),
            //         //     ));
            //         // Print categories that are being added
            //         // print('Categories being added:');
            //         // for (Category category in updatedCategories) {
            //         //   print(category.name);
            //         // }
            //       },
            //       optionsViewBuilder: (BuildContext context,
            //           AutocompleteOnSelected<Category> onSelected,
            //           Iterable<Category> options) {
            //         return Material(
            //           borderRadius: BorderRadius.circular(16.0),
            //           elevation: 4.0,
            //           child: SizedBox(
            //             child: ListView.builder(
            //               shrinkWrap: true,
            //               padding: const EdgeInsets.all(8.0),
            //               itemCount: options.isNotEmpty ? options.length : 1,
            //               itemBuilder: (BuildContext context, int index) {
            //                 if (options.isEmpty) {
            //                   return const ListTile(
            //                     title: Text('No results found'),
            //                   );
            //                 }
            //                 final Category option = options.elementAt(index);
            //                 bool isHighlighted =
            //                     AutocompleteHighlightedOption.of(context) ==
            //                         index;
            //                 return GestureDetector(
            //                   onTap: () {
            //                     onSelected(option);
            //                   },
            //                   child: ListTile(
            //                     leading: option == newCategory
            //                         ? const Icon(Icons.add)
            //                         : null,
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(16.0)),
            //                     tileColor: isHighlighted
            //                         ? Theme.of(context).cardColor
            //                         : null,
            //                     title: option == newCategory
            //                         ? Text.rich(TextSpan(
            //                             text: 'Add ',
            //                             children: [
            //                               TextSpan(
            //                                 text: newCategory!.name!,
            //                                 style: const TextStyle(
            //                                   fontWeight: FontWeight.bold,
            //                                 ),
            //                               ),
            //                             ],
            //                           ))
            //                         : Text(option.name!),
            //                     subtitle: option.description == null
            //                         ? null
            //                         : Text(
            //                             option.description!,
            //                             maxLines: 2,
            //                             style:
            //                                 TextStyle(color: Colors.grey[600]!),
            //                           ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         );
            //       },
            //       fieldViewBuilder: (BuildContext context,
            //           TextEditingController textEditingController,
            //           FocusNode focusNode,
            //           VoidCallback onFieldSubmitted) {
            //         return TextFormField(
            //           validator: (value) {
            //             if (selectedCategories.isEmpty) {
            //               return 'Please enter at least one industry.';
            //             }
            //             return null;
            //           },
            //           controller: textEditingController,
            //           textCapitalization: TextCapitalization.words,
            //           focusNode: focusNode,
            //           decoration: const InputDecoration(
            //             label: Text('Industries'),
            //             hintText: 'What industry are you in..',
            //             floatingLabelBehavior: FloatingLabelBehavior.always,
            //           ),
            //           onFieldSubmitted: (String value) {
            //             onFieldSubmitted();
            //           },
            //         );
            //       },
            //     );
            //   },
            // ),
            // selectedCategories.isNotEmpty
            //     ? const GutterSmall()
            //     : const SizedBox(),
            // selectedCategories.isEmpty
            //     ? const SizedBox()
            //     : Wrap(
            //         spacing: 8.0,
            //         children: selectedCategories
            //             .map((category) => Chip(
            //                   label: Text(category.name!),
            //                   onDeleted: () {
            //                     // Remove category from user
            //                     var currentUser =
            //                         context.read<OnboardingBloc>().state.user!;
            //                     setState(() {
            //                       selectedCategories = selectedCategories
            //                         ..remove(category);
            //                     });
            //                   },
            //                 ))
            //             .toList(),
            //       ),
            // selectedCategories.isEmpty ? const Gutter() : const GutterSmall(),
            // Communcation preference selection
            const Text(
              'Communication Preference',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const GutterTiny(),
            const Text(
              'How do you prefer communicating with freelancers?',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            const GutterSmall(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        communicationPreference =
                            CommunicationPreference.message;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        border: communicationPreference ==
                                CommunicationPreference.message
                            ? Border.all(
                                width: 2.0,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Column(
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded),
                          GutterSmall(),
                          Text('Messaging'),
                        ],
                      ),
                    ),
                  ),
                ),
                const GutterSmall(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        communicationPreference = CommunicationPreference.video;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        border: communicationPreference ==
                                CommunicationPreference.video
                            ? Border.all(
                                width: 2.0,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Column(
                        children: [
                          Icon(Icons.video_call_outlined),
                          GutterSmall(),
                          Text('Video Call'),
                        ],
                      ),
                    ),
                  ),
                ),
                const GutterSmall(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        communicationPreference = CommunicationPreference.both;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: communicationPreference ==
                                CommunicationPreference.both
                            ? Border.all(
                                width: 2.0,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Column(
                        children: [
                          Icon(Icons.all_inclusive_rounded),
                          GutterSmall(),
                          Text('Any'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const GutterSmall(),
            communicationPreferenceError
                ? Text(
                    'Please select a preference!',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )
                : const SizedBox(),
            const Gutter(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bio.';
                }
                return null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 200.0),
              controller: bioController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(
                label: Text('Bio'),
                hintText:
                    'Tell us a little about yourself & the projects you\'re building. This will be shown on your profile.',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const Gutter(),
            FilledButton(
                onPressed: () async {
                  bool categoryIsValid = selectedCategories.isNotEmpty;
                  if (communicationPreference == null) {
                    setState(() {
                      communicationPreferenceError = true;
                    });
                  } else {
                    setState(() {
                      communicationPreferenceError = false;
                    });
                  }
                  if (_profileFormKey.currentState!.validate() &&
                      communicationPreferenceError == false) {
                    context.read<OnboardingBloc>().add(UpdateUser(
                        context.read<OnboardingBloc>().state.user!.copyWith(
                              firstName: firstNameController.value.text.trim(),
                              lastName: lastNameController.value.text.trim(),
                              email: emailController.value.text.trim(),
                              company: companyController.value.text.trim(),
                              title: titleController.value.text.trim(),
                              address: addressController.value.text.trim(),
                              city: cityController.value.text.trim(),
                              state: stateController.value.text.trim(),
                              bio: bioController.value.text.trim(),
                              categories: selectedCategories,
                              communicationPreference: communicationPreference,
                            )));
                    await widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Whoops! Check over everything again.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )));
                  }
                },
                child: const Text('Submit')),
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
