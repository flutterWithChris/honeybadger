import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:image_picker/image_picker.dart';

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
          return ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                const Gutter(),
                Text('Add to Portfolio',
                    style: Theme.of(context).textTheme.headlineMedium),
                const GutterLarge(),
                const TextField(
                  decoration: InputDecoration(
                    label: Text('Project Name'),
                  ),
                ),
                const Gutter(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: ActionChip(
                      side: BorderSide.none,
                      label: const Text('Project Start'),
                      onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 3650)),
                          lastDate: DateTime.now()),
                    )),
                    Flexible(
                        child: ActionChip(
                      side: BorderSide.none,
                      label: const Text('Project End'),
                      onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 3650)),
                          lastDate: DateTime.now()),
                    )),
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
                Row(
                  children: [
                    Text('Images',
                        style: Theme.of(context).textTheme.titleLarge),
                    const GutterTiny(),
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          List<XFile> selectedImages =
                              await picker.pickMultipleMedia();
                          if (selectedImages.isNotEmpty) {
                            print('images selected');
                            setState(() {
                              _images += selectedImages;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle_rounded, size: 20)),
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
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  Card(
                                                    child: SizedBox(
                                                      child: Image.file(
                                                        File(_images[index]
                                                            .path),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 2.0,
                                                    left: 2.0,
                                                    child: SizedBox(
                                                      height: 48,
                                                      child: FittedBox(
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
                                                foregroundColor: Colors.white),
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
                                            width: double.infinity,
                                            color:
                                                Colors.white.withOpacity(0.8),
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
                              border: Border.all(color: Colors.grey),
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
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon(Icons.add_circle_outline_rounded,
                                //     size: 16, color: Colors.grey[600]!),
                                // const GutterSmall(),
                                Text('No Images Selected',
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
        }
      }),
    );
  }
}
