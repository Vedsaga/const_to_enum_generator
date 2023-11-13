import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:const_to_enum_generator/src/annotations.dart';
import 'package:source_gen/source_gen.dart';

/// A [Generator] for creating enum from static const strings in a class.
/// It looks for classes annotated with [GenerateStaticConst].
// In generator.dart
class ConstToEnumGenerator extends GeneratorForAnnotation<GenerateStaticConst> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@generateStaticConst` can only be used on classes.',
      );
    }

    final classElement = element;
    final fields = classElement.fields
        .where((f) => f.isStatic && f.isConst && f.type.isDartCoreString);
    // Generate fromStringValue function
    final defaultValue = annotation.peek('defaultValue')?.stringValue;

    // Check if defaultValue matches any of the static const string values
    final hasValidDefaultValue = fields
        .any((f) => f.computeConstantValue()?.toStringValue() == defaultValue);

    String? defaultValueFieldName;
    if (hasValidDefaultValue) {
      for (final field in fields) {
        if (field.computeConstantValue()?.toStringValue() == defaultValue) {
          defaultValueFieldName = field.name;
          break; // Stop the loop once the matching field is found
        }
      }
    }

    if (defaultValueFieldName == null && defaultValue != null) {
      throw InvalidGenerationSourceError(
        '''No valid default value specified. Please specify a valid default value for the enum conversion function.''',
        element: element,
      );
    }

    final enumName = '${classElement.name}Enum';
    final buffer = StringBuffer()
      ..writeln(
        '/// Enum generated from [${classElement.name}] static const strings.',
      )
      ..writeln('enum $enumName {');

    // Generate enum values
    for (var i = 0; i < fields.length; i++) {
      final field = fields.elementAt(i);
      buffer
        ..write(
          "${field.name}('${field.computeConstantValue()!.toStringValue()}')",
        )
        ..writeln(i == fields.length - 1 ? ';' : ',');
    }

    // Constructor and path variable
    buffer
      ..writeln('  const $enumName(this.stringValue);')
      ..writeln('  final String stringValue;');

    if (hasValidDefaultValue) {
      buffer
        ..writeln('  static $enumName fromStringValue(String stringValue) {')
        ..writeln('    switch (stringValue) {');
      for (final field in fields) {
        buffer.writeln(
          """      case '${field.computeConstantValue()!.toStringValue()}': return $enumName.${field.name};""",
        );
      }
      buffer
        ..writeln('      default: return $enumName.$defaultValueFieldName;')
        ..writeln('    }')
        ..writeln('  }');
    }

    if (defaultValue == null) {
      buffer
        ..writeln('  static $enumName? fromStringValue(String stringValue) {')
        ..writeln('    switch (stringValue) {');
      for (final field in fields) {
        buffer.writeln(
          """      case '${field.computeConstantValue()!.toStringValue()}': return $enumName.${field.name};""",
        );
      }
      buffer
        ..writeln('      default: return null;')
        ..writeln('    }')
        ..writeln('  }');
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
