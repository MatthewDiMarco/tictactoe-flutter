import 'package:flutter/material.dart';
import 'package:tictactoe/src/model/tile.dart';
import 'dart:developer';

class Grid extends StatefulWidget {
  const Grid({super.key});

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final _size = const Size(3, 3); // TODO
  final _matrix = <List<String>>[];
  final _moves = <MapEntry>[];

  @override
  void initState() {
    super.initState();
    _clearGrid();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          _matrix.length,
          (row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _matrix[row].length, (col) => _buildTile(row, col)),
              )),
    );
  }

  Widget _buildTile(int row, int col) {
    log(_matrix.toString());
    return Container(
      margin: const EdgeInsets.all(6),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 100),
              foregroundColor: const Color.fromARGB(255, 20, 20, 20),
              backgroundColor: const Color.fromARGB(255, 218, 218, 218)),
          child: Text(_matrix[row][col], style: const TextStyle(fontSize: 48)),
          onPressed: () => _onTilePressed(row, col)),
    );
  }

  void _onTilePressed(int row, int col) {
    var selectedTile = _matrix[row][col];
    if (selectedTile == Tile.empty) {
      var lastMove = _moves.isEmpty ? Tile.X : _moves.last.value;
      var currMove = lastMove == Tile.X ? Tile.O : Tile.X;
      setState(() {
        _matrix[row][col] = currMove;
        _moves.add(MapEntry(MapEntry(row, col), currMove));
      });
    }
  }

  void _clearGrid() {
    setState(() => _matrix.addAll(List.generate(
        _size.width.toInt(),
        (index) =>
            List.generate(_size.height.toInt(), (index) => Tile.empty))));
  }
}

class GridController extends ChangeNotifier {}
