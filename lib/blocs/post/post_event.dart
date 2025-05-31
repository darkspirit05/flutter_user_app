import 'package:equatable/equatable.dart';
import 'package:user_app/models/post.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

/// Fetch posts for a specific user ID
class FetchPostsEvent extends PostEvent {
  final int userId;

  const FetchPostsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Add a new post locally (no API call)
class AddPostEvent extends PostEvent {
  final Post post;

  const AddPostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}
