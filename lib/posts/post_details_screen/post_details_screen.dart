import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/post_details_bloc/post_details_bloc.dart';

import '../../models/minimal_post.dart';
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
                if (state.postDetails == null) {
                  return const Center(
                    child: Text('Oups, une erreur est survenue.'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostAuthor(author: state.postDetails!.author),
                      const SizedBox(height: 10),
                      PostContent(content: state.postDetails!.content, image: state.postDetails!.image),
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
