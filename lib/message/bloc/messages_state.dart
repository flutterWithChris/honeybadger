part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  final Message? message;

  const MessagesState({this.message});

  @override
  List<Object?> get props => [message];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  fin
  final StreamChannelListController streamChannelListController;
  final StreamMessageSearchListController streamMessageSearchListController;

  const MessagesLoaded(
      this.streamChannelListController, this.streamMessageSearchListController);

  @override
  List<Object?> get props =>
      [streamChannelListController, streamMessageSearchListController];
}

class MessageSending extends MessagesState {}

class MessageSent extends MessagesState {}

class MessagesError extends MessagesState {
  @override
  final String message;

  const MessagesError(this.message);

  @override
  List<Object> get props => [message];
}

class MessagesEmpty extends MessagesState {}
