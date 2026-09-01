import 'package:build_test/build_test.dart';
import 'package:font_awesome_pro_flutter/builder.dart';
import 'package:test/test.dart';

/// Every library the builder is contractually obliged to emit.
Map<String, Object> _outputs(Map<String, Object> overrides) => {
      for (final style in FontAwesomeStyle.values)
        'a|${style.outputPath}': overrides['a|${style.outputPath}'] ??
            decodedMatches(contains('class ${style.className}')),
    };

void main() {
  group('FontAwesomePro builder', () {
    test('emits one library per style', () async {
      await testBuilder(
        FontAwesomePro(),
        {'a|lib/foo.dart': 'const v = FASolid.faAlbumCollectionCirclePlus;'},
        rootPackage: 'a',
        outputs: _outputs({
          'a|lib/font_awesome/solid.dart': decodedMatches(
            stringContainsInOrder(
              ['class FASolid', 'faAlbumCollectionCirclePlus'],
            ),
          ),
        }),
      );
    });

    test('generates icons for sharp styles', () async {
      await testBuilder(
        FontAwesomePro(),
        {
          'a|lib/foo.dart': '''
const a = FASharpSolid.faHouse;
const b = FASharpRegular.faHouse;
''',
        },
        rootPackage: 'a',
        outputs: _outputs({
          'a|lib/font_awesome/sharp_solid.dart': decodedMatches(
            stringContainsInOrder(
              ['class FASharpSolid', 'faHouse', "'FontAwesomeSharpSolid'"],
            ),
          ),
          'a|lib/font_awesome/sharp_regular.dart': decodedMatches(
            stringContainsInOrder(
              ['class FASharpRegular', 'faHouse', "'FontAwesomeSharpRegular'"],
            ),
          ),
        }),
      );
    });

    test('only emits the referenced icons, in a stable order', () async {
      await testBuilder(
        FontAwesomePro(),
        {
          'a|lib/b.dart': 'const b = FASolid.faZ;',
          'a|lib/a.dart': 'const a = FASolid.faA;',
        },
        rootPackage: 'a',
        outputs: _outputs({
          'a|lib/font_awesome/solid.dart': decodedMatches(
            allOf(
              stringContainsInOrder(['faA', 'faZ']),
              isNot(contains('faHouse')),
            ),
          ),
        }),
      );
    });

    test('warns on an unknown icon instead of failing the build', () async {
      final logs = <String>[];

      await testBuilder(
        FontAwesomePro(),
        {'a|lib/foo.dart': 'const v = FASolid.faDefinitelyNotAnIcon;'},
        rootPackage: 'a',
        outputs: _outputs({}),
        onLog: (record) => logs.add(record.message),
      );

      expect(logs, contains(contains('FASolid.faDefinitelyNotAnIcon')));
    });

    test('ignores files in the generated directory', () async {
      await testBuilder(
        FontAwesomePro(),
        {
          'a|lib/foo.dart': 'const v = FASolid.faHouse;',
          // A stale generated file must not feed icons back into the build.
          'a|lib/font_awesome/old_solid.dart': 'const v = FABrands.faApple;',
        },
        rootPackage: 'a',
        outputs: _outputs({
          'a|lib/font_awesome/solid.dart': decodedMatches(contains('faHouse')),
          'a|lib/font_awesome/brands.dart':
              decodedMatches(isNot(contains('faApple'))),
        }),
      );
    });
  });
}
