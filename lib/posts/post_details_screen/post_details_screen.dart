import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/post_details_bloc/post_details_bloc.dart';

import '../../models/minimal_post.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Post',
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
                return Center(
                  child: Column(
                    children: [
                      Text('Content: ${state.postDetails?.content}'),
                      Text('id: ${state.postDetails?.author.id}'),
                    ],
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
  }
}
