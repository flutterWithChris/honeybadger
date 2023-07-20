part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final StreamChannelListController streamChannelListController;
  final StreamMessageSearchListController streamMessageSearchListController;

  const MessagesLoaded(
      this.streamChannelListController, this.streamMessageSearchListController);

  @override
  List<Object> get props =>
      [streamChannelListController, streamMessageSearchListController];
}

class MessagesError extends MessagesState {
  final String message;

  const MessagesError(this.message);

  @override
  List<Object> get props => [message];
}

class MessagesEmpty extends MessagesState {}
