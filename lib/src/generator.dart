import 'emitter.dart';
import 'scanner.dart';
import 'style.dart';

/// The generated libraries for [sources], keyed by output path.
///
/// Shared by the `build_runner` builder and the standalone CLI so both
/// produce byte-identical output.
class GenerationResult {
  /// Generated source keyed by path relative to the package root.
  final Map<String, String> libraries;

  /// Names that looked like icon references but are not known icons.
  final Set<String> unknownIcons;

  const GenerationResult({required this.libraries, required this.unknownIcons});
}

GenerationResult generate(Iterable<String> sources) {
  final scan = scanSources(sources);

  return GenerationResult(
    libraries: {
      for (final style in FontAwesomeStyle.values)
        style.outputPath: emitLibrary(
          style,
          scan.icons.where((icon) => icon.style.id == style.id),
        ),
    },
    unknownIcons: scan.unknownIcons,
  );
}
