import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:nameof/src/nameof_code_processor.dart';
import 'package:nameof/src/util/enum_extensions.dart';
import 'package:nameof_annotation/nameof_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'model/options.dart';
import 'nameof_visitor.dart';

class NameofGenerator extends GeneratorForAnnotation<Nameof> {
  final Map<String, dynamic> config;

  NameofGenerator(this.config);

  @override
  String generateForAnnotatedElement(
      Element2 element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind != ElementKind.CLASS && element.kind.name != 'MIXIN') {
      throw UnsupportedError("This is not a class (or mixin)!");
    }

    final options = _parseConfig(annotation);

    final visitor = NameofVisitor(element.name3 ??
        () {
          throw UnsupportedError(
              'Class or mixin element does not have a name!');
        }());
    element.visitChildren2(visitor);

    final code = NameofCodeProcessor(options, visitor).process();

    return code;
  }

  Coverage _parseCoverage(ConstantReader annotation) {
    final coverageConfigString = config['coverage']?.toString();

    bool covTest(Coverage coverage) =>
        coverageConfigString == coverage.toShortString();

    final coverageConfig = Coverage.values.any(covTest)
        ? Coverage.values.firstWhere(covTest)
        : null;

    final coverageAnnotation = enumValueForDartObject(
      annotation.read('coverage'),
      Coverage.values,
    );
    return coverageAnnotation ?? coverageConfig ?? Coverage.includeImplicit;
  }

  NameofScope _parseScope(ConstantReader annotation) {
    final scopeConfigString = config.containsKey('scope') ? config['scope']?.toString() : '';

    bool scopeTest(NameofScope scope) =>
        scopeConfigString == scope.toShortString();

    final scopeConfig = NameofScope.values.any(scopeTest)
        ? NameofScope.values.firstWhere(scopeTest)
        : null;

    final scopeConstantReader = annotation.peek('scope');
    final scopeAnnotation = scopeConstantReader != null ? enumValueForDartObject(
      scopeConstantReader,
      NameofScope.values,
    ) : null;

    return scopeAnnotation ?? scopeConfig ?? NameofScope.onlyPublic;
  }

  NameofOptions _parseConfig(ConstantReader annotation) {

    return NameofOptions(
        coverage: _parseCoverage(annotation),
        scope: _parseScope(annotation));
  }

  T? enumValueForDartObject<T>(
    ConstantReader reader,
    List<T> items,
  ) {
    return reader.isNull
        ? null
        : items[reader.objectValue.getField('index')!.toIntValue()!];
  }
}
