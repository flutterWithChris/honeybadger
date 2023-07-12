import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/message/app_bar/mobile_messages_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileMessagesPage extends StatelessWidget {
  const MobileMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            const MobileMessagesSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: applySearchBarTheme(
                    SearchBar(
                        hintText: 'Search Messages..',
                        hintStyle: MaterialStatePropertyAll(TextStyle(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.8))),
                        trailing: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search_rounded,
                                  color: Theme.of(context).iconTheme.color)),
                        ]),
                    context),
              ),
            ),
            SliverFillRemaining(
                child: TabBarView(
              viewportFraction: 0.9,
              children: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.lightbulbOnOutline,
                          size: 72.0, color: Colors.grey[600]),
                      const Gutter(),
                      Text(
                        'Empty Inbox, Full Potential.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                )),
                const Center(child: Text('No Saved Messages!')),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
