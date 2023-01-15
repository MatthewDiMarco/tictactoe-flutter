import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/src/widget/footer_button.dart';
import 'package:tictactoe/src/widget/grid.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with TickerProviderStateMixin {
  static const primaryColor = Color.fromARGB(255, 218, 218, 218);
  static const secondaryColor = Color.fromARGB(255, 62, 62, 62);
  final gridState = GlobalKey<GridState>();

  final TransformationController _transformationController =
      TransformationController();
  // Animation<Matrix4>? _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _transformationController.addListener(() {
      //print(_transformationController.value.toString());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // TODO hitting +/- re-centers and scales
        backgroundColor: secondaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    transformationController: _transformationController,
                    minScale: 0.1,
                    maxScale: 1.6,
                    constrained: false,
                    onInteractionStart: (details) {},
                    child: Grid(key: gridState))),
            _buildFooter()
          ],
        ));
    // return Column(children: [
    //   Expanded(
    //       child: InteractiveViewer(
    //           boundaryMargin: const EdgeInsets.all(double.infinity),
    //           maxScale: 1.6,
    //           minScale: 0.6,
    //           transformationController: _controllerTransform,
    //           onInteractionStart: _onInteractionStart,
    //           constrained: false,
    //           child: Grid(key: gridState))),
    //   _buildFooter()
    // ]);
  }

  Widget _buildFooter() {
    const footerButtonPadding = EdgeInsets.all(8.0);

    return Ink(
        color: secondaryColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.remove, color: primaryColor),
              onTap: _shrinkGrid),
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.refresh, color: primaryColor),
              onTap: _refreshGrid),
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.center_focus_strong, color: primaryColor),
              onTap: () {
                final gridSize = gridState.currentContext?.size;
                final gridLength = gridSize!.width;

                final screen = MediaQuery.of(context).size;
                final scale = min(1.2, screen.width / gridLength);

                final animation = Matrix4Tween(
                        begin: _transformationController.value,
                        end: Matrix4.identity()
                          ..scale(scale, scale)
                          ..translate(
                              ((screen.width / scale) / 2) - ((gridLength) / 2),
                              ((screen.height / scale) / 2) -
                                  ((gridLength) / 2)))
                    .animate(_animationController);
                animation.addListener(() {
                  _transformationController.value = animation.value;
                });
                _animationController.reset();
                // _animationController.forward();
                _animationController.fling();
                // setState(() {
                //   _transformationController.value = Matrix4.identity();
                // });
              }),
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.add, color: primaryColor),
              onTap: _growGrid)
        ]));
  }

  void _shrinkGrid() {
    final state = gridState.currentState!;
    state.growGrid(-1);
  }

  void _growGrid() {
    final state = gridState.currentState!;
    state.growGrid(1);
  }

  void _refreshGrid() {
    final state = gridState.currentState!;
    state.resetGrid();
  }

  // void _onAnimateReset() {
  //   _controllerTransform.value = _animationReset!.value;
  //   if (!_controllerReset.isAnimating) {
  //     _animationReset!.removeListener(_onAnimateReset);
  //     _animationReset = null;
  //     _controllerReset.reset();
  //   }
  // }

  // void _animateResetInitialize() {
  //   _controllerReset.reset();
  //   _animationReset =
  //       Matrix4Tween(begin: _controllerTransform.value, end: Matrix4.identity())
  //           .animate(_controllerReset);
  //   _animationReset!.addListener(_onAnimateReset);
  //   _controllerReset.forward();
  // }

  // void _animateResetStop() {
  //   _controllerReset.stop();
  //   _animationReset?.removeListener(_onAnimateReset);
  //   _animationReset = null;
  //   _controllerReset.reset();
  // }

  // void _onInteractionStart(ScaleStartDetails details) {
  //   if (_controllerReset.status == AnimationStatus.forward) {
  //     _animateResetStop();
  //   }
  // }
}
