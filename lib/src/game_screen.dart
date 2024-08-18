import 'dart:io';
import 'dart:math';

import 'package:characters/characters.dart';

import 'constants.dart';
import 'json/text_game_ui_options.dart';

/// A screen for a game.
class GameScreen {
  /// Create an instance.
  GameScreen({
    required this.columns,
    required this.rows,
    this.fillCharacter = defaultFillCharacter,
    this.cursorCharacter = defaultCursorCharacter,
    this.cursorPosition = const Point(0, 0),
  }) : _tiles = {};

  /// Create an instance from [options].
  GameScreen.fromOptions(
    final TextGameUiOptions options, {
    this.fillCharacter = defaultFillCharacter,
    this.cursorCharacter = defaultCursorCharacter,
  })  : columns = options.columns,
        rows = options.rows,
        cursorPosition = const Point(0, 0),
        _tiles = {};

  /// Returns an instance loaded with user options.
  factory GameScreen.fromLoadedOptions({
    final String fillCharacter = defaultFillCharacter,
    final String cursor = defaultCursorCharacter,
  }) {
    final options = TextGameUiOptions.load();
    return GameScreen(
      columns: options.columns,
      rows: options.rows,
      cursorCharacter: cursor,
      fillCharacter: fillCharacter,
    );
  }

  /// The width of the screen.
  final int columns;

  /// The height of the screen.
  final int rows;

  /// The default fill character.
  final String fillCharacter;

  /// The cursor character to use.
  final String cursorCharacter;

  /// The current location of the cursor.
  Point<int> cursorPosition;

  /// The current state of the screen.
  final Map<Point<int>, String> _tiles;

  /// Clears the terminal screen in a cross-platform way.
  void clearScreen() {
    // Check if the platform is Windows
    if (Platform.isWindows) {
      // Send a command to clear the console screen on Windows
      stdout.write('\x1B[2J\x1B[0;0H');
    } else {
      // Send the escape sequence to clear the console on Unix-like systems
      stdout.write('\x1B[2J\x1B[H');
    }
    // Flush the output to make sure the screen is cleared immediately
  }

  /// Redraw the screen.
  void redrawScreen() {
    clearScreen();
    final buffer = StringBuffer();
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < columns; x++) {
        final point = Point(x, y);
        final String character;
        if (point == cursorPosition) {
          character = cursorCharacter;
        } else {
          character = getCharacterAt(point);
        }
        buffer.write(character);
      }
      buffer.write(Platform.lineTerminator);
    }
    stdout.write(buffer);
  }

  /// Set the tile character at [point].
  void setTile(final Point<int> point, final String tileCharacter) {
    assert(
      tileCharacter.characters.length == 1,
      'Tile characters must be exactly 1 character in length.',
    );
    final old = _tiles.remove(point);
    if (old != tileCharacter) {
      redrawScreen();
    }
    _tiles[point] = tileCharacter;
  }

  /// Clear the tile at [point].
  void clearTile(final Point<int> point) {
    final oldCharacter = _tiles.remove(point);
    if (oldCharacter != null) {
      redrawScreen();
    }
  }

  /// Get the tile character at [point].
  ///
  /// If [point] has no tile character, `null` will be returned.
  String? getTileCharacter(final Point<int> point) => _tiles[point];

  /// Get the character which should be printed at [point].
  ///
  /// If [getTileCharacter] returns `null`, [fillCharacter] will be returned.
  String getCharacterAt(final Point<int> point) =>
      getTileCharacter(point) ?? fillCharacter;
}
