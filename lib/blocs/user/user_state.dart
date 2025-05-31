import 'package:equatable/equatable.dart';
import 'package:user_app/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial (nothing loaded yet)
class UserInitial extends UserState {}

/// Loading state (can be initial load or pagination load)
class UserLoading extends UserState {
  final List<User> previousUsers;
  final bool isInitialFetch;

  const UserLoading({
    this.previousUsers = const <User>[],
    this.isInitialFetch = false,
  });

  @override
  List<Object?> get props => [previousUsers, isInitialFetch];
}

/// Loaded state with list of users
class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedMax;

  const UserLoaded({
    required this.users,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [users, hasReachedMax];

  UserLoaded copyWith({
    List<User>? users,
    bool? hasReachedMax,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

/// Error state
class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
