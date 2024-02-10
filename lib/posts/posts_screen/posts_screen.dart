import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/post_details_screen/post_details_screen.dart';
import 'package:hollychat/posts/widgets/post_preview.dart';

import '../../models/minimal_post.dart';
import '../posts_bloc/posts_bloc.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  static const String routeName = "/";

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final postsBloc = BlocProvider.of<PostsBloc>(context);
    postsBloc.add(LoadNextPostPage());
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        postsBloc.add(LoadNextPostPage());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onProductTap(BuildContext context, MinimalPost post) {
    PostDetailsScreen.navigateTo(context, post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image(image: AssetImage('assets/images/logo.png'), height: 30),
        ]),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          backgroundColor: const Color(0xff1E2A47),
          color: Colors.white,
          onRefresh: () async {
            final postsBloc = BlocProvider.of<PostsBloc>(context);
            return postsBloc.add(RefreshPosts());
          },
          child: BlocBuilder<PostsBloc, PostsState>(
            builder: (context, state) {
              if (state.posts.isEmpty) {
                switch (state.status) {
                  case PostsStatus.initial:
                    return const SizedBox();
                  case PostsStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PostsStatus.error:
                    return const Center(
                      child: Text('Oups, une erreur est survenue.'),
                    );
                  case PostsStatus.success:
                    return const Center(
                      child: Text('Aucun post trouvé.'),
                    );
                }
              }

              final posts = state.posts;

              return ListView.separated(
                controller: _scrollController,
                itemCount: posts.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (context, _) => const SizedBox(height: 10),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    if (state.status == PostsStatus.error) {
                      return const Center(
                        child: Text('Oups, une erreur est survenue.'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }

                  final post = posts[index];

                  return PostPreview(
                    onTap: () => _onProductTap(context, post),
                    post: post,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
