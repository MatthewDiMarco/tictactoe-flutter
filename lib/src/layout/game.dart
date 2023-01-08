import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tictactoe/src/widget/footer_button.dart';
import 'package:tictactoe/src/widget/grid.dart';

// TODO gesture detector: 360 draggable scroll view for grid
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
        backgroundColor: secondaryColor,
        body: Column(children: [_buildBody(), _buildFooter()]));
  }

  Widget _buildBody() {
    return Expanded(
        child: Center(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Grid(key: gridState)])))));
  }

  Widget _buildFooter() {
    const footerButtonPadding = EdgeInsets.all(8.0);

    return Ink(
        color: secondaryColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FooterButton(
              // TODO import <function,icon> pair and dynamically construct footer
              padding: footerButtonPadding,
              icon: const Icon(Icons.arrow_downward, color: primaryColor),
              onTap: _shrinkGrid),
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.refresh, color: primaryColor),
              onTap: _refreshGrid),
          FooterButton(
              padding: footerButtonPadding,
              icon: const Icon(Icons.arrow_upward, color: primaryColor),
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
