import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget implements PreferredSizeWidget {
  const LinearProgressBar({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return LinearProgressIndicator(
      value: null,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      backgroundColor: Colors.grey[300],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(6.0);
}
