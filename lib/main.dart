import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/blocs/user/user_bloc.dart';
import 'package:user_app/blocs/user/user_event.dart';
import 'package:user_app/models/user.dart';
import 'package:user_app/repositories/user_repositories.dart';
import 'package:user_app/screens/user_list_screen.dart';

void main() {
  runApp(FlutterUserApp());
}

class FlutterUserApp extends StatelessWidget {
  FlutterUserApp({Key? key}) : super(key: key);
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(
            create: (context) => UserBloc(
              userRepository: context.read<UserRepository>(),
            )..add(FetchUsersEvent()), // initial fetch
          ),
          // Note: PostBloc and TodoBloc will be provided at detail-screen level.
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter User App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const UserListScreen(),
        ),
      ),
    );
  }
  Widget buildUserCard(User user, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: 'avatar_${user.id}',
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.image),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 4),
                    Text(user.email,
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

}
