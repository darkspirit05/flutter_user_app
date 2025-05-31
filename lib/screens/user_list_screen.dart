import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/user/user_bloc.dart';
import 'package:user_app/blocs/user/user_event.dart';
import 'package:user_app/blocs/user/user_state.dart';
import 'package:user_app/screens/user_detail_screen.dart';
import 'package:user_app/widgets/user_list_them.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _currentSearch;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial fetch is already called in main.dart
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore()) {
      // Trigger load more
      context
          .read<UserBloc>()
          .add(LoadMoreUsersEvent(searchQuery: _currentSearch));
    }
  }

  bool _isLoadingMore() {
    final state = context.read<UserBloc>().state;
    return state is UserLoading && !state.isInitialFetch;
  }

  void _onSearchChanged(String query) {
    _currentSearch = query.isEmpty ? null : query;
    context.read<UserBloc>().add(SearchUsersEvent(searchQuery: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search users by name...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // User list
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial || (state is UserLoading && state.isInitialFetch)) {
                  // show full-screen loading
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is UserLoaded) {
                  final users = state.users;
                  if (users.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax ? users.length : users.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= users.length) {
                        // show loading indicator at bottom while fetching more
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final user = users[index];
                      return UserListItem(
                        user: user,
                        onTap: () {
                          // Navigate to UserDetailScreen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(user: user),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const SizedBox(); // fallback
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
