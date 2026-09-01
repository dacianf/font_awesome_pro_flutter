import 'package:recase/recase.dart';

import '../icons.dart';
import 'style.dart';

/// A single `FA<Style>.fa<Icon>` reference found in user code.
class IconReference implements Comparable<IconReference> {
  final FontAwesomeStyle style;

  /// Icon name in FontAwesome's own kebab-case form, e.g. `circle-plus`.
  final String name;

  const IconReference({required this.style, required this.name});

  /// Name of the generated field, e.g. `faCirclePlus`.
  String get fieldName => ReCase('fa-$name').camelCase;

  /// Code point of the glyph, or `null` if [name] is not a known icon.
  int? get codePoint {
    final unicode = iconsMap[name];
    return unicode == null ? null : int.parse(unicode, radix: 16);
  }

  @override
  bool operator ==(Object other) =>
      other is IconReference &&
      other.style.id == style.id &&
      other.name == name;

  @override
  int get hashCode => Object.hash(style.id, name);

  /// Orders by name so generated output is stable across builds.
  @override
  int compareTo(IconReference other) => name.compareTo(other.name);

  @override
  String toString() => '${style.className}.$fieldName';
}
