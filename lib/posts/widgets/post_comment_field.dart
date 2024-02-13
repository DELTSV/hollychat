import 'package:flutter/material.dart';

class PostCommentField extends StatelessWidget {
  const PostCommentField({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Quoi de neuf mon reuf ?',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // Second child is button
              IconButton(
                icon: const Icon(Icons.send),
                iconSize: 20.0,
                onPressed: () => {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
