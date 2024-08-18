import 'dart:io';
import 'dart:math';

import 'package:characters/characters.dart';

import 'constants.dart';
import 'exceptions.dart';
import 'game_directions.dart';
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
  CursorPosition cursorPosition;

  /// Move the cursor.
  ///
  /// If the new cursor position would move the cursor past the start or end of
  /// the current line, the cursor will be moved up or down accordingly. If this
  /// call would cause the cursor to move past [columns] and [rows] or before
  /// `0, 0`, [InvalidCursorPosition`, will be thrown.
  ///
  /// Note: calls to [moveCursor] do not redraw the screen. You must call
  /// [redrawScreen] manually.
  void moveCursor(final GameDirection direction) {
    final int xModifier;
    final int yModifier;
    switch (direction) {
      case GameDirection.up:
        xModifier = 0;
        yModifier = -1;
      case GameDirection.down:
        xModifier = 0;
        yModifier = 1;
      case GameDirection.left:
        xModifier = -1;
        yModifier = 0;
      case GameDirection.right:
        xModifier = 1;
        yModifier = 0;
    }
    var x = cursorPosition.x + xModifier;
    var y = cursorPosition.y + yModifier;
    if (x >= columns) {
      x = 0;
      y++;
    }
    if (x < 0 || y < 0 || x >= columns || y >= rows) {
      throw InvalidCursorPosition(Point(x, y));
    }
    cursorPosition = Point(x, y);
  }

  /// The current state of the screen.
  final Map<CursorPosition, String> _tiles;

  /// Clear the screen.
  void clearScreen() {
    if (Platform.isWindows) {
      Process.runSync('cls', [], runInShell: true);
    } else {
      stdout.write('\x1B[2J\x1B[0;0H');
    }
  }

  /// Redraw the screen.
  ///
  /// If [statusLines] is not empty, lines will be printed at the bottom of the
  /// screen, obscuring the tiles there.
  ///
  /// If the length of [statusLines] is greater than or equal to [rows],
  /// [StateError] will be thrown.
  ///
  /// Each line in [statusLines] must be no longer than [columns], otherwise
  /// [StateError] will be thrown.
  void redrawScreen({
    final List<String> statusLines = const [],
  }) {
    if (statusLines.length >= rows) {
      final lines = statusLines.length;
      throw StateError(
        'No more than $rows status lines can be shown. There are $lines.',
      );
    }
    clearScreen();
    final buffer = StringBuffer();
    final maxRows = rows - statusLines.length;
    for (var y = 0; y < maxRows; y++) {
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
    for (final line in statusLines) {
      final lineLength = line.length;
      if (lineLength >= columns) {
        throw StateError(
          'The status line must be no longer than $columns. It is $lineLength.',
        );
      }
      buffer
        ..write(line)
        ..write(Platform.lineTerminator);
    }
    stdout.write(buffer);
  }

  /// Set the tile character at [point].
  void setTile(final CursorPosition point, final String tileCharacter) {
    assert(
      tileCharacter.characters.length == 1,
      'Tile characters must be exactly 1 character in length.',
    );
    _tiles.remove(point);
    _tiles[point] = tileCharacter;
  }

  /// Set the tile at [cursorPosition] to [tileCharacter].
  void setTileAtCursorPosition(final String tileCharacter) =>
      setTile(cursorPosition, tileCharacter);

  /// Clear the tile at [point].
  void clearTile(final CursorPosition point) {
    _tiles.remove(point);
  }

  /// Clear the tile at [cursorPosition].
  void clearTileAtCursorPosition() => clearTile(cursorPosition);

  /// Get the tile character at [point].
  ///
  /// If [point] has no tile character, `null` will be returned.
  String? getTileCharacter(final CursorPosition point) => _tiles[point];

  /// Get the character which should be printed at [point].
  ///
  /// If [getTileCharacter] returns `null`, [fillCharacter] will be returned.
  String getCharacterAt(final CursorPosition point) =>
      getTileCharacter(point) ?? fillCharacter;

  /// Run the game.
  Future<void> run(final KeyHandler keyHandler) async {
    stdin
      ..echoMode = false
      ..lineMode = false;
    await for (final charCodes in stdin) {
      final key = String.fromCharCodes(charCodes);
      final shouldQuid = await keyHandler(key);
      if (shouldQuid) {
        clearScreen();
        stdin.lineMode = true;
        stdin.echoMode = true;
        break;
      }
    }
  }
}
