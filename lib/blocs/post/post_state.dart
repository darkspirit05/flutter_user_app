import 'package:equatable/equatable.dart';
import 'package:user_app/models/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

/// Initial state (no data yet)
class PostInitial extends PostState {}

/// Loading state
class PostLoading extends PostState {}

/// Loaded state with list of posts
class PostLoaded extends PostState {
  final List<Post> posts;

  const PostLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}

/// Error state
class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}
