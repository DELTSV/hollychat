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
    Widget continueButton = TextButton(
      onPressed: onDeletePost,
      child: const Text("Confirmer"),
    );
    Widget cancelButton = TextButton(
      onPressed: onCancel,
      child: const Text("Annuler"),
    );
    return AlertDialog(
      title: const Text("Supprimer le post"),
      content: const Text(
          "Êtes-vous sûr de vouloir supprimer ce post ? Cette action est irréversible."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
