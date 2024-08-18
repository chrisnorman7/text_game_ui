import 'dart:async';
import 'dart:math';

import 'default_keys.dart';
import 'game_directions.dart';
import 'simple_key_handler.dart';

/// The default filler character.
const defaultFillCharacter = ' ';

/// The default cursor character.
const defaultCursorCharacter = '⠿';

/// A cursor position.
typedef CursorPosition = Point<int>;

/// The type of a function which handles keys.
typedef KeyHandler = FutureOr<bool> Function(String key);

/// The default movement keys to use.
const defaultMovementKeys = <String, GameDirection>{
  DefaultKeys.cursorUp: GameDirection.up,
  DefaultKeys.cursorLeft: GameDirection.left,
  DefaultKeys.cursorDown: GameDirection.down,
  DefaultKeys.cursorRight: GameDirection.right,
};

/// The type for [SimpleKeyHandler] keys.
typedef KeyHandlerKeys = Map<String, FutureOr<bool> Function()>;
