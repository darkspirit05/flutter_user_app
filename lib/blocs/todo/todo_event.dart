// lib/blocs/todo/todo_event.dart
import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

/// Fetch todos for a specific user ID
class FetchTodosEvent extends TodoEvent {
  final int userId;

  const FetchTodosEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
