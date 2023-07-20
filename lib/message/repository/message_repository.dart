import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessageRepository {
  StreamChatClient client = StreamChatClient(
    dotenv.env['STREAM_API_KEY']!,
    logLevel: Level.INFO,
  );

  Future<void> connectAnonymousUser() async {
    try {
      await client.connectAnonymousUser();
    } catch (e) {
      print(e);
    }
  }

  Future<void> openConnection() async {
    try {
      await client.openConnection();
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectUser(
    String id,
    String name,
    String? image,
  ) async {
    try {
      await client.connectUser(
        User(
          id: id,
          name: name,
          image: image,
        ),
        // TODO: Replace this with server-side token generation
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaG9uZXliYWRnZXIifQ.T1TO4smlS1bRiTQLclcya6robWpNdb_0hg-cJuVyx6g',
      );
    } catch (e) {
      print(e);
    }
  }

  /// Send a message
  Future<SendMessageResponse> sendMessage(Message message) async {
    try {
      return await client.sendMessage(message, '', 'messages');
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
