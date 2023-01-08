import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/src/widget/footer_button.dart';
import 'package:tictactoe/src/widget/grid.dart';

// TODO center matrix onto screen button
// TODO fix: on startup, InteractiveView scale / child should be auto configured / centered
// ^ look into callbacks / controller
// TODO when grid goes off screen, create a rim-hugging icon that shows where it is (smash bros)
// TODO win state
// TODO void cells

class Game extends StatelessWidget {
  static const primaryColor = Color.fromARGB(255, 218, 218, 218);
  static const secondaryColor = Color.fromARGB(255, 62, 62, 62);
  final gridState = GlobalKey<GridState>();

  Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text('TTT'),
        ),
        backgroundColor: secondaryColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBody(MediaQuery.of(context).size),
              _buildFooter()
            ]));
  }

  Widget _buildBody(Size viewSize) {
    return Expanded(
        child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(double.infinity),
            maxScale: 1.6,
            minScale: 0.6,
            constrained: false,
            child: Grid(key: gridState)));
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
              onTap: () {}), // TODO
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
}
