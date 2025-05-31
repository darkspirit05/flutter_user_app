// lib/blocs/user/user_event.dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

/// Trigger initial fetch (or refresh)
class FetchUsersEvent extends UserEvent {
  final bool isRefresh;
  final String? searchQuery;

  const FetchUsersEvent({this.isRefresh = false, this.searchQuery});

  @override
  List<Object?> get props => [isRefresh, searchQuery];
}

/// Trigger search (resets current list)
class SearchUsersEvent extends UserEvent {
  final String searchQuery;

  const SearchUsersEvent({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

/// Load more users (pagination)
class LoadMoreUsersEvent extends UserEvent {
  final String? searchQuery;

  const LoadMoreUsersEvent({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}
