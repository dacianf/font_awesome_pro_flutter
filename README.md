# font_awesome_pro_flutter

Builds FontAwesome Pro icons in your flutter project. No repo cloning is needed!

## Setup

Add `font_awesome_pro_flutter: <latest version>` to your `dev_dependencies`. 
It is a builder, so you'll need to set up `build_runner`. Read more [here](https://pub.dev/packages/build_runner).

Then you need to install the fonts you'd like:

```yaml
# pubspec.yaml
  fonts:
    - family: FontAwesomeRegular
      fonts:
        - asset: fonts/fa-regular-400.ttf
    - family: FontAwesomeSolid
      fonts:
        - asset: fonts/fa-solid-900.ttf
    - family: FontAwesomeLight
      fonts:
        - asset: fonts/fa-light-300.ttf
    - family: FontAwesomeThin
      fonts:
        - asset: fonts/fa-thin-100.ttf
    - family: FontAwesomeBrands
      fonts:
        - asset: fonts/fa-brands-400.ttf
    - family: FontAwesomeDuotone
      fonts:
        - asset: fonts/fa-duotone-900.ttf
    - family: FontAwesomeSharpSolid
      fonts:
        - asset: fonts/fa-sharp-solid-900.ttf
    - family: FontAwesomeSharpRegular
      fonts:
        - asset: fonts/fa-sharp-regular-400.ttf
```

These can be downloaded at [FontAwesome](https://fontawesome.com/download).

The currently supported version is `6.1.1`.

## Usage

The library will only generate the icons when used. E.g., if you write

```dart
const IconData icon =  FASolid.faX;
```

the library will generate `faX` for the solid style.

The supported styles are `FASolid`, `FARegular`, `FALight`, `FAThin`,
`FABrands`, `FADuotone`, `FASharpSolid` and `FASharpRegular`.

## Without build_runner

The generator also ships as a standalone command, for when you don't want to
run `build_runner` at all -- or when some other package in your dependency
graph is temporarily unresolvable:

```sh
dart run font_awesome_pro_flutter
```

It scans the same files and writes the same output, byte for byte. Run it from
your package root, or point it elsewhere with `-C <path>`.

## Dependency policy

This package used to depend directly on `analyzer`, and that made it a
recurring blocker: `analyzer` ships a breaking major several times a year, and
a direct constraint here had to intersect with the one in every other
generator you use. In practice that meant `font_awesome_pro_flutter` pinned to
`analyzer ^9.0.0` could not resolve alongside `riverpod_generator` (`^13.0.0`),
`freezed` (`>=13.0.0 <15.0.0`) or `json_serializable` (`>=10.0.0 <15.0.0`) at
all -- version solving simply failed.

It no longer depends on `analyzer`, `dart_style` or `code_builder`. Finding
`FASolid.faX` in your source only ever needed the *spelling* of an identifier,
so it is a text scan; the output is emitted as text, already formatted the way
`dart format` leaves it. `analyzer` now arrives only transitively through
`build`, which means it floats to whatever version the rest of your generators
agreed on instead of constraining them.

What is left is `build`, `glob`, `path` and `recase` -- all pure Dart, all
free of `analyzer`, all constrained by whole-major ranges rather than carets.

**If you are adding a dependency here, check first whether it pulls in
`analyzer`** (`dart pub deps` will tell you). If it does, that dependency will
be felt by every consumer of this package on every one of their builds, and
this problem comes straight back.
