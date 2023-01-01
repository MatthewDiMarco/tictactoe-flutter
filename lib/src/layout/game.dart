import 'package:flutter/material.dart';
import 'package:tictactoe/src/widget/grid.dart';

// TODO matrix resize limit function of window dimensions (MediaQuery)
// TODO win state
// TODO void cells

class Game extends StatelessWidget {
  final gridState = GlobalKey<GridState>();

  Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 62, 62, 62),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Grid(key: gridState)]),
        persistentFooterButtons: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                icon: const Icon(Icons.exposure_minus_1,
                    color: Color.fromARGB(255, 218, 218, 218)),
                iconSize: 48,
                onPressed: () {
                  final state = gridState.currentState!;
                  state.growGrid(-1);
                }),
            IconButton(
                icon: const Icon(Icons.replay,
                    color: Color.fromARGB(255, 218, 218, 218)),
                iconSize: 48,
                onPressed: () {
                  final state = gridState.currentState!;
                  state.resetGrid();
                }),
            IconButton(
                icon: const Icon(Icons.exposure_plus_1,
                    color: Color.fromARGB(255, 218, 218, 218)),
                iconSize: 48,
                onPressed: () {
                  final state = gridState.currentState!;
                  state.growGrid(1);
                })
          ])
        ]);
  }
}
