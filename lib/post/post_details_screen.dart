import 'package:flutter/material.dart';
import 'package:hollychat/models/post.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key, required this.post});

  static const String routeName = "/post-details";

  static void navigateTo(BuildContext context, Post product) {
    Navigator.of(context).pushNamed(routeName, arguments: product);
  }

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(post.content),
    );
  }
}
