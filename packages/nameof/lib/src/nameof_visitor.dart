import 'package:analyzer/dart/element/element2.dart';
import 'package:nameof/src/model/element_info.dart';
import 'package:nameof/src/util/element_extensions.dart';
import 'package:nameof/src/util/string_extensions.dart';
import 'package:nameof_annotation/nameof_annotation.dart';

import 'model/property_info.dart';

/// Class for collect info about inner elements of class (or mixin)
class NameofVisitor extends ElementVisitor2<void> {
  late String className;

  final constructors = <String, ElementInfo>{};
  final fields = <String, ElementInfo>{};
  final functions = <String, ElementInfo>{};
  final properties = <String, PropertyInfo>{};

  NameofVisitor(this.className);

  @override
  void visitConstructorElement(ConstructorElement2 element) {
    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    constructors[element.name3!] = _getElementInfo(element);
  }

  @override
  void visitFieldElement(FieldElement2 element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    fields[element.name3!] = _getElementInfo(element);
  }

  @override
  void visitMethodElement(MethodElement2 element) {
    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    functions[element.name3!] = _getElementInfo(element);
  }

  ElementInfo _getElementInfo(Element2 element) {
    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    final isPrivate = element.name3!.startsWith('_');
    final isAnnotated = element.hasAnnotation(NameofKey);
    final isIgnore = element.hasAnnotation(NameofIgnore);


    String? name = (isAnnotated
            ? element
                    .getAnnotation(NameofKey)
                    ?.getField('name')
                    ?.toStringValue() ??
                element.name3
            : element.name3)!
        .cleanFromServiceSymbols();

    String originalName = element.name3!.cleanFromServiceSymbols();

    return ElementInfo(
        name: name,
        originalName: originalName,
        isPrivate: isPrivate,
        isAnnotated: isAnnotated,
        isIgnore: isIgnore);
  }

  @override
  void visitClassElement(ClassElement2 element) {
  }

  @override
  void visitEnumElement(EnumElement2 element) {
  }

  @override
  void visitExtensionElement(ExtensionElement2 element) {
  }

  @override
  void visitExtensionTypeElement(ExtensionTypeElement2 element) {
  }

  @override
  void visitFieldFormalParameterElement(FieldFormalParameterElement2 element) {
  }

  @override
  void visitGenericFunctionTypeElement(GenericFunctionTypeElement2 element) {
  }

  @override
  void visitGetterElement(GetterElement element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    if (properties.containsKey(element.name3!)) {
      properties[element.name3!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: true, isSetter: properties[element.name3!]!.isSetter);
    } else {
      properties[element.name3!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: true, isSetter: false);
    }
  }

  @override
  void visitLabelElement(LabelElement2 element) {
  }

  @override
  void visitLibraryElement(LibraryElement2 element) {
  }

  @override
  void visitLocalFunctionElement(LocalFunctionElement element) {
    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    functions[element.name3!] = _getElementInfo(element);
  }

  @override
  void visitLocalVariableElement(LocalVariableElement2 element) {
  }

  @override
  void visitMixinElement(MixinElement2 element) {
  }

  @override
  void visitMultiplyDefinedElement(MultiplyDefinedElement2 element) {
  }

  @override
  void visitPrefixElement(PrefixElement2 element) {

  }

  @override
  void visitSetterElement(SetterElement element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name3 == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    if (properties.containsKey(element.name3!)) {
      properties[element.name3!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: properties[element.name3!]!.isGetter, isSetter: true);
    } else {
      properties[element.name3!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: false, isSetter: true);
    }
  }

  @override
  void visitSuperFormalParameterElement(SuperFormalParameterElement2 element) {
  }

  @override
  void visitTopLevelVariableElement(TopLevelVariableElement2 element) {
  }

  @override
  void visitTypeAliasElement(TypeAliasElement2 element) {
  }

  @override
  void visitTypeParameterElement(TypeParameterElement2 element) {
  }

  @override
  void visitFormalParameterElement(FormalParameterElement element) {
  }

  @override
  void visitTopLevelFunctionElement(TopLevelFunctionElement element) {
  }
}
