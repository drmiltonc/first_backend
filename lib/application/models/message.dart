// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:first_backend/application/models/enum_message.dart';

class Message extends Equatable {
  const Message({
    required this.id,
    required this.content,
    required this.sourceType,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      sourceType: MessageSourceType.values[json['sourceType'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }


  final String id;
  final String content;
  final MessageSourceType sourceType;
  final DateTime createdAt;


  Message copyWith({
    String? id,
    String? content,
    MessageSourceType? sourceType,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      sourceType: sourceType ?? this.sourceType,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sourceType': sourceType.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, content, sourceType, createdAt];
}
