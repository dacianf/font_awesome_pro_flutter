/// A FontAwesome icon style and every name derived from it.
///
/// This is an explicit table rather than something derived with `ReCase` so
/// the prefix matched in user code (`FASharpSolid`) and the id used to group
/// icons (`sharp-solid`) can never drift apart.
class FontAwesomeStyle {
  /// Style id, matching the keys used by FontAwesome itself.
  final String id;

  /// PascalCase segment shared by the class name and the font family.
  final String prefix;

  /// Basename of the generated library, without the `.dart` extension.
  final String fileName;

  const FontAwesomeStyle._(this.id, this.prefix, this.fileName);

  /// Name of the generated class, e.g. `FASharpSolid`.
  String get className => 'FA$prefix';

  /// Font family the generated [IconData]s point at.
  String get fontFamily => 'FontAwesome$prefix';

  /// Path of the generated library, relative to the package root.
  ///
  /// Always uses `/` separators: this is both an asset path and a posix path.
  String get outputPath => '$outputDirectory/$fileName.dart';

  /// Directory all generated libraries are written to.
  static const outputDirectory = 'lib/font_awesome';

  static const values = [
    FontAwesomeStyle._('solid', 'Solid', 'solid'),
    FontAwesomeStyle._('regular', 'Regular', 'regular'),
    FontAwesomeStyle._('light', 'Light', 'light'),
    FontAwesomeStyle._('thin', 'Thin', 'thin'),
    FontAwesomeStyle._('brands', 'Brands', 'brands'),
    FontAwesomeStyle._('duotone', 'Duotone', 'duotone'),
    FontAwesomeStyle._('sharp-solid', 'SharpSolid', 'sharp_solid'),
    FontAwesomeStyle._('sharp-regular', 'SharpRegular', 'sharp_regular'),
  ];

  static final _byPrefix = {for (final s in values) s.prefix: s};

  /// The style whose class is `FA[prefix]`, or `null` if there is none.
  static FontAwesomeStyle? byPrefix(String prefix) => _byPrefix[prefix];

  @override
  String toString() => id;
}
