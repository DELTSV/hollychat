import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/posts/widgets/post_comment.dart';
import 'package:hollychat/posts/widgets/post_separator.dart';

import '../../models/minimal_post.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/post_details_bloc/post_details_bloc.dart';
import '../widgets/delete_alert_dialog.dart';
import '../widgets/post_author.dart';
import '../widgets/post_content.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key, required this.post});

  static const String routeName = "/post-details";

  static void navigateTo(BuildContext context, MinimalPost post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  final MinimalPost post;

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final postsBloc = BlocProvider.of<PostDetailsBloc>(context);
    postsBloc.add(LoadPostDetailsById(postId: widget.post.id));
  }

  void _onDeletePost(BuildContext context) {
    final deletePostBloc = BlocProvider.of<DeletePostBloc>(context);
    deletePostBloc.add(DeletePost(id: widget.post.id));
  }

  void _onPostDeleted() {
    Navigator.of(context).pop();
  }

  void _onDeleteTap() {
    _showAlertDialog();
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAlertDialog(
          onDeletePost: () => _onDeletePost(context),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletePostBloc, DeletePostState>(
      listener: (context, state) {
        if (state.status == DeletePostStatus.success) {
          _onPostDeleted();
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final List<Widget> actions = [];

          if (state.isAuthenticated) {
            if (state.user!.id == widget.post.author.id) {
              actions.add(
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _onDeleteTap(),
                ),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'Post',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: actions,
            ),
            body: SafeArea(
              child: BlocBuilder<PostDetailsBloc, PostDetailsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PostDetailsStatus.initial:
                      return const SizedBox();
                    case PostDetailsStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case PostDetailsStatus.success:
                      if (state.postDetails == null) {
                        return const Center(
                          child: Text('Oups, une erreur est survenue.'),
                        );
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          // only apply padding at the top and bottom
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PostAuthor(
                                        author: state.postDetails!.author),
                                    const SizedBox(height: 10),
                                    PostContent(
                                      content: state.postDetails!.content,
                                      image: state.postDetails!.image,
                                    ),
                                  ],
                                ),
                              ),
                              Builder(builder: (context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const PostSeparator(padding: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Text(
                                        'Commentaires',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Builder(builder: (context) {
                                      if (state.postDetails!.comments.isEmpty) {
                                        return Center(
                                          child: Text(
                                            'Aucun commentaire trouvé pour ce post.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        );
                                      }

                                      return Column(
                                        children: [
                                          ...state.postDetails!.comments
                                              .map((comment) => Column(
                                                    children: [
                                                      PostCommentPreview(
                                                        comment: comment,
                                                      ),
                                                      const PostSeparator(
                                                          padding: 10),
                                                    ],
                                                  )),
                                          Center(
                                            child: Text(
                                              'Aucun autre commentaire trouvé.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    case PostDetailsStatus.error:
                      return const Center(
                        child: Text('Oups, une erreur est survenue.'),
                      );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
