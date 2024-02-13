import 'package:flutter/material.dart';

class PostCommentField extends StatefulWidget {
  const PostCommentField({super.key});

  @override
  State<PostCommentField> createState() => _PostCommentFieldState();
}

class _PostCommentFieldState extends State<PostCommentField> {
  final TextEditingController _controller = TextEditingController();
  String _commentContent = "";

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _onPostTextChanged(_controller.text);
    });
  }

  void _onPostTextChanged(String text) {
    setState(() {
      _commentContent = text;
    });
  }

  bool canSubmit() {
    return _commentContent.isNotEmpty;
  }

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
                  controller: _controller,
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
                icon: Icon(Icons.send,
                    color: canSubmit() ? Colors.white : Colors.grey[600]),
                iconSize: 25.0,
                onPressed: () => {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
