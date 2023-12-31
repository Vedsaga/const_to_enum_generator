import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:const_to_enum_annotations/const_to_enum_annotations.dart';
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
        element: element,
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

    // Generate enum values and prepare a map for switch cases
    final overriddenValues = <String, String>{};
    for (final field in fields) {
      // Check for overridden value or use the field's default value
      final stringValueAnnotation = _getStringValueAnnotation(field);
      final variableValue = field.computeConstantValue()?.toStringValue();
      final enumValue =
          stringValueAnnotation ?? variableValue ?? defaultValue ?? '';

      overriddenValues[field.name] = enumValue;
      buffer
        ..write("${field.name}('$enumValue')")
        ..writeln(fields.last == field ? ';' : ',');
    }
    // Constructor and path variable
    buffer
      ..writeln('  const $enumName(this.stringValue);')
      ..writeln('  final String stringValue;')
      ..writeln('  static $enumName? fromStringValue(String stringValue) {')
      ..writeln('    switch (stringValue) {');

    for (final entry in overriddenValues.entries) {
      buffer
        ..writeln("      case '${entry.value}':")
        ..writeln('        return $enumName.${entry.key};');
    }

    buffer
      ..writeln('      default:')
      ..writeln('        return null;')
      ..writeln('    }')
      ..writeln('  }')
      ..writeln('}');

    return buffer.toString();
  }

  String? _getStringValueAnnotation(FieldElement field) {
    final annotations = field.metadata;
    for (final annotation in annotations) {
      final constantValue = annotation.computeConstantValue();
      if (constantValue != null &&
          constantValue.type?.element?.name == 'StringValue') {
        return constantValue.getField('value')?.toStringValue();
      }
    }
    return null;
  }
}
