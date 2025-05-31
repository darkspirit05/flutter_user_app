import 'package:equatable/equatable.dart';
import 'package:user_app/models/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

/// Initial state (no data yet)
class TodoInitial extends TodoState {}

/// Loading
class TodoLoading extends TodoState {}

/// Loaded with list of todos
class TodoLoaded extends TodoState {
  final List<Todo> todos;

  const TodoLoaded({required this.todos});

  @override
  List<Object?> get props => [todos];
}

/// Error
class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object?> get props => [message];
}
