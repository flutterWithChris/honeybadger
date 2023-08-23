import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/onboarding/bloc/onboarding_bloc.dart';
import 'package:outsourcedx/onboarding/view/pages/profile_setup/bloc/bloc/category_search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../profile/model/category.dart';

class ClientIndustryPage extends StatefulWidget {
  final PageController? pageController;
  const ClientIndustryPage({required this.pageController, super.key});

  @override
  State<ClientIndustryPage> createState() => _ClientIndustryPageState();
}

class _ClientIndustryPageState extends State<ClientIndustryPage> {
  List<Category> selectedCategories = [];
  String? industry;
  TextEditingController industryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('What industry are you in?',
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gutter(),
              const Row(
                children: [
                  Text(
                    'This gives freelancers helpful context. ',
                    textAlign: TextAlign.left,
                  ),
                  Text('*Optional',
                      style: TextStyle(fontStyle: FontStyle.italic))
                ],
              ),
              const Gutter(),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: industryController,
                onChanged: (value) {
                  setState(() {
                    industry = value;
                  });
                },
                decoration: const InputDecoration(
                  label: Text('Industry'),
                  hintText: 'e.g. eCommerce, Real Estate, etc.',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const Gutter(),
              Text('What kind of work do you need?',
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gutter(),
              const Text(
                'This will help us match you with the right freelancers.',
                textAlign: TextAlign.center,
              ),
              const Gutter(),
              BlocBuilder<CategorySearchBloc, CategorySearchState>(
                builder: (context, state) {
                  Category? newCategory;
                  List<Category> categories = state.categories ?? [];
                  String _displayStringForOption(Category option) =>
                      option.name ?? '';
                  return Autocomplete<Category>(
                    displayStringForOption: _displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text == '') {
                        return const Iterable.empty();
                      }
                      if (textEditingValue.text != '') {
                        context.read<CategorySearchBloc>().add(
                            SearchCategories(query: textEditingValue.text));
                      }
                      List<Category> matchingCategories =
                          state.categories ?? [];

                      if (matchingCategories.isEmpty) {
                        newCategory = Category(
                          name: textEditingValue.text.trim(),
                        );
                        matchingCategories.add(newCategory!);
                      }

                      return matchingCategories;
                    },
                    onSelected: (Category category) {
                      if (category == newCategory) {
                        context
                            .read<CategorySearchBloc>()
                            .add(AddCategory(category: category));
                        // Clear text field
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final textEditingController =
                              TextEditingController.fromValue(
                            TextEditingValue.empty,
                          );
                          textEditingController.value = TextEditingValue.empty;
                        });
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final textEditingController =
                            TextEditingController.fromValue(
                          TextEditingValue.empty,
                        );
                        textEditingController.value = TextEditingValue.empty;
                      });

                      if (selectedCategories.length >= 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'You can only select up to 3 categories.')));
                        return;
                      }
                      print('Categories: $categories');
                      setState(() {
                        selectedCategories.add(category);
                      });
                      // var currentUser =
                      //     context.read<OnboardingBloc>().state.user!;
                      // List<Category> updatedCategories =
                      //     (currentUser.categories ?? [])..add(category);
                      // context.read<OnboardingBloc>().add(UpdateUser(
                      //       currentUser.copyWith(
                      //         categories: updatedCategories,
                      //       ),
                      //     ));
                      // Print categories that are being added
                      // print('Categories being added:');
                      // for (Category category in updatedCategories) {
                      //   print(category.name);
                      // }
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
                            itemCount: options.isNotEmpty ? options.length : 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (options.isEmpty) {
                                return const ListTile(
                                  title: Text('No results found'),
                                );
                              }
                              final Category option = options.elementAt(index);
                              bool isHighlighted =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  leading: option == newCategory
                                      ? const Icon(Icons.add)
                                      : null,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  tileColor: isHighlighted
                                      ? Theme.of(context).cardColor
                                      : null,
                                  title: option == newCategory
                                      ? Text.rich(TextSpan(
                                          text: 'Add ',
                                          children: [
                                            TextSpan(
                                              text: newCategory!.name!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ))
                                      : Text(option.name!),
                                  subtitle: option.description == null
                                      ? null
                                      : Text(
                                          option.description!,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.grey[600]!),
                                        ),
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
                        validator: (value) {
                          if (selectedCategories.isEmpty) {
                            return 'Please enter at least one category.';
                          }
                          return null;
                        },
                        controller: textEditingController,
                        textCapitalization: TextCapitalization.words,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          label: Text('Categories'),
                          hintText: 'Add up to 3 categories..',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
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
                                padding: const EdgeInsets.all(8.0),
                                visualDensity: VisualDensity.compact,
                                label: Text(
                                  category.name!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                onDeleted: () {
                                  // Remove category from user
                                  var currentUser = context
                                      .read<OnboardingBloc>()
                                      .state
                                      .user!;
                                  setState(() {
                                    selectedCategories = selectedCategories
                                      ..remove(category);
                                  });
                                },
                              ))
                          .toList(),
                    ),
              selectedCategories.isEmpty ? const Gutter() : const GutterTiny(),
              selectedCategories.isNotEmpty ||
                      industryController.text.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                var currentUser =
                                    context.read<OnboardingBloc>().state.user!;
                                List<Category> updatedCategories =
                                    (currentUser.categories ?? [])
                                      ..addAll(selectedCategories);
                                context.read<OnboardingBloc>().add(UpdateUser(
                                      currentUser.copyWith(
                                        categories: updatedCategories,
                                      ),
                                    ));
                                context.read<OnboardingBloc>().add(UpdateUser(
                                      currentUser.copyWith(
                                        industry: industryController.value.text
                                            .trim(),
                                        categories: selectedCategories,
                                      ),
                                    ));
                                context.go('/search');
                              }
                            },
                            child: const Text('Finish'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('onboarded', true);
                              context.go('/search');
                            },
                            child: const Text('Skip'),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
