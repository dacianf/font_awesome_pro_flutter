import 'package:font_awesome_pro_flutter/src/scanner.dart';
import 'package:test/test.dart';

void main() {
  group('scanSources', () {
    test('finds references across whitespace', () {
      final result = scanSources(['const v = FASolid\n    .faHouse;']);

      expect(result.icons.map((i) => i.toString()), ['FASolid.faHouse']);
      expect(result.unknownIcons, isEmpty);
    });

    test('ignores identifiers that only look like references', () {
      final result = scanSources([
        'const a = FAKESolid.faHouse;',
        'const b = FASolid.house;',
        'const c = FANotAStyle.faHouse;',
      ]);

      expect(result.icons, isEmpty);
      expect(result.unknownIcons, isEmpty);
    });

    test('separates unknown icon names from known ones', () {
      final result = scanSources([
        'const a = FASolid.faHouse; const b = FASolid.faNotAnIcon;',
      ]);

      expect(result.icons.map((i) => i.name), ['house']);
      expect(result.unknownIcons, ['FASolid.faNotAnIcon']);
    });

    test('deduplicates repeated references', () {
      final result = scanSources([
        'const a = FASolid.faHouse;',
        'const b = FASolid.faHouse;',
        'const c = FARegular.faHouse;',
      ]);

      expect(result.icons, hasLength(2));
    });
  });
}
