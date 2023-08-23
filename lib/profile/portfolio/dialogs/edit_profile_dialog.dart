import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/portfolio_project.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import '../../../auth/bloc/auth_bloc.dart';

class EditPortfolioProjectDialog extends StatefulWidget {
  final PortfolioProject project;
  const EditPortfolioProjectDialog({required this.project, super.key});

  @override
  State<EditPortfolioProjectDialog> createState() =>
      _EditPortfolioProjectDialogState();
}

class _EditPortfolioProjectDialogState
    extends State<EditPortfolioProjectDialog> {
  List<String> _images = [];
  List<XFile> _newImages = [];
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
  void initState() {
    // TODO: implement initState
    _projectNameController.text = widget.project.title ?? '';
    _projectDescriptionController.text = widget.project.description ?? '';
    _projectLinkController.text = widget.project.url ?? '';
    _projectStart = widget.project.startDate;
    _projectEnd = widget.project.endDate;
    _images = widget.project.images ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocConsumer<PortfolioBloc, PortfolioState>(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                    Text('View Project',
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
                    const GutterSmall(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 3,
                            child: ActionChip(
                              side: BorderSide.none,
                              label: _projectStart != null
                                  ? Text(Jiffy.parseFromDateTime(_projectStart!)
                                      .yMMMd)
                                  : const Text('Project Start'),
                              onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 3650)),
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
                                  ? Text(Jiffy.parseFromDateTime(_projectEnd!)
                                      .yMMMd)
                                  : const Text('Ongoing'),
                              onPressed: () => showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 3650)),
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
                                  _newImages += selectedImages;
                                });
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded,
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
                                      borderRadius: BorderRadius.circular(16),
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
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl:
                                                                      _images[
                                                                          index]),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 2.0,
                                                        left: 2.0,
                                                        child: Opacity(
                                                          opacity: 0.8,
                                                          child:
                                                              IconButton.filled(
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
                                          child: CachedNetworkImage(
                                              imageUrl: _images[index] ?? ''),
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
                                      _newImages = selectedImages;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Icon(Icons.add_circle_outline_rounded,
                                    //     size: 16, color: Colors.grey[600]!),
                                    // const GutterSmall(),
                                    imageValid
                                        ? const SizedBox()
                                        : const Icon(Icons.error_rounded,
                                            size: 20, color: Colors.redAccent),
                                    imageValid
                                        ? const SizedBox()
                                        : const GutterSmall(),
                                    Text(
                                        imageValid
                                            ? 'No Images Selected'
                                            : 'Please add at least one image',
                                        style: const TextStyle(fontSize: 16)),
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
                                context.read<PortfolioBloc>().add(UpdateProject(
                                    project: PortfolioProject(
                                      title: _projectNameController.value.text
                                          .trim(),
                                      description: _projectDescriptionController
                                          .text
                                          .trim(),
                                      url: _projectLinkController.value.text
                                          .trim(),
                                      startDate: _projectStart,
                                      endDate: _projectEnd,
                                    ),
                                    images: _newImages,
                                    userId: context
                                        .read<AuthBloc>()
                                        .state
                                        .user!
                                        .uid));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please fill in all fields')));
                              }
                            },
                            child: const Text('Save')),
                        const Gutter(),
                      ],
                    ),
                    TextButton.icon(
                        onPressed: () => context.read<PortfolioBloc>().add(
                            DeleteProject(
                                project: widget.project,
                                userId: context
                                    .read<ProfileBloc>()
                                    .state
                                    .user!
                                    .id!)),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20.0,
                        ),
                        label: const Text('Delete Project')),
                  ]),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
