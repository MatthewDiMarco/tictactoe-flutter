import 'package:flutter/material.dart';
import 'package:tictactoe/src/widgets/grid.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 62, 62, 62),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Grid(),
            // IconButton(
            //     icon: Icon(Icons.replay,
            //         color: Color.fromARGB(255, 218, 218, 218)),
            //     iconSize: 48,
            //     onPressed: () {})
          ],
        ));
  }
}
