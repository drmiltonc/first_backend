// ignore_for_file: public_member_api_docs

import 'package:dart_frog/dart_frog.dart';
import 'package:first_backend/application/repositories/chat_history_repository.dart';

final _chatRepository = ChatRepository();

Middleware chatRepositoryProvider() {
  return provider<ChatRepository>((_) => _chatRepository);
}
