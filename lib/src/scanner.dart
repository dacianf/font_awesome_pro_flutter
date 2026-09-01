import 'package:recase/recase.dart';

import 'icon_reference.dart';
import 'style.dart';

/// Matches `FASolid.faCirclePlus` and friends in Dart source.
///
/// This is a text scan rather than an AST walk on purpose. The only thing
/// this package ever needed from the analyzer was the *spelling* of a
/// prefixed identifier, and depending on `analyzer` for that pinned the
/// package to one analyzer major at a time -- which is what kept it colliding
/// with `riverpod_generator`, `freezed` and `json_serializable` on every
/// release. See README.md#no-analyzer-dependency.
///
/// The trade-off: a reference inside a comment or a string literal also
/// counts. That only ever adds an unused `static const` to the output, which
/// is tree-shaken away.
final _referencePattern = RegExp(
  r'\bFA(' +
      FontAwesomeStyle.values.map((s) => s.prefix).join('|') +
      r')\s*\.\s*fa([A-Za-z0-9]+)\b',
);

/// Icon references found in a set of sources, plus anything unrecognised.
class ScanResult {
  /// References to icons this package knows a code point for.
  final Set<IconReference> icons;

  /// Names that looked like icon references but are not in `iconsMap`.
  ///
  /// Reported rather than thrown on: with a text scan these are usually a
  /// typo or a match inside prose, and neither should fail a build.
  final Set<String> unknownIcons;

  const ScanResult({required this.icons, required this.unknownIcons});
}

/// Collects every icon reference in [sources].
ScanResult scanSources(Iterable<String> sources) {
  final icons = <IconReference>{};
  final unknown = <String>{};

  for (final source in sources) {
    for (final match in _referencePattern.allMatches(source)) {
      final style = FontAwesomeStyle.byPrefix(match.group(1)!);
      if (style == null) continue;

      final reference = IconReference(
        style: style,
        name: ReCase(match.group(2)!).paramCase,
      );
      if (reference.codePoint == null) {
        unknown.add('${style.className}.fa${match.group(2)!}');
      } else {
        icons.add(reference);
      }
    }
  }

  return ScanResult(icons: icons, unknownIcons: unknown);
}
