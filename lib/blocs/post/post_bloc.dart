import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/post/post_event.dart';
import 'package:user_app/blocs/post/post_state.dart';
import 'package:user_app/models/post.dart';
import 'package:user_app/services/api_services.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final ApiService apiService;

  // Keep a local list to allow adding posts
  final List<Post> _posts = [];

  PostBloc({required this.apiService}) : super(PostInitial()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<AddPostEvent>(_onAddPost);
  }

  Future<void> _onFetchPosts(
      FetchPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostLoading());
    try {
      final posts = await apiService.fetchPostsByUser(event.userId);
      _posts.clear();
      _posts.addAll(posts);
      emit(PostLoaded(posts: List.unmodifiable(_posts)));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onAddPost(
      AddPostEvent event,
      Emitter<PostState> emit,
      ) async {
    if (state is PostLoaded) {
      _posts.insert(0, event.post); // add to the top
      emit(PostLoaded(posts: List.unmodifiable(_posts)));
    }
  }
}
