import 'package:flutter/material.dart';

import '../image_screen/image_screen.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();
    return Hero(
      tag: tag,
      child: Stack(
        children: <Widget>[
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200)).then(
                    (_) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.white.withOpacity(0),
                          pageBuilder: (BuildContext context, _, __) {
                            return ImageScreen(
                              tag: tag,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
