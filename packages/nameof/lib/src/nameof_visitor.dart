import 'package:analyzer/dart/element/element.dart';
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
  void visitConstructorElement(ConstructorElement element) {
    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    constructors[element.name!] = _getElementInfo(element);
  }

  @override
  void visitFieldElement(FieldElement element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    fields[element.name!] = _getElementInfo(element);
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    functions[element.name!] = _getElementInfo(element);
  }

  ElementInfo _getElementInfo(Element element) {
    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    final isPrivate = element.name!.startsWith('_');
    final isAnnotated = element.hasAnnotation(NameofKey);
    final isIgnore = element.hasAnnotation(NameofIgnore);
    print(' ${element.name} : $isAnnotated');


    String? name = (isAnnotated
            ? element
                    .getAnnotation(NameofKey)
                    ?.getField('name')
                    ?.toStringValue() ??
                element.name
            : element.name)!
        .cleanFromServiceSymbols();
    print('name : $name');

    String originalName = element.name!.cleanFromServiceSymbols();
    print('originalName : $originalName');

    return ElementInfo(
        name: name,
        originalName: originalName,
        isPrivate: isPrivate,
        isAnnotated: isAnnotated,
        isIgnore: isIgnore);
  }

  @override
  void visitClassElement(ClassElement element) {
  }

  @override
  void visitEnumElement(EnumElement element) {
  }

  @override
  void visitExtensionElement(ExtensionElement element) {
  }

  @override
  void visitExtensionTypeElement(ExtensionTypeElement element) {
  }

  @override
  void visitFieldFormalParameterElement(FieldFormalParameterElement element) {
  }

  @override
  void visitFormalParameterElement(FormalParameterElement element) {
  }

  @override
  void visitGenericFunctionTypeElement(GenericFunctionTypeElement element) {
  }

  @override
  void visitGetterElement(GetterElement element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    if (properties.containsKey(element.name!)) {
      properties[element.name!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: true, isSetter: properties[element.name!]!.isSetter);
    } else {
      properties[element.name!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: true, isSetter: false);
    }
  }

  @override
  void visitLabelElement(LabelElement element) {
  }

  @override
  void visitLibraryElement(LibraryElement element) {
  }

  @override
  void visitLocalFunctionElement(LocalFunctionElement element) {
    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    functions[element.name!] = _getElementInfo(element);
  }

  @override
  void visitLocalVariableElement(LocalVariableElement element) {
  }

  @override
  void visitMixinElement(MixinElement element) {
  }

  @override
  void visitMultiplyDefinedElement(MultiplyDefinedElement element) {
  }

  @override
  void visitPrefixElement(PrefixElement element) {

  }

  @override
  void visitSetterElement(SetterElement element) {
    if (element.isSynthetic) {
      return;
    }

    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    if (properties.containsKey(element.name!)) {
      properties[element.name!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: properties[element.name!]!.isGetter, isSetter: true);
    } else {
      properties[element.name!] = PropertyInfo.fromElementInfo(
          _getElementInfo(element),
          isGetter: false, isSetter: true);
    }
  }

  @override
  void visitSuperFormalParameterElement(SuperFormalParameterElement element) {
  }

  @override
  void visitTopLevelFunctionElement(TopLevelFunctionElement element) {
  }

  @override
  void visitTopLevelVariableElement(TopLevelVariableElement element) {
  }

  @override
  void visitTypeAliasElement(TypeAliasElement element) {
  }

  @override
  void visitTypeParameterElement(TypeParameterElement element) {
  }
}
