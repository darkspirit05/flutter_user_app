import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/post/post_bloc.dart';
import 'package:user_app/blocs/post/post_event.dart';
import 'package:user_app/blocs/post/post_state.dart';
import 'package:user_app/blocs/todo/todo_bloc.dart';
import 'package:user_app/blocs/todo/todo_event.dart';
import 'package:user_app/blocs/todo/todo_state.dart';
import 'package:user_app/models/post.dart';
import 'package:user_app/models/user.dart';
import 'package:user_app/screens/create_post_screen.dart';
import 'package:user_app/services/api_services.dart';
import 'package:user_app/widgets/post_item.dart';
import 'package:user_app/widgets/todo_item.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (_) => PostBloc(apiService: apiService)
            ..add(FetchPostsEvent(userId: user.id)),
        ),
        BlocProvider<TodoBloc>(
          create: (_) => TodoBloc(apiService: apiService)
            ..add(FetchTodosEvent(userId: user.id)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.firstName} ${user.lastName}'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Section
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.image),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize:  24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(user.email),
                const SizedBox(height: 4),
                Text('Username: ${user.username}'),
                const SizedBox(height: 4),
                Text('Phone: ${user.phone}'),
                const Divider(height: 32),
                // Posts Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Navigate to CreatePostScreen; get new post back
                        final newPost = await Navigator.push<Post>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePostScreen(userId: user.id),
                          ),
                        );
                        if (newPost != null) {
                          // Add the new post to PostBloc
                          context.read<PostBloc>().add(AddPostEvent(post: newPost));
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Post'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostError) {
                      return Text('Error: ${state.message}');
                    } else if (state is PostLoaded) {
                      final posts = state.posts;
                      if (posts.isEmpty) {
                        return const Text('No posts found.');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostItem(post: post);
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const Divider(height: 32),
                // Todos Section
                const Text(
                  'Todos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TodoError) {
                      return Text('Error: ${state.message}');
                    } else if (state is TodoLoaded) {
                      final todos = state.todos;
                      if (todos.isEmpty) {
                        return const Text('No todos found.');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return TodoItem(todo: todo);
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
