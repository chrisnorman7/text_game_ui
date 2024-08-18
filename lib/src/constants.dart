import 'dart:async';
import 'dart:math';

/// The default filler character.
const defaultFillCharacter = ' ';

/// The default cursor character.
const defaultCursorCharacter = '⠿';

/// A cursor position.
typedef CursorPosition = Point<int>;

/// The type of a function which handles keys.
typedef KeyHandler = FutureOr<bool> Function(String key);
