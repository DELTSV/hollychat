import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/auth/screens/sign_up_screen.dart';
import 'package:hollychat/auth/services/auth_data_source.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/posts/bloc/posts_bloc.dart';
import 'package:hollychat/posts/posts_screen.dart';
import 'package:hollychat/posts/services/posts_api_data_source.dart';
import 'package:hollychat/posts/services/posts_repository.dart';

void main() {
  runApp(const HollyChatApp());
}

class HollyChatApp extends StatelessWidget {
  const HollyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              PostsRepository(postsDataSource: PostsApiDataSource()),
        ),
        RepositoryProvider(
          create: (context) =>
              AuthRepository(authDataSource: AuthApiDataSource()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostsBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              noAuthCallback: () =>
                  navigatorKey.currentState!.pushNamed('/signup'),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xff131D35),
            scaffoldBackgroundColor: const Color(0xff131D35),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff131D35),
              elevation: 1,
            ),
            cardTheme: const CardTheme(
              color: Color(0xff1E2A47),
              elevation: 1,
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: Colors.white,
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          routes: {
            '/': (context) => const PostsScreen(),
            '/signup': (context) => const SignUpScreen(),
          },
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
