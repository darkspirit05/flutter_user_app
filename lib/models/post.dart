// lib/models/post.dart
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, userId, title, body];
}
