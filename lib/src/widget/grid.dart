import 'package:flutter/material.dart';
import 'package:tictactoe/src/model/tile.dart';

class Grid extends StatefulWidget {
  const Grid({Key? key}) : super(key: key);

  @override
  GridState createState() => GridState();
}

class GridState extends State<Grid> {
  static const defaultMatrixSize = 3;
  static const tileSize = Size(80, 80);
  static const tileMargin = EdgeInsets.all(6);
  final _matrix = <List<Tile>>[];
  final _moves = <MapEntry>[];

  @override
  void initState() {
    super.initState();
    _setGrid(defaultMatrixSize, defaultMatrixSize);
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

  void resetGrid() {
    growGrid(0);
  }

  void growGrid(int amount) {
    final numHorizontalTiles = _matrix.length + amount;
    final numVerticalTiles = _matrix[0].length + amount;

    if (numHorizontalTiles >= 1 && numVerticalTiles >= 1) {
      _setGrid(numHorizontalTiles, numVerticalTiles);
    }
  }

  Widget _buildTile(int row, int col) {
    return Container(
      margin: tileMargin,
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
          onHover: (val) => _onTileHover(row, col, val)),
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
      });
    }
  }

  void _onTileHover(int row, int col, bool mouseEnter) {
    var selectedTile = _matrix[row][col];
    if (selectedTile.isAvailable()) {
      setState(() {
        var lastMove = _getLastMove();
        _matrix[row][col] = mouseEnter
            ? lastMove == Tile.x
                ? Tile.oHover
                : Tile.xHover
            : Tile.empty;
      });
    }
  }

  void _setGrid(int width, int height) {
    setState(() {
      _matrix.clear();
      _matrix.addAll(List.generate(
          width, (index) => List.generate(height, (index) => Tile.empty)));
    });
  }

  Tile _getLastMove() {
    return _moves.isEmpty ? Tile.x : _moves.last.value;
  }
}

class GridController extends ChangeNotifier {}
