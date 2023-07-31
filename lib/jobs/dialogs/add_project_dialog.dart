import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:image_picker/image_picker.dart';

class AddProjectDialog extends StatelessWidget {
  const AddProjectDialog({
    super.key,
  });

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
                Text('Add Project',
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
                Text('Add Project',
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
                Text('Images', style: Theme.of(context).textTheme.titleLarge),
                const Gutter(),
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> image = await picker.pickMultiImage();
                    },
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 16, color: Colors.grey[600]!),
                          const GutterSmall(),
                          const Text('Add Images',
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
