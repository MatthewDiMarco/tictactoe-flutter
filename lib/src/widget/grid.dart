import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/src/model/tile.dart';
import 'dart:math';

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  GridState createState() => GridState();
}

class GridState extends State<Grid> {
  static const defaultMatrixSize = 3;
  static const defaultNumMatches = 3;
  static const numMatchPadding = 4;
  static const tileSize = Size(80, 80);
  static const tileMargin = EdgeInsets.all(6);

  final _matrix = <List<Tile>>[];
  final _moves = <MapEntry>[];
  var isGridFrozen = false;

  @override
  void initState() {
    super.initState();
    _setGrid(defaultMatrixSize, defaultMatrixSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 62, 62, 62),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              _matrix.length,
              (row) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _matrix[row].length, (col) => _buildTile(row, col)),
                  )),
        ));
  }

  void resetGrid() {
    growGrid(0);
  }

  void growGrid(int amount) {
    final numHorizontalTiles = _matrix.length + amount;
    final numVerticalTiles = _matrix[0].length + amount;
    if (numHorizontalTiles >= 3 && numVerticalTiles >= 3) {
      _setGrid(numHorizontalTiles, numVerticalTiles);
    }
    isGridFrozen = false;
  }

  Widget _buildTile(int row, int col) {
    return Container(
      margin: tileMargin,
      child: IgnorePointer(
          ignoring: isGridFrozen,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: tileSize,
                  foregroundColor: const Color.fromARGB(255, 20, 20, 20),
                  backgroundColor: _matrix[row][col].isAvailable()
                      ? const Color.fromARGB(255, 218, 218, 218)
                      : _matrix[row][col] == Tile.x
                          ? Colors.redAccent
                          : Colors.greenAccent),
              child: Text(_matrix[row][col].displayText,
                  style: TextStyle(
                      fontSize: 48,
                      color: _matrix[row][col].isAvailable()
                          ? const Color.fromARGB(255, 162, 162, 162)
                          : Colors.black)),
              onPressed: () => _onTilePressed(row, col),
              onHover: (val) => _onTileHover(row, col, val))),
    );
  }

  void _onTilePressed(int row, int col) {
    var selectedTile = _matrix[row][col];
    if (selectedTile.isAvailable()) {
      var lastMove = _getLastMove();
      var currMove = lastMove == Tile.x ? Tile.o : Tile.x;
      setState(() {
        _matrix[row][col] = currMove;
        _moves.add(MapEntry(MapEntry(row, col), currMove));
        if (_isWin(row, col,
            max(defaultNumMatches, _matrix.length - numMatchPadding))) {
          _onGameEnd("Winner! ${_matrix[row][col].displayText}");
        } else if (_isStalemate()) {
          _onGameEnd("Stalemate!");
        }
      });
    }
  }

  void _onTileHover(int row, int col, bool mouseEnter) {
    final selectedTile = _matrix[row][col];
    if (selectedTile.isAvailable()) {
      setState(() {
        final lastMove = _getLastMove();
        _matrix[row][col] = mouseEnter
            ? lastMove == Tile.x
                ? Tile.oHover
                : Tile.xHover
            : Tile.empty;
      });
    }
  }

  void _onGameEnd(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text(message));
        });
    isGridFrozen = true;
  }

  bool _isWin(int row, int col, int matchesNeeded) {
    bool isPositionContainingMatch(List<int> pos, Tile target) {
      return pos[0] >= 0 &&
          pos[1] >= 0 &&
          pos[0] < _matrix.length &&
          pos[1] < _matrix[0].length &&
          _matrix[pos[0]][pos[1]] == target;
    }

    final targetTile = _matrix[row][col];
    final directions = [
      [1, 0], // vertical
      [0, 1], // horizontal
      [1, 1], // main diagonal
      [-1, 1] // counter diagonal
    ];

    int numMatches;
    var iterator = directions.iterator;
    iterator.moveNext();
    do {
      numMatches = 1;
      var currDirection = iterator.current;
      var direction = List.of(currDirection);
      var position = [row, col];
      var exploringPath = true;
      do {
        position[0] = position[0] + direction[0]; // move vertical
        position[1] = position[1] + direction[1]; // move horizontal
        if (isPositionContainingMatch(position, targetTile)) {
          numMatches++;
        } else {
          position = [row, col];
          direction = direction.map((dir) => -dir).toList();
          if (listEquals(direction, currDirection)) {
            exploringPath = false;
          }
        }
      } while (numMatches < matchesNeeded && exploringPath);
    } while (numMatches < matchesNeeded && iterator.moveNext());

    return numMatches == matchesNeeded;
  }

  bool _isStalemate() {
    return _matrix.where((element) => element.contains(Tile.empty)).isEmpty;
  }

  void _setGrid(int width, int height) {
    setState(() {
      _moves.clear();
      _matrix.clear();
      _matrix.addAll(List.generate(
          width, (index) => List.generate(height, (index) => Tile.empty)));
    });
  }

  Tile _getLastMove() {
    return _moves.isEmpty ? Tile.x : _moves.last.value;
  }
}
