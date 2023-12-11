import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kRouteDuration = Duration(milliseconds: 300);

class InstaImageViewer extends StatelessWidget {
  const InstaImageViewer({
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
                            return FullScreenViewer(
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

class FullScreenViewer extends StatefulWidget {
  const FullScreenViewer({
    super.key,
    required this.child,
    required this.tag,
  });

  final Widget child;
  final UniqueKey tag;

  @override
  _FullScreenViewerState createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenViewer>
    with TickerProviderStateMixin {
  double? _initialPositionY = 0;

  double? _currentPositionY = 0;

  double _positionYDelta = 0;

  double _opacity = 1;

  final double _disposeLimit = 100;

  Duration _animationDuration = Duration.zero;

  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4>? _animationReset;
  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: _controllerReset, curve: Curves.fastOutSlowIn));
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  void _animateZoomInInitialize(Offset tapPosition) {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: Matrix4.identity(),
      end: Matrix4.diagonal3Values(2, 2, 1)
        ..translate(-(tapPosition.dx / 2), -(tapPosition.dy / 2)),
    ).animate(
        CurvedAnimation(parent: _controllerReset, curve: Curves.fastOutSlowIn));

    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  bool _isZoomed() {
    return _transformationController.value.row0[0] > 1;
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }

    if (_isZoomed()) {
      return;
    }

    setState(() {
      _initialPositionY = details.focalPoint.dy;
    });
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (_isZoomed()) {
      return;
    }

    setState(() {
      _currentPositionY = details.focalPoint.dy;
      _positionYDelta = _currentPositionY! - _initialPositionY!;
      setOpacity();
    });
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    if (_isZoomed()) {
      return;
    }

    if (_positionYDelta > _disposeLimit || _positionYDelta < -_disposeLimit) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _animationDuration = _kRouteDuration;
        _opacity = 1;
        _positionYDelta = 0;
      });

      Future.delayed(_animationDuration).then((_) {
        setState(() {
          _animationDuration = Duration.zero;
        });
      });
    }
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  _doubleTap(TapDownDetails details) {
    if (_transformationController.value != Matrix4.identity()) {
      _animateResetInitialize();
    } else {
      _animateZoomInInitialize(details.localPosition);
    }
  }

  setOpacity() {
    final double tmp = _positionYDelta < 0
        ? 1 - ((_positionYDelta / 1000) * -1)
        : 1 - (_positionYDelta / 1000);

    if (tmp > 1) {
      _opacity = 1;
    } else if (tmp < 0) {
      _opacity = 0;
    } else {
      _opacity = tmp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPosition = 0 + max(_positionYDelta, -_positionYDelta) / 15;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        color: const Color(
          0xff000000,
        ).withOpacity(_opacity),
        alignment: Alignment.center,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: _animationDuration,
              curve: Curves.fastOutSlowIn,
              top: 0 + _positionYDelta,
              bottom: 0 - _positionYDelta,
              left: horizontalPosition,
              right: horizontalPosition,
              child: GestureDetector(
                onDoubleTapDown: (details) => _doubleTap(details),
                child: InteractiveViewer(
                    minScale: 1,
                    transformationController: _transformationController,
                    onInteractionStart: _onInteractionStart,
                    onInteractionUpdate: _onInteractionUpdate,
                    onInteractionEnd: _onInteractionEnd,
                    child: Hero(
                      tag: widget.tag,
                      child: widget.child,
                    )),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 30, 0),
                child: IconButton.filled(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
