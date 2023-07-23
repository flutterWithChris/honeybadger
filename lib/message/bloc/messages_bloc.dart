import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/message/repository/message_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessageRepository _messageRepository;
  late final StreamChannelListController streamChannelListController;
  late final StreamMessageSearchListController?
      streamMessageSearchListController;
  MessagesBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(MessagesInitial()) {
    on<LoadMessages>((event, emit) async {
      streamChannelListController = StreamChannelListController(
          client: _messageRepository.client,
          filter: Filter.in_('members', const [
            'honeybadger',
          ]));
      streamMessageSearchListController = StreamMessageSearchListController(
        client: _messageRepository.client,
        filter: Filter.in_(
          'cid',
          const ['honeybadger'],
        ),
        messageFilter: Filter.in_(
          'attachments.type',
          const ['image', 'video', 'file'],
        ),
        sort: [
          const SortOption(
            'created_at',
            direction: SortOption.ASC,
          ),
        ],
        limit: 20,
      );
      emit(MessagesLoading());
      try {
        await _messageRepository.connectUser(
            'honeybadger', 'Christian Vergara', null);
        await _messageRepository.openConnection();
        await streamChannelListController.doInitialLoad();
        await Future.delayed(const Duration(seconds: 1));
        emit(MessagesLoaded(
            streamChannelListController, streamMessageSearchListController));
      } catch (e) {
        print(e);
        emit(MessagesError(e.toString()));
      }
    });
    on<SendMessage>((event, emit) async {
      try {
        emit(MessageSending());
        List<String> memberIds =
            event.message.mentionedUsers.map((user) => user.id).toList();
        final ChannelState channelState =
            await _messageRepository.createChannel([
                  event.message.user!.id,
                ] +
                memberIds);
        await _messageRepository.sendMessage(
            event.message, channelState.channel!.id);
        emit(MessageSent());
        await Future.delayed(const Duration(seconds: 1));
        emit(MessagesLoaded(
            streamChannelListController, streamMessageSearchListController));
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text(
            'Error Sending Message!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        emit(MessagesError(e.toString()));
      }
    });
    on<CreateConversation>((event, emit) async {
      try {
        await _messageRepository.createChannel(event.memberIds);
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text(
            'Error Creating Conversation!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        emit(MessagesError(e.toString()));
      }
    });
  }
}
