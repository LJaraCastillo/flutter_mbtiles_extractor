part of mbtiles_extractor;

class Tile {
  ///The corresponding zoom of the tile.
  ///This is the Z axis.
  int zoom;

  ///The column of the tile.
  ///This is the X axis.
  int column;

  ///The row of the tile.
  ///This is the Y axis.
  int row;

  Tile(this.zoom, this.column, this.row);

  Tile.fromMap(Map map) {
    this.zoom = map['zoom'];
    this.column = map['column'];
    this.row = map['row'];
  }

  Map<String, dynamic> toMap() {
    return {
      'zoom': this.zoom,
      'column': this.column,
      'row': this.row,
    };
  }
}
