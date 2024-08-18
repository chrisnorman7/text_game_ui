import 'dart:convert';
import 'dart:io';

/// A convenience class for loading and saving game options.
class GameOptionsLoader<T> {
  /// Create an instance.
  GameOptionsLoader({
    required this.filename,
    required this.loadOptions,
    this.dumpOptions = jsonEncode,
  });

  /// Get the user's home directory.
  static String get homeDirectory {
    final homeEnvironmentVariable = Platform.isWindows ? 'userprofile' : 'HOME';
    final homeDirectoryPath = Platform.environment[homeEnvironmentVariable];
    if (homeDirectoryPath == null) {
      throw UnimplementedError(
        // ignore: lines_longer_than_80_chars
        'Need to know the name of the environment variable where the home directory is stored on ${Platform.operatingSystem} version ${Platform.operatingSystemVersion}.',
      );
    }
    return homeDirectoryPath;
  }

  /// The name of the file where options are saved.
  final String filename;

  /// The file where options will be stored.
  File get file => File(filename);

  /// The function to call to convert a [String] to [T].
  final T Function(String? source) loadOptions;

  /// The function to call to convert [T] to a [String].
  final String Function(T options) dumpOptions;

  T? _cache;

  /// Get a loaded options instance.
  T get options {
    final cache = _cache;
    if (cache != null) {
      return cache;
    }
    if (file.existsSync()) {
      final string = file.readAsStringSync();
      final instance = loadOptions(string);
      _cache = instance;
      return instance;
    }
    final instance = loadOptions(null);
    _cache = instance;
    return instance;
  }

  /// Save [options].
  void save() {
    final source = dumpOptions(options);
    file.writeAsStringSync(source);
  }

  /// Reload [options].
  void reload() {
    _cache = null;
  }
}
