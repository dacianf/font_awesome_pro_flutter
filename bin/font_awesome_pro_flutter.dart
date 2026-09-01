import 'dart:io';

import 'package:font_awesome_pro_flutter/builder.dart';
import 'package:path/path.dart' as p;

const _usage = '''
Generates FontAwesome Pro icon libraries for the package in the current
directory, without going through build_runner.

Usage: dart run font_awesome_pro_flutter [options]

  -C, --directory=<path>   Package root to scan. Defaults to the working
                           directory.
  -h, --help               Show this message.
''';

Future<void> main(List<String> arguments) async {
  var root = Directory.current.path;

  for (var i = 0; i < arguments.length; i++) {
    final argument = arguments[i];
    if (argument == '-h' || argument == '--help') {
      stdout.write(_usage);
      return;
    } else if (argument.startsWith('--directory=')) {
      root = argument.substring('--directory='.length);
    } else if (argument == '-C' || argument == '--directory') {
      if (++i == arguments.length) _fail('Missing value for $argument.');
      root = arguments[i];
    } else {
      _fail('Unrecognised argument: $argument\n\n$_usage');
    }
  }

  final lib = Directory(p.join(root, 'lib'));
  if (!lib.existsSync())
    _fail('No lib/ directory found in ${p.absolute(root)}.');

  final outputDirectory =
      p.join(root, p.fromUri(FontAwesomeStyle.outputDirectory));
  final sources = <String>[];
  await for (final entity in lib.list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    // Skip our own output, so a run is idempotent.
    if (p.isWithin(outputDirectory, entity.path)) continue;
    sources.add(await entity.readAsString());
  }

  final result = generate(sources);
  for (final unknown in result.unknownIcons) {
    stderr.writeln('Warning: unknown FontAwesome icon: $unknown');
  }

  for (final entry in result.libraries.entries) {
    final file = File(p.join(root, p.fromUri(entry.key)));
    await file.parent.create(recursive: true);
    await file.writeAsString(entry.value);
  }

  stdout.writeln(
    'Generated ${result.libraries.length} libraries in '
    '${p.relative(outputDirectory, from: root)}/ '
    'from ${sources.length} source files.',
  );
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(64); // EX_USAGE
}
