import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/user/user_event.dart';
import 'package:user_app/blocs/user/user_state.dart';
import 'package:user_app/models/user.dart';
import 'package:user_app/repositories/user_repositories.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  static const int pageSize = UserRepository.pageSize;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
  }

  Future<void> _onFetchUsers(
      FetchUsersEvent event,
      Emitter<UserState> emit,
      ) async {
    try {
      if (event.isRefresh) {
        // Reset pagination and load fresh
        userRepository.resetPagination();
      }
      final isInitialFetch = event.isRefresh || state is UserInitial;
      final previousUsers =
      (state is UserLoaded) ? (state as UserLoaded).users : <User>[];

      emit(UserLoading(
        previousUsers: previousUsers,
        isInitialFetch: isInitialFetch,
      ));

      final users = await userRepository.fetchUsers(
        searchQuery: event.searchQuery,
        reset: isInitialFetch,
      );

      final allUsers = isInitialFetch ? users : previousUsers + users;
      final hasReachedMax = users.length < pageSize;

      emit(UserLoaded(users: allUsers, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onSearchUsers(
      SearchUsersEvent event,
      Emitter<UserState> emit,
      ) async {
    try {
      userRepository.resetPagination();
      emit(const UserLoading(previousUsers: [], isInitialFetch: true));

      final users = await userRepository.fetchUsers(
        searchQuery: event.searchQuery,
        reset: true,
      );
      final hasReachedMax = users.length < pageSize;
      emit(UserLoaded(users: users, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
      LoadMoreUsersEvent event,
      Emitter<UserState> emit,
      ) async {
    if (state is! UserLoaded) return;
    final currentState = state as UserLoaded;
    if (currentState.hasReachedMax) return;

    try {
      emit(UserLoading(
        previousUsers: currentState.users,
        isInitialFetch: false,
      ));

      final users = await userRepository.fetchUsers(
        searchQuery: event.searchQuery,
      );
      final hasReachedMax = users.length < pageSize;
      final updatedUsers = currentState.users + users;
      emit(UserLoaded(users: updatedUsers, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
