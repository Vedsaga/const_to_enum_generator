# Test to be implemented
Creating a comprehensive test suite for your `const_to_enum_generator` involves covering a variety of scenarios to ensure robustness. Here's a list of potential test cases, including edge cases, that you should consider:

### Basic Functionality

1. **Valid Class with Static Const Fields**: Test that the generator correctly creates an enum for a class with various static const string fields.

2. **Class with Mixed Field Types**: A class that has static const fields of different types, ensuring the generator only considers string types.

3. **Class with No Static Const Fields**: Ensuring the generator does not produce an enum or produces an appropriate output when no relevant fields are found.

4. **Multiple Classes in One File**: When multiple classes annotated with `GenerateStaticConst` are present in one file, the generator should handle each one correctly.

5. **Default Value Specified**: Test cases where the `defaultValue` is provided and matches one of the static const fields.

6. **Invalid Default Value**: When the `defaultValue` does not match any static const field, ensuring the generator handles this gracefully (e.g., error message).

### Edge Cases

7. **Nested or Inner Classes**: Classes defined within other classes, testing how the generator handles these structures.

8. **Inheritance Scenarios**: Classes that inherit from other classes, especially to see how inherited static const fields are treated.

9. **Abstract Classes**: Abstract classes annotated with `GenerateStaticConst` to see if the generator handles them correctly or ignores them.

10. **Classes with Private Static Const Fields**: Ensure that private fields (those starting with `_`) are ignored by the generator.

11. **Empty Classes**: Classes without any fields to see if the generator correctly handles these cases without generating irrelevant code.

12. **Non-Class Elements**: Testing the generator's behavior when the annotated element is not a class (e.g., a function or a variable).

### Error Handling

13. **Syntax Errors in Class Definition**: Introduce syntax errors in class definitions to ensure the generator does not crash and handles errors gracefully.

14. **Incorrect Annotations Usage**: Applying the `GenerateStaticConst` annotation incorrectly (e.g., on methods or fields) and ensuring the generator handles these cases appropriately.

15. **Conflicting Field Names**: Cases where field names might conflict with existing enum member names or Dart reserved keywords.

### Integration with Build System

16. **Integration with Build Runner**: Tests that involve the entire build process, ensuring that the generator integrates well with the Dart build system and `build_runner`.

17. **Incremental Builds**: How the generator behaves in incremental builds, especially when changes are made to the annotated classes.

### Writing Tests for Each Case

For each of these test cases:

- Set up the necessary mock objects (e.g., `ClassElement`, `FieldElement`).
- Configure the mock objects to mimic the scenario you are testing.
- Call your generator with these mocks and check the output against expected results.
- Ensure to handle exceptions and error cases, asserting that the right errors are thrown or the correct error messages are produced.

By systematically covering these scenarios, your test suite will help ensure that `const_to_enum_generator` behaves correctly across a wide range of situations, increasing confidence in its reliability and robustness.

# Const To Enum Generator

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Very Good Project created by Very Good CLI.

## Installation 💻

**❗ In order to start using Const To Enum Generator you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add const_to_enum_generator
```

---

## Continuous Integration 🤖

Const To Enum Generator comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
