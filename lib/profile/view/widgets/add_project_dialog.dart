import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/auth/bloc/auth_bloc.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/profile/model/portfolio_project.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({
    super.key,
  });

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  List<XFile> _images = [];
  String projectLink = '';
  var _previewData;
  final TextEditingController _projectLinkController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  DateTime? _projectStart;
  DateTime? _projectEnd;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool imageValid = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                const Gutter(),
                Text('Add to Portfolio',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Gutter(),
                const TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                const Row(
                  children: [
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project Start'),
                        ),
                      ),
                    ),
                    Gutter(),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project End'),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gutter(),
                const TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Project Description'),
                  ),
                ),
                const Gutter(),
                TextField(
                  controller: _projectLinkController,
                  onChanged: (value) {
                    setState(() {
                      projectLink = value;
                      print('Project Link: $projectLink');
                    });
                  },
                  onTapOutside: (event) {
                    setState(() {
                      projectLink = _projectLinkController.value.text;
                    });
                  },
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    label: Text('Project Link'),
                  ),
                ),
                projectLink.isNotEmpty
                    ? LinkPreview(
                        width: 200,
                        onPreviewDataFetched: (p0) {
                          setState(() {
                            _previewData = p0;
                          });
                        },
                        previewData: _previewData,
                        text: projectLink)
                    : const SizedBox.shrink(),
                const Gutter(),
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: Colors.grey[600]!),
                          const GutterSmall(),
                          const Text('Drag & Drop Images',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gutter(),
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const Gutter(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    const Gutter(),
                  ],
                )
              ]);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
              children: [
                const Gutter(),
                Text('Add Project',
                    style: Theme.of(context).textTheme.headlineMedium),
                const Gutter(),
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                const Row(
                  children: [
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project Start'),
                        ),
                      ),
                    ),
                    Gutter(),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          label: Text('Project End'),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gutter(),
                const TextField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    label: Text('Project Description'),
                  ),
                ),
                const Gutter(),
                const TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    label: Text('Project Link'),
                  ),
                ),
                const Gutter(),
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: Colors.grey[600]!),
                          const GutterSmall(),
                          const Text('Drag & Drop Images',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gutter(),
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const Gutter(),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Add')),
                    const Gutter(),
                  ],
                )
              ]);
        } else {
          return BlocConsumer<PortfolioBloc, PortfolioState>(
            listenWhen: (previous, current) =>
                previous is PortfolioLoading && current is PortfolioLoaded,
            listener: (context, state) async {
              if (state is PortfolioLoaded) {
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is PortfolioError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(
                      Icons.error_rounded,
                      color: Colors.red,
                      size: 72,
                    ),
                    const Gutter(),
                    const Text('Error Loading Portfolio..',
                        style: TextStyle(fontSize: 18)),
                    const Gutter(),
                    FilledButton(
                      onPressed: () {
                        context.read<PortfolioBloc>().add(LoadPortfolio(
                            userId: context.read<AuthBloc>().state.user!.uid));
                      },
                      child: const Text('Retry'),
                    )
                  ]),
                );
              }
              if (state is PortfolioLoading) {
                return const Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(),
                  ),
                ]);
              }
              if (state is PortfolioLoaded || state is PortfolioInitial) {
                return Form(
                  key: formKey,
                  child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      children: [
                        Text('Add to Portfolio',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Gutter(),
                        TextFormField(
                          controller: _projectNameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Project Name'),
                          ),
                        ),
                        const Gutter(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                flex: 3,
                                child: ActionChip(
                                  side: BorderSide.none,
                                  label: _projectStart != null
                                      ? Text(Jiffy.parseFromDateTime(
                                              _projectStart!)
                                          .yMMMd)
                                      : const Text('Project Start'),
                                  onPressed: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 3650)),
                                          lastDate: DateTime.now())
                                      .then((value) => setState(() {
                                            _projectStart = value;
                                          })),
                                )),
                            const Expanded(child: Center(child: Text('to'))),
                            Flexible(
                                flex: 3,
                                child: ActionChip(
                                  side: BorderSide.none,
                                  label: _projectEnd != null
                                      ? Text(
                                          Jiffy.parseFromDateTime(_projectEnd!)
                                              .yMMMd)
                                      : const Text('Ongoing'),
                                  onPressed: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 3650)),
                                          lastDate: DateTime.now())
                                      .then((value) => setState(() {
                                            _projectEnd = value;
                                          })),
                                )),
                          ],
                        ),
                        const Gutter(),
                        TextFormField(
                          controller: _projectDescriptionController,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            label: Text('Project Description'),
                          ),
                        ),
                        const Gutter(),
                        TextFormField(
                          controller: _projectLinkController,
                          validator: (value) {
                            if (value != null) {
                              try {
                                var url = Uri.parse(value);
                              } catch (e) {
                                return 'Please enter a valid URL';
                              }
                            }
                            return null;
                          },
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            label: Text('Project Link'),
                            prefixText: 'https://',
                          ),
                        ),
                        const Gutter(),
                        Row(
                          children: [
                            Text('Images',
                                style: Theme.of(context).textTheme.titleLarge),
                            const GutterTiny(),
                            IconButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  List<XFile> selectedImages =
                                      await picker.pickMultiImage();
                                  if (selectedImages.isNotEmpty) {
                                    print('images selected');
                                    setState(() {
                                      _images += selectedImages;
                                    });
                                  }
                                },
                                icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 20)),
                          ],
                        ),
                        const GutterSmall(),
                        SizedBox(
                          height: 200,
                          child: _images.isNotEmpty
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _images.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: SizedBox(
                                            height: 200,
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        alignment:
                                                            Alignment.topLeft,
                                                        children: [
                                                          Card(
                                                            child: SizedBox(
                                                              child: Image.file(
                                                                File(_images[
                                                                        index]
                                                                    .path),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 2.0,
                                                            left: 2.0,
                                                            child: Opacity(
                                                              opacity: 0.8,
                                                              child: IconButton
                                                                  .filled(
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .pop();
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close_rounded,
                                                                          size:
                                                                              16)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.file(
                                                File(_images[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4.0,
                                          left: 4.0,
                                          child: SizedBox(
                                            height: 28,
                                            child: FittedBox(
                                              child: Opacity(
                                                opacity: 0.8,
                                                child: IconButton.filled(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        foregroundColor:
                                                            Colors.white),
                                                    onPressed: () {
                                                      setState(() {
                                                        _images.removeAt(index);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove_rounded,
                                                        size: 24)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // TODO: Mark as cover
                                        index == 0
                                            ? Positioned(
                                                bottom: 0,
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    height: 48,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const GutterSmall(),
                                )
                              : Container(
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: imageValid
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();
                                      List<XFile> selectedImages =
                                          await picker.pickMultiImage();
                                      if (selectedImages.isNotEmpty) {
                                        print('images selected');
                                        setState(() {
                                          _images = selectedImages;
                                        });
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.add_circle_outline_rounded,
                                        //     size: 16, color: Colors.grey[600]!),
                                        // const GutterSmall(),
                                        imageValid
                                            ? const SizedBox()
                                            : const Icon(Icons.error_rounded,
                                                size: 20,
                                                color: Colors.redAccent),
                                        imageValid
                                            ? const SizedBox()
                                            : const GutterSmall(),
                                        Text(
                                            imageValid
                                                ? 'No Images Selected'
                                                : 'Please add at least one image',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const Gutter(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            const Gutter(),
                            FilledButton(
                                onPressed: () {
                                  if (_images.isEmpty) {
                                    setState(() {
                                      imageValid = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please select at least one image')));
                                    return;
                                  }
                                  if (formKey.currentState!.validate()) {
                                    context.read<PortfolioBloc>().add(
                                        AddProject(
                                            project: PortfolioProject(
                                              title: _projectNameController
                                                  .value.text
                                                  .trim(),
                                              description:
                                                  _projectDescriptionController
                                                      .text
                                                      .trim(),
                                              url: _projectLinkController
                                                  .value.text
                                                  .trim(),
                                              startDate: _projectStart,
                                              endDate: _projectEnd,
                                            ),
                                            images: _images,
                                            userId: context
                                                .read<AuthBloc>()
                                                .state
                                                .user!
                                                .uid));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill in all fields')));
                                  }
                                },
                                child: const Text('Add Project')),
                            const Gutter(),
                          ],
                        )
                      ]),
                );
              } else {
                return const Center(child: Text('Something went wrong'));
              }
            },
          );
        }
      }),
    );
  }
}
