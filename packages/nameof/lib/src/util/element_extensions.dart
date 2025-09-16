import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:source_gen/source_gen.dart';

TypeChecker _typeChecker(final Type type) => TypeChecker.typeNamed(type);

extension AnnotationChecker on Element2 {
  bool hasAnnotation(final Type type) {
    return _typeChecker(type).hasAnnotationOfExact(this);
  }

  DartObject? getAnnotation(final Type type) {
    return _typeChecker(type).firstAnnotationOfExact(this);
  }
}
