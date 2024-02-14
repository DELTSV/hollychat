import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/screens/sign_in_screen.dart';
import 'package:hollychat/posts/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:hollychat/posts/screens/add_post_screen.dart';
import 'package:hollychat/posts/screens/post_details_screen.dart';
import 'package:hollychat/posts/widgets/post_preview.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../models/minimal_post.dart';
import '../bloc/post_bloc/post_bloc.dart';
import '../bloc/posts_bloc/posts_bloc.dart';
import '../widgets/linear_progress_bar.dart';
import '../widgets/post_separator.dart';

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

  void _onPostTap(BuildContext context, MinimalPost post) {
    PostDetailsScreen.navigateTo(context, post);
  }

  void _refreshPosts() {
    final postsBloc = BlocProvider.of<PostsBloc>(context);
    postsBloc.add(RefreshPosts());
  }

  Widget? _getFloatingActionButton(bool isAuthenticated) {
    if (isAuthenticated) {
      return FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Ajouter un post',
        onPressed: () => AddPostScreen.navigateTo(context),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      );
    }

    return null;
  }

  Widget _getBarAction(bool isAuthenticated) {
    if (isAuthenticated) {
      return PopupMenuButton(
        icon: const Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 35,
        ),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              value: 'logout',
              child: Text('Se déconnecter'),
            ),
          ];
        },
        onSelected: (String value) {
          if (value == 'logout') {
            context.read<AuthBloc>().add(LogOut());
          }
        },
      );
    }

    return TextButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, SignInScreen.routeName),
      child: const Text("Connexion"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<DeletePostBloc, DeletePostState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 25,
                ),
                actions: [
                  _getBarAction(authState.isAuthenticated),
                ],
                bottom: LinearProgressBar(
                  isLoading: state.status == DeletePostStatus.loading,
                ),
              ),
              floatingActionButton:
              _getFloatingActionButton(authState.isAuthenticated),
              body: SafeArea(
                child: RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  backgroundColor: const Color(0xff1E2A47),
                  color: Colors.white,
                  onRefresh: () async {
                    _refreshPosts();
                  },
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<PostBloc, PostState>(
                        listener: (context, state) {
                          if (state.status == PostStatus.success) {
                            _refreshPosts();
                          }
                        },
                      ),
                      BlocListener<DeletePostBloc, DeletePostState>(
                        listener: (context, state) {
                          if (state.status == DeletePostStatus.success) {
                            _refreshPosts();
                          }
                        },
                      ),
                    ],
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
                          separatorBuilder: (context,
                              _) => const PostSeparator(),
                          physics: const BouncingScrollPhysics(),
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
                              onTap: () => _onPostTap(context, post),
                              post: post,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
