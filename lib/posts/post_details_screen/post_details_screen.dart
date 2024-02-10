import 'package:flutter/material.dart';

import '../../models/minimal_post.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key, required this.post});

  static const String routeName = "/post-details";

  static void navigateTo(BuildContext context, MinimalPost product) {
    Navigator.of(context).pushNamed(routeName, arguments: product);
  }

  final MinimalPost post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Post', style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text('${post.id}'),
            Text(post.content),
          ],
        ),
        // child: BlocBuilder<PostsBloc, PostsState>(
        //   builder: (context, state) {
        //     if (state.posts.isEmpty) {
        //       switch (state.status) {
        //         case PostsStatus.initial:
        //           return const SizedBox();
        //         case PostsStatus.loading:
        //           return const Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         case PostsStatus.error:
        //           return const Center(
        //             child: Text('Oups, une erreur est survenue.'),
        //           );
        //         case PostsStatus.success:
        //           return const Center(
        //             child: Text('Aucun post trouvé.'),
        //           );
        //       }
        //     }
        //
        //     final posts = state.posts;
        //
        //     return ListView.separated(
        //       controller: _scrollController,
        //       itemCount: posts.length + (state.hasMore ? 1 : 0),
        //       separatorBuilder: (context, _) => const SizedBox(height: 10),
        //       physics: const BouncingScrollPhysics(),
        //       padding: const EdgeInsets.all(8.0),
        //       itemBuilder: (context, index) {
        //         if (index == posts.length) {
        //           if (state.status == PostsStatus.error) {
        //             return const Center(
        //               child: Text('Oups, une erreur est survenue.'),
        //             );
        //           } else {
        //             return const Center(
        //               child: CircularProgressIndicator(),
        //             );
        //           }
        //         }
        //
        //         final post = posts[index];
        //
        //         return PostPreview(
        //           onTap: () => _onProductTap(context, post),
        //           post: post,
        //         );
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }
}
