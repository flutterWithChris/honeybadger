import 'package:outsourcedx/core/presentation/drawers/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/message/app_bar/mobile_messages_app_bar.dart';
import 'package:outsourcedx/message/bloc/messages_bloc.dart';
import 'package:outsourcedx/message/info_screens/chat_info_screen.dart';
import 'package:outsourcedx/message/info_screens/group_info_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MobileMessagesPage extends StatefulWidget {
  const MobileMessagesPage({super.key});

  @override
  State<MobileMessagesPage> createState() => _MobileMessagesPageState();
}

class _MobileMessagesPageState extends State<MobileMessagesPage> {
  @override
  void initState() {
    // TODO: implement initState
    try {} catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChatTheme(
      data: StreamChatThemeData.fromTheme(Theme.of(context)),
      child: Scaffold(
        drawer: const MainDrawer(),
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
              BlocBuilder<MessagesBloc, MessagesState>(
                builder: (context, state) {
                  print('Messages State: $state');
                  if (state is MessagesError) {
                    return SliverFillRemaining(
                        child: Center(
                            child: Text(state.errorMessage,
                                style: Theme.of(context).textTheme.bodyLarge)));
                  }
                  if (state is MessagesLoading) {
                    return SliverFillRemaining(
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
                                  size: 72.0,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[500]
                                      : Colors.grey[600]),
                              const Gutter(),
                              LoadingAnimationWidget.beat(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 24.0),
                            ],
                          ),
                        )),
                        const Center(child: Text('No Saved Messages!')),
                      ],
                    ));
                  }
                  if (state is MessagesLoaded) {
                    bool isSearchActive = false;
                    return SliverFillRemaining(
                      child: SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: RefreshIndicator(
                          onRefresh: state.streamChannelListController.refresh,
                          child: StreamChannelListView(
                            padding: EdgeInsets.zero,
                            controller: state.streamChannelListController,
                            itemBuilder:
                                (context, channels, index, defaultWidget) {
                              final chatTheme = StreamChatTheme.of(context);
                              final backgroundColor =
                                  chatTheme.colorTheme.inputBg;
                              final channel = channels[index];
                              final canDeleteChannel = channel.ownCapabilities
                                  .contains(PermissionType.deleteChannel);
                              return Slidable(
                                groupTag: 'channels-actions',
                                endActionPane: ActionPane(
                                  extentRatio: canDeleteChannel ? 0.40 : 0.20,
                                  motion: const BehindMotion(),
                                  children: [
                                    CustomSlidableAction(
                                      backgroundColor: backgroundColor,
                                      onPressed: (_) {
                                        showChannelInfoModalBottomSheet(
                                          context: context,
                                          channel: channel,
                                          onViewInfoTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  final isOneToOne =
                                                      channel.memberCount ==
                                                              2 &&
                                                          channel.isDistinct;
                                                  return StreamChannel(
                                                    channel: channel,
                                                    child: isOneToOne
                                                        ? ChatInfoScreen(
                                                            messageTheme: chatTheme
                                                                .ownMessageTheme,
                                                            user: channel
                                                                .state!.members
                                                                .where((m) =>
                                                                    m.userId !=
                                                                    channel
                                                                        .client
                                                                        .state
                                                                        .currentUser!
                                                                        .id)
                                                                .first
                                                                .user,
                                                          )
                                                        : GroupInfoScreen(
                                                            messageTheme: chatTheme
                                                                .ownMessageTheme,
                                                          ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.more_horiz),
                                    ),
                                    if (canDeleteChannel)
                                      CustomSlidableAction(
                                        backgroundColor: backgroundColor,
                                        child: StreamSvgIcon.delete(
                                          color:
                                              chatTheme.colorTheme.accentError,
                                        ),
                                        onPressed: (_) async {
                                          final res =
                                              await showConfirmationDialog(
                                            context,
                                            title: 'Delete Conversation',
                                            question:
                                                'Are you sure you want to delete this conversation?',
                                            okText: 'Delete',
                                            cancelText: 'Cancel',
                                            icon: StreamSvgIcon.delete(
                                              color: chatTheme
                                                  .colorTheme.accentError,
                                            ),
                                          );
                                          if (res == true) {
                                            await state
                                                .streamChannelListController
                                                .deleteChannel(channel);
                                          }
                                        },
                                      ),
                                  ],
                                ),
                                child: defaultWidget.copyWith(),
                              );
                            },
                            onChannelTap: (channel) {
                              context.push('/messages/channel/${channel.id}',
                                  extra: channel);
                              // Navigator.pushNamed(
                              //   context,
                              //   Routes.CHANNEL_PAGE,
                              //   arguments: ChannelPageArgs(
                              //     channel: channel,
                              //   ),
                              // );
                            },
                            emptyBuilder: (_) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: StreamScrollViewEmptyWidget(
                                    emptyIcon: StreamSvgIcon.message(
                                      size: 148,
                                      color: StreamChatTheme.of(context)
                                          .colorTheme
                                          .disabled,
                                    ),
                                    emptyTitle: TextButton(
                                      onPressed: () {
                                        context.push('/messages/new-chat');
                                      },
                                      child: Text(
                                        'Start a chat',
                                        style: StreamChatTheme.of(context)
                                            .textTheme
                                            .bodyBold
                                            .copyWith(
                                              color: StreamChatTheme.of(context)
                                                  .colorTheme
                                                  .accentPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is MessagesEmpty) {
                    return SliverFillRemaining(
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
                                  size: 72.0,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[500]
                                      : Colors.grey[600]),
                              const Gutter(),
                              Text(
                                'Empty Inbox, Full Potential.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey[500]
                                            : Colors.grey[600]),
                              ),
                            ],
                          ),
                        )),
                        const Center(child: Text('No Saved Messages!')),
                      ],
                    ));
                  }
                  return const SliverFillRemaining(
                      child: Center(child: Text('Something Went Wrong...')));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
