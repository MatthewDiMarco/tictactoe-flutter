import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tictactoe/src/widget/grid.dart';
import 'package:tictactoe/src/widget/icon_menu.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  static const viewMaxScale = 1.6;
  static const viewMinScale = 0.3;

  final gridState = GlobalKey<GridState>();
  late final TransformationController _transformationController;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _centerGrid();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [_buildGameView(), _buildFooter()],
        ));
  }

  Widget _buildGameView() {
    return Expanded(
        child: InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(double.infinity),
      transformationController: _transformationController,
      constrained: false,
      minScale: viewMinScale,
      maxScale: viewMaxScale,
      child: Grid(key: gridState),
    ));
  }

  Widget _buildFooter() {
    MapEntry<Icon, Function()> buildFooterAction(
        IconData icon, Function() func) {
      return MapEntry(Icon(icon, color: Theme.of(context).primaryColor), func);
    }

    return IconMenu(
        padding: const EdgeInsets.all(8.0),
        color: Theme.of(context).backgroundColor,
        actions: [
          buildFooterAction(Icons.remove, _shrinkGrid),
          buildFooterAction(Icons.refresh, _refreshGrid),
          buildFooterAction(Icons.center_focus_strong, _centerGrid),
          buildFooterAction(Icons.add, _growGrid)
        ]);
  }

  void _growGrid() {
    final state = gridState.currentState!;
    state.growGrid(1);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _centerGrid();
    });
  }

  void _shrinkGrid() {
    final state = gridState.currentState!;
    state.growGrid(-1);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _centerGrid();
    });
  }

  void _refreshGrid() {
    final state = gridState.currentState!;
    state.resetGrid();
    _centerGrid();
  }

  void _centerGrid() {
    final animation = _buildGridCenterAnimation();
    animation
        .addListener(() => _transformationController.value = animation.value);
    _animationController.reset();
    _animationController.fling();
  }

  Animation<Matrix4> _buildGridCenterAnimation() {
    final gridSize = gridState.currentContext?.size;
    final gridLength = gridSize!.width;
    final screen = MediaQuery.of(context).size;
    final scale = _calcScaleFactorToFitChild(screen, gridLength);

    return Matrix4Tween(
            begin: _transformationController.value,
            end: Matrix4.identity()
              ..scale(scale, scale)
              ..translate(
                  _calcOffsetToCenterChild(screen.width, gridLength, scale),
                  _calcOffsetToCenterChild(screen.height, gridLength, scale)))
        .animate(_animationController);
  }

  // given the screen dimensions and the length of some child widget,
  // calculate the scale factor needed to fit the child within the screen,
  // in both cases where the width might exceed the height, and vice-versa;
  // includes a generous amount of padding
  double _calcScaleFactorToFitChild(Size screen, double childLength) {
    const paddingFactor = 1.1;
    return min(viewMaxScale,
        min(screen.width, screen.height) / (childLength * paddingFactor));
  }

  // given the length of the screen and child widget, for a given dimension,
  // calculate the offset needed to center the child along that dimension when
  // translating it, accounting for the scale and the child's own length.
  double _calcOffsetToCenterChild(
      double screenLength, double childLength, double scale) {
    return ((screenLength / scale) / 2) - (childLength / 2);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
