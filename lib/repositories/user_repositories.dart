import 'package:user_app/models/user.dart';
import 'package:user_app/services/api_services.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  /// Page size for pagination
  static const int pageSize = 20;

  /// Maintains current skip offset
  int _currentSkip = 0;

  /// If currently fetching, to prevent duplicate calls
  bool _isFetching = false;

  /// Fetch next page of users, optionally with search query.
  Future<List<User>> fetchUsers({
    String? searchQuery,
    bool reset = false,
  }) async {
    if (_isFetching) return [];
    _isFetching = true;

    if (reset) {
      _currentSkip = 0;
    }

    final users = await _apiService.fetchUsers(
      limit: pageSize,
      skip: _currentSkip,
      search: searchQuery,
    );

    _currentSkip += pageSize;
    _isFetching = false;
    return users;
  }

  /// Resets pagination (e.g., on new search)
  void resetPagination() {
    _currentSkip = 0;
  }
}
