import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({
    super.key,
    required this.onDeletePost,
    required this.onCancel,
  });

  final VoidCallback onDeletePost;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Suppression"),
      content: const Text(
          "Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible."),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: onDeletePost,
          child: const Text("Confirmer"),
        ),
      ],
    );
  }
}
