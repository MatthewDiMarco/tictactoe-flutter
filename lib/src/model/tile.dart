enum Tile {
  empty(''),
  x('X'),
  o('O'),
  xHover('X'),
  oHover('O');

  final String displayText;

  const Tile(this.displayText);

  bool isAvailable() {
    return this == Tile.empty || this == Tile.xHover || this == Tile.oHover;
  }
}
