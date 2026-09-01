# 0.1.0

## Dependency resolution

- **Removed the direct `analyzer` dependency.** The `analyzer ^9.0.0`
  constraint made this package unresolvable alongside current
  `riverpod_generator`, `freezed` and `json_serializable`, all of which now
  require `analyzer` 13 or newer. Icon references are found with a source scan
  instead of an AST walk, so `analyzer` is now only a transitive dependency of
  `build` and floats with the rest of your toolchain.
- Removed the `dart_style`, `code_builder` and `built_collection`
  dependencies. Generated code is emitted directly, already formatted the way
  `dart format` leaves it.
- Widened remaining constraints to whole-major ranges. Direct dependencies are
  now just `build`, `glob`, `path` and `recase`.
- Verified resolving and building alongside `build_runner` 2.16.0,
  `riverpod_generator` 4.0.8, `freezed` 4.0.1 and `json_serializable` 6.14.1.

## Fixes

- **Sharp styles now generate icons.** `FASharpSolid` and `FASharpRegular`
  references were matched under the style ids `sharpsolid`/`sharpregular` but
  grouped under `sharp-solid`/`sharp-regular`, so the two classes were always
  emitted empty.
- Generated files are no longer written without awaiting, which could drop
  output on a build that finished early.
- An unrecognised icon name now logs a warning instead of throwing a bare
  `Error` that failed the whole build.
- Generated output no longer depends on file scan order: icons are sorted by
  name, so rebuilds produce no spurious diffs.
- Output paths are built with `/` rather than the platform separator, which
  produced invalid asset ids on Windows.

## Added

- A standalone `dart run font_awesome_pro_flutter` command that produces
  byte-identical output without `build_runner`.
- Generated libraries carry a "GENERATED CODE" header and `ignore_for_file`
  directives.

# 0.0.3

- Only generate icons when used
- Rename font class

# 0.0.2

- Downgrade `path` dependency.

# 0.0.1

- Add initial implementation
