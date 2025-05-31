// lib/models/todo.dart
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int id;
  final int userId;
  final String todo;
  final bool completed;

  const Todo({
    required this.id,
    required this.userId,
    required this.todo,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['userId'],
      todo: json['todo'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, userId, todo, completed];
}
