import 'package:jiffy/jiffy.dart';
import 'package:outsourcedx/profile/model/portfolio_project.dart';
import 'package:outsourcedx/profile/portfolio/bloc/portfolio_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../auth/bloc/auth_bloc.dart';

class ViewPortfolioProjectDialog extends StatefulWidget {
  final PortfolioProject project;
  const ViewPortfolioProjectDialog({required this.project, super.key});

  @override
  State<ViewPortfolioProjectDialog> createState() =>
      _ViewPortfolioProjectDialogState();
}

class _ViewPortfolioProjectDialogState
    extends State<ViewPortfolioProjectDialog> {
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
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  children: [
                    Text(widget.project.title!,
                        style: Theme.of(context).textTheme.titleLarge),
                    const Gutter(),
                    SizedBox(
                      height: 280,
                      child: _images.isNotEmpty
                          ? _images.length == 1
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Card(
                                                  child: SizedBox(
                                                    child: CachedNetworkImage(
                                                        imageUrl: _images[0],
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: CachedNetworkImage(
                                        imageUrl: _images[0] ?? '',
                                        fit: BoxFit.cover),
                                  ))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _images.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        height: 280,
                                        child: InkWell(
                                          onTap: () async {
                                            await showDialog(
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
                                                                          index],
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CachedNetworkImage(
                                              imageUrl: _images[index],
                                              fit: BoxFit.cover),
                                        ),
                                      ),
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
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const GutterTiny(),
                    if (widget.project.startDate != null &&
                        widget.project.endDate != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 12.0,
                          ),
                          const GutterTiny(),
                          Text(
                              '${Jiffy.parseFromDateTime(_projectStart!).yMMMd} - ${Jiffy.parseFromDateTime(_projectEnd!).yMMMd}',
                              style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ),
                    if (widget.project.startDate != null &&
                        widget.project.endDate == null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 12.0,
                          ),
                          const GutterTiny(),
                          Text(
                              '${Jiffy.parseFromDateTime(_projectStart!).yMMMd} - Ongoing',
                              style: Theme.of(context).textTheme.bodySmall)
                        ],
                      ),
                    const GutterTiny(),
                    Text(widget.project.description!,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const GutterSmall(),
                    if (widget.project.url != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('Link',
                          //     style: Theme.of(context).textTheme.titleSmall),
                          Flexible(
                            child: OutlinedButton.icon(
                                onPressed: () async {
                                  await launchUrlString(widget.project.url!,
                                      mode: LaunchMode.externalApplication);
                                },
                                icon: const Icon(Icons.link_rounded),
                                label: Text(
                                  widget.project.url!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ],
                      ),
                    const GutterTiny(),
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
