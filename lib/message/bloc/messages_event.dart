part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  final Message? message;
  const MessagesEvent({this.message});

  @override
  List<Object?> get props => [message];
}

class LoadMessages extends MessagesEvent {}

class SendMessage extends MessagesEvent {
  @override
  final Message message;
  const SendMessage({required this.message});
  @override
  List<Object?> get props => [message];
}
