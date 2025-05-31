# Flutter User App

A beautifully designed Flutter application built using the BLoC pattern with dark/light theme support, user search, pagination, and nested data fetching.

## 🌟 Features

- ✅ User list with infinite scroll and real-time search
- ✅ User detail screen with posts and todos
- ✅ Create new post (local)
- ✅ Light/Dark theme toggle
- ✅ Clean folder structure using BLoC
- ✅ Loading indicators and error handling

## 📦 API Used

- Users: https://dummyjson.com/users
- User Posts: https://dummyjson.com/posts/user/{userId}
- User Todos: https://dummyjson.com/todos/user/{userId}

## 🧱 Architecture

- `flutter_bloc` for state management
- `repository` and `service` layers for clean separation
- `screens` and `widgets` for UI components
- `models` to represent API responses

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/darkspirit05/flutter_user_app.git
cd flutter_user_app