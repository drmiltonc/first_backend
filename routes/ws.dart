import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:first_backend/application/repositories/chat_history_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final chatRepository = context.read<ChatRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add('Invalid message');
        return;
      }

      try {
        final messageJson = json.decode(message) as Map<String, dynamic>;
        final event = messageJson['event'];
        final data = messageJson['data'];

        // message.create
        switch (event) {
          case 'message.create':
            const chatroomId = '1';
            chatRepository
                .createUserMessage(chatroomId, data as Map<String, dynamic>)
                .then((value) {
              final responseStream =
                  chatRepository.createModelMessage(chatroomId, data);

              // ignore: cascade_invocations
              responseStream.listen((data) {
                final modelMessage = data.$1;
                final eventType = data.$2;

                // From server to client
                channel.sink.add(
                  json.encode(
                    {
                      'event': eventType,
                      'data': modelMessage.toJson(),
                    },
                  ),
                );
              });

              return;
            });

          default:
        }
      } catch (err) {
        channel.sink.add('Invalid message');
      }
    });
  });

  return handler(context);
}
