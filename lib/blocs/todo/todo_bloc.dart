import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/todo/todo_event.dart';
import 'package:user_app/blocs/todo/todo_state.dart';
import 'package:user_app/services/api_services.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiService apiService;

  TodoBloc({required this.apiService}) : super(TodoInitial()) {
    on<FetchTodosEvent>(_onFetchTodos);
  }

  Future<void> _onFetchTodos(
      FetchTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    emit(TodoLoading());
    try {
      final todos = await apiService.fetchTodosByUser(event.userId);
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}
