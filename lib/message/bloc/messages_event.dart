part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  final Message? message;
  final List<String>? memberIds;
  const MessagesEvent({this.message, this.memberIds});

  @override
  List<Object?> get props => [message, memberIds];
}

class LoadMessages extends MessagesEvent {}

class SendMessage extends MessagesEvent {
  @override
  final Message message;
  @override
  const SendMessage({required this.message});
  @override
  List<Object?> get props => [message];
}

class CreateConversation extends MessagesEvent {
  @override
  final List<String> memberIds;
  const CreateConversation({required this.memberIds});
  @override
  List<Object?> get props => [memberIds];
}
