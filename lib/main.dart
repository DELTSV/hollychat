import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => const PostsScreen(),
          },
        ),
      ),
    );
  }
}
