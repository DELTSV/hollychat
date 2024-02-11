import 'package:flutter/material.dart';

class PostSeparator extends StatelessWidget {
  const PostSeparator({super.key, this.padding = 0});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Divider(
        color: Theme.of(context).dividerColor,
        thickness: 0.3,
      ),
    );
  }
}
