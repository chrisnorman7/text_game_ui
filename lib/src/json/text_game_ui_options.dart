import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;

part 'text_game_ui_options.g.dart';

/// The options for the text_game_ui package.
@JsonSerializable()
class TextGameUiOptions {
  /// Create an instance.
  const TextGameUiOptions({
    this.columns = 40,
    this.rows = 9,
  });

  /// Create an instance from a JSON object.
  factory TextGameUiOptions.fromJson(final Map<String, dynamic> json) =>
      _$TextGameUiOptionsFromJson(json);

  /// Load a saved instance.
  factory TextGameUiOptions.load() {
    if (optionsFile.existsSync()) {
      final source = optionsFile.readAsStringSync();
      final json = jsonDecode(source);
      return TextGameUiOptions.fromJson(json);
    }
    const options = TextGameUiOptions();
    optionsFile.writeAsStringSync(jsonEncode(options));
    return options;
  }

  /// Returns the file where options should be stored.
  static File get optionsFile {
    final homeEnvironmentVariable = Platform.isWindows ? 'userprofile' : 'HOME';
    final homeDirectoryPath = Platform.environment[homeEnvironmentVariable];
    if (homeDirectoryPath == null) {
      throw UnimplementedError(
        // ignore: lines_longer_than_80_chars
        'Need to know the name of the environment variable where the home directory is stored on ${Platform.operatingSystem} version ${Platform.operatingSystemVersion}.',
      );
    }
    final fullPath = path.join(
      homeDirectoryPath,
      optionsFilename,
    );
    return File(fullPath);
  }

  /// The name of the file where options are stored.
  static const optionsFilename = '.text-game-ui-options.json';

  /// The width of the screen.
  final int columns;

  /// The height of the screen.
  final int rows;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$TextGameUiOptionsToJson(this);
}
