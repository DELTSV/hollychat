import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/auth/screens/sign_in_screen.dart';
import 'package:hollychat/auth/services/auth_api_data_source.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/posts/bloc/comment_bloc/comment_bloc.dart';
import 'package:hollychat/posts/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:hollychat/posts/bloc/post_bloc/post_bloc.dart';
import 'package:hollychat/posts/bloc/post_details_bloc/post_details_bloc.dart';
import 'package:hollychat/posts/bloc/posts_bloc/posts_bloc.dart';
import 'package:hollychat/posts/screens/add_post_screen.dart';
import 'package:hollychat/posts/screens/edit_post_screen.dart';
import 'package:hollychat/posts/screens/image_screen.dart';
import 'package:hollychat/posts/screens/post_details_screen.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';
import 'package:hollychat/posts/services/comments/comments_api_data_source.dart';
import 'package:hollychat/posts/services/comments/comments_repository.dart';
import 'package:hollychat/posts/services/posts/posts_api_data_source.dart';
import 'package:hollychat/posts/services/posts/posts_repository.dart';

import 'auth/screens/sign_up_screen.dart';
import 'models/minimal_post.dart';
import 'models/post_image.dart';

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
              CommentsRepository(commentsDataSource: CommentsApiDataSource()),
        ),
        RepositoryProvider(
          create: (context) =>
              AuthRepository(authDataSource: AuthApiDataSource()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DeletePostBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostsBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostDetailsBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              noAuthCallback: () =>
                  navigatorKey.currentState!.pushNamed('/login'),
            ),
          ),
          BlocProvider(
            create: (context) => CommentBloc(
              commentsRepository: context.read<CommentsRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: _getTheme(),
          onGenerateRoute: _getRoute,
          routes: {
            PostsScreen.routeName: (context) => const PostsScreen(),
          },
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}

Route? _getRoute(RouteSettings settings) {
  switch (settings.name) {
    case PostDetailsScreen.routeName:
      return PostDetailsScreen.createRoute(settings);
    case ImageScreen.routeName:
      return ImageScreen.createRoute(settings);
    case AddPostScreen.routeName:
      return AddPostScreen.createRoute(settings);
    case EditPostScreen.routeName:
      return EditPostScreen.createRoute(settings);
    case SignInScreen.routeName:
      return SignInScreen.createRoute(settings);
    case SignUpScreen.routeName:
      return SignUpScreen.createRoute(settings);
  }

  // redirect to home
  return MaterialPageRoute(
    builder: (context) => const PostsScreen(),
  );
}

ThemeData _getTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: const Color(0xff131D35),
    cardColor: const Color(0xff1E2A47),
    cardTheme: const CardTheme(
      color: Color(0xff1E2A47),
    ),
    scaffoldBackgroundColor: const Color(0xff131D35),
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: Colors.white,
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      helperStyle: TextStyle(
        color: Colors.grey,
      ),
      errorStyle: TextStyle(
        color: Colors.redAccent,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff131D35),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      elevation: 1,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xff1E2A47),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff1E2A47),
      textTheme: ButtonTextTheme.normal,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
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
  );
}
