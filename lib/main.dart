import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/image_screen/image_screen.dart';
import 'package:hollychat/posts/post_details_bloc/post_details_bloc.dart';
import 'package:hollychat/posts/post_details_screen/post_details_screen.dart';
import 'package:hollychat/posts/posts_bloc/posts_bloc.dart';
import 'package:hollychat/posts/posts_screen/posts_screen.dart';
import 'package:hollychat/posts/services/posts_api_data_source.dart';
import 'package:hollychat/posts/services/posts_repository.dart';

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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              PostsRepository(postsDataSource: PostsApiDataSource()),
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
            create: (context) => PostDetailsBloc(
              postsRepository: context.read<PostsRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color(0xff131D35),
            cardColor: const Color(0xff1E2A47),
            scaffoldBackgroundColor: const Color(0xff131D35),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff131D35),
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
            PostsScreen.routeName: (context) => const PostsScreen(),
          },
          onGenerateRoute: _getRoute,
        ),
      ),
    );
  }
}

Route? _getRoute(RouteSettings settings) {
  switch (settings.name) {
    case PostDetailsScreen.routeName:
      final arguments = settings.arguments;
      if (arguments is MinimalPost) {
        return _createPostRoute(PostDetailsScreen(post: arguments));
      }
      break;
    case ImageScreen.routeName:
      final arguments = settings.arguments;
      if (arguments is Map) {
        final tag = arguments['tag'] as UniqueKey;
        final postImage = arguments['postImage'] as PostImage;
        return _createImageRoute(ImageScreen(postImage: postImage, tag: tag));
      }
      break;
  }

  return null;
}

Route _createImageRoute(final Widget content) {
  return PageRouteBuilder(
    opaque: false,
    barrierColor: Colors.white.withOpacity(0),
    pageBuilder: (BuildContext context, _, __) {
      return content;
    },
  );
}

Route _createPostRoute(final Widget content) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => content,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
