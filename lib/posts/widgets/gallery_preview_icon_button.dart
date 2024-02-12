import 'package:flutter/material.dart';

class GalleryPreviewIconButton extends StatefulWidget {
  const GalleryPreviewIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final Icon icon;
  final void Function() onTap;

  @override
  State<GalleryPreviewIconButton> createState() =>
      _GalleryPreviewIconButtonState();
}

class _GalleryPreviewIconButtonState extends State<GalleryPreviewIconButton> {
  double _opacity = 0.0; // Initialize opacity to 0.0

  @override
  void initState() {
    super.initState();
    // Start the animation by setting opacity to 1.0 after a delay
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor, // Set the desired color here
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Colors.white.withAlpha(50),
          onTap: widget.onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withAlpha(50),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
