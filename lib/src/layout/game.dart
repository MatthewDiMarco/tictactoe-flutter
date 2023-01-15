import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe/src/widget/footer_button.dart';
import 'package:tictactoe/src/widget/game_view.dart';
import 'package:tictactoe/src/widget/grid.dart';

// TODO center matrix onto screen button
// TODO fix: on startup, InteractiveView scale / child should be auto configured / centered
// ^ look into callbacks / controller
// TODO when grid goes off screen, create a rim-hugging icon that shows where it is (smash bros)
// TODO win state
// TODO void cells
// TODO convert global key to controller for game view

class Game extends StatelessWidget {
  static const primaryColor = Color.fromARGB(255, 218, 218, 218);
  static const secondaryColor = Color.fromARGB(255, 62, 62, 62);

  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text('TTT'),
        ),
        backgroundColor: secondaryColor,
        body: const GameView());
  }
}
