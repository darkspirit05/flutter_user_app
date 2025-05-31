import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_app/models/post.dart';
import 'package:user_app/models/todo.dart';
import 'package:user_app/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  /// Fetch list of users with pagination and optional search.
  /// [limit] = page size, [skip] = offset, [search] = optional name search.
  Future<List<User>> fetchUsers({
    required int limit,
    required int skip,
    String? search,
  }) async {
    final Uri uri;
    if (search != null && search.trim().isNotEmpty) {
      uri = Uri.parse('$baseUrl/users/search?q=$search&limit=$limit&skip=$skip');
    } else {
      uri = Uri.parse('$baseUrl/users?limit=$limit&skip=$skip');
    }

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> usersJson = data['users'] ?? data['users'];
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  /// Fetch posts for a given userId.
  Future<List<Post>> fetchPostsByUser(int userId) async {
    final uri = Uri.parse('$baseUrl/posts/user/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> postsJson = data['posts'];
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// Fetch todos for a given userId.
  Future<List<Todo>> fetchTodosByUser(int userId) async {
    final uri = Uri.parse('$baseUrl/todos/user/$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> todosJson = data['todos'];
      return todosJson.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
