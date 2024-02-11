import 'package:flutter/material.dart';

import '../galery_screen/galery_screen.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  static const String routeName = "/new-post";

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
        title: Text(
          'Nouveau post',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                autofocus: true,
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
              // add a button to navigate to the gallery
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ImageGalleryScreen.navigateTo(context);
                },
                child: const Text('Ajouter une image'),
              ),
            ],
          )
        ),
      ),
    );
  }
}
