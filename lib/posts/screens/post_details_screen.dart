import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/posts/bloc/comment_bloc/comment_bloc.dart';
import 'package:hollychat/posts/bloc/post_bloc/post_bloc.dart';
import 'package:hollychat/posts/widgets/alert_error.dart';
import 'package:hollychat/posts/widgets/post_comment_list.dart';
import 'package:hollychat/posts/widgets/post_separator.dart';

import '../../models/minimal_post.dart';
import '../../models/post_comment.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/post_details_bloc/post_details_bloc.dart';
import '../widgets/delete_alert_dialog.dart';
import '../widgets/linear_progress_bar.dart';
import '../widgets/post_author.dart';
import '../widgets/post_comment_field.dart';
import '../widgets/post_content.dart';
import '../widgets/settings_menu.dart';
import '../widgets/success_alert.dart';
import 'edit_post_screen.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key, required this.post});

  static const String routeName = "/post-details";

  static Route? createRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    if (arguments is MinimalPost) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PostDetailsScreen(post: arguments),
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

    return null;
  }

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
    _getPost();
  }

  void _getPost() {
    final postsBloc = BlocProvider.of<PostDetailsBloc>(context);
    postsBloc.add(LoadPostDetailsById(postId: widget.post.id));
  }

  void _onDeletePost(BuildContext context) {
    final deletePostBloc = BlocProvider.of<DeletePostBloc>(context);
    deletePostBloc.add(DeletePost(id: widget.post.id));
  }

  void _onPostDeleted(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: AlertSuccess(message: "Post supprimé avec succès"),
      ),
    );
  }

  void _onCommentAdded(BuildContext context) {
    _getPost();
  }

  void onSubmittedComment(int postId, String text) {
    final commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(AddComment(postId: postId, content: text));
  }

  _onItemSelected(MenuItemType value, BuildContext context) {
    switch (value) {
      case MenuItemType.edit:
        EditPostScreen.navigateTo(context, widget.post);
        break;
      case MenuItemType.delete:
        showAlertDialog(context);
        break;
    }
  }

  showAlertDialog(BuildContext context) {
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

  void _onDeleteComment(BuildContext context, int commentId) {
    final commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(DeleteComment(id: commentId));
  }

  void _onEditComment(BuildContext context, int commentId, String content) {
    final commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(UpdateComment(id: commentId, content: content));
  }

  Widget _buildComments(List<PostComment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PostSeparator(padding: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            'Commentaires',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 20),
        PostCommentList(
          onDelete: (commentId) => _onDeleteComment(context, commentId),
          onEdit: (commentId, content) =>
              _onEditComment(context, commentId, content),
          comments: comments,
        ),
      ],
    );
  }

  Widget? _buildFloatingButton(bool show) {
    if (!show) {
      return null;
    }

    return PostCommentField(
      onSubmitted: (String text) => onSubmittedComment(
        widget.post.id,
        text,
      ),
      authorName: widget.post.author.username,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeletePostBloc, DeletePostState>(
          listener: (context, state) {
            if (state.status == DeletePostStatus.success) {
              _onPostDeleted(context);
            }

            if (state.status == DeletePostStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AlertError(message: "Erreur lors de la suppression du post"),
                ),
              );
            }
          },
        ),
        BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state.status == PostStatus.success) {
              _getPost();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AlertSuccess(message: "Post modifié avec succès"),
                ),
              );
            }

            if (state.status == PostStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AlertError(message: "Erreur lors de la modification du post"),
                ),
              );
            }
          },
        ),
        BlocListener<CommentBloc, CommentState>(
          listener: (context, state) {
            if (state.status == CommentStatus.success) {
              _onCommentAdded(context);
            }

            if (state.status == CommentStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: AlertError(message: "Erreur lors de l'ajout du commentaire"),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final List<Widget> actions = [];

          if (authState.isAuthenticated) {
            if (authState.user!.id == widget.post.author.id) {
              actions.add(
                SettingsMenu(
                  onItemSelected: (itemType) =>
                      _onItemSelected(itemType, context),
                ),
              );
            }
          }

          return SafeArea(
            top: false,
            child: BlocBuilder<DeletePostBloc, DeletePostState>(
              builder: (context, deletePostState) {
                return BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, commentState) {
                    bool isLoading =
                        deletePostState.status == DeletePostStatus.loading ||
                            commentState.status == CommentStatus.loading;

                    return Scaffold(
                      bottomSheet: _buildFloatingButton(
                        authState.isAuthenticated && !isLoading,
                      ),
                      appBar: AppBar(
                        iconTheme: const IconThemeData(color: Colors.white),
                        title: Text(
                          'Post',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        actions: actions,
                        bottom: LinearProgressBar(
                          isLoading: isLoading,
                        ),
                      ),
                      body: BlocBuilder<PostDetailsBloc, PostDetailsState>(
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
                                padding: const EdgeInsets.only(bottom: 80),
                                child: Padding(
                                  // only apply padding at the top and bottom
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            PostAuthor(
                                              author: state.postDetails!.author,
                                              relativeTime:
                                                  state.postDetails!.relativeTime,
                                            ),
                                            const SizedBox(height: 10),
                                            PostContent(
                                              content:
                                                  state.postDetails!.content,
                                              image: state.postDetails!.image,
                                              linkImages:
                                                  state.postDetails!.linkImages,
                                              links: state.postDetails!.links,
                                              linksPreviews: state.postDetails!.linksPreviews,
                                            ),
                                          ],
                                        ),
                                      ),
                                      _buildComments(
                                        state.postDetails?.comments ?? [],
                                      ),
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
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
