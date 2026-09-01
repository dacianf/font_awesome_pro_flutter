import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

import 'src/generator.dart';
import 'src/style.dart';

export 'src/generator.dart' show GenerationResult, generate;
export 'src/style.dart' show FontAwesomeStyle;

/// Generates one library of `IconData` constants per FontAwesome style,
/// containing only the icons actually referenced in the package's `lib/`.
class FontAwesomePro extends Builder {
  /// A static method to initialize the builder.
  static FontAwesomePro builder(BuilderOptions options) => FontAwesomePro();

  static final _allDartFiles = Glob('lib/**.dart');

  static final _buildExtensions = {
    r'lib/$lib$': [
      for (final style in FontAwesomeStyle.values) style.outputPath
    ],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final sources = <String>[];
    await for (final input in buildStep.findAssets(_allDartFiles)) {
      // Skip our own output, so a build is idempotent.
      if (input.path.startsWith('${FontAwesomeStyle.outputDirectory}/'))
        continue;
      sources.add(await buildStep.readAsString(input));
    }

    final result = generate(sources);
    for (final unknown in result.unknownIcons) {
      log.warning('Unknown FontAwesome icon: $unknown');
    }

    await Future.wait([
      for (final entry in result.libraries.entries)
        buildStep.writeAsString(
          AssetId(buildStep.inputId.package, entry.key),
          entry.value,
        ),
    ]);
  }

  @override
  Map<String, List<String>> get buildExtensions => _buildExtensions;
}
