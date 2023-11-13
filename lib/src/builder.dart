import 'package:build/build.dart';
import 'package:const_to_enum_generator/src/generator.dart';
import 'package:source_gen/source_gen.dart';

/// A builder function that provides [ConstToEnumGenerator]
/// to [SharedPartBuilder].
Builder constToEnumBuilder(BuilderOptions options) => PartBuilder(
      [ConstToEnumGenerator()],
      '.static_const.dart',
      header: '// GENERATED CODE - DO NOT MODIFY BY HAND\n',
    );
