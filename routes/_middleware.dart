import 'package:dart_frog/dart_frog.dart';
import 'package:first_backend/midllewares/chat_repository_provider.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(chatRepositoryProvider());
}
