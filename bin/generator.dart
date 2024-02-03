// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) async {
  final parser = ArgParser();
  const jsonDecoder = JsonCodec();
  var moduleName = '';
  var fileName = '';

  if (args.isEmpty) {
    print('Locale: Error, please provide argument --module-name <your_module>');
    exit(0);
  }

  parser.addOption(
    'module-name',
    defaultsTo: '',
    callback: (value) {
      moduleName = value ?? '';
    },
  );

  parser.parse(args);

  fileName = moduleName;

  if (fileName.isEmpty || moduleName.isEmpty) {
    print('Locale: Error, please provide module name');
    exit(0);
  }

  final file = File('lib/src/locale/${fileName}_template.arb');
  final isArbFileExist = await file.exists();

  if (!isArbFileExist) {
    _createArbFileTemplate(file);
  }

  final source = file.readAsStringSync();
  final Map<String, dynamic> data = jsonDecoder.decode(source);
  _updateLastGeneratedLocale(data, file);
  _generateLocaleClassTemplate(data, moduleName, fileName);
  _generateLocaleDelegateClassTemplate(moduleName, fileName);
  _generateLocaleResourceTemplate(data, fileName);
  print('Locale: success to generate locale');

  exit(0);
}

void _createArbFileTemplate(File file) {
  final dateTime = DateTime.now().toIso8601String();
  String template = '''
{
  "@@last_modified": "$dateTime",
  "bookCollection": {
    "id": "buku",
    "en": "book"
  },
  "chairCollection": {
    "id": "kursi %s",
    "en": "chair %s"
  }
}
''';
  final output = StringBuffer();
  output.write(template);
  file.createSync(recursive: true);
  file.writeAsStringSync('$output');
}

void _updateLastGeneratedLocale(Map<String, dynamic> data, File file) {
  data['@@last_modified'] = DateTime.now().toIso8601String();
  const encoder = JsonEncoder.withIndent("  ");
  file.writeAsStringSync(encoder.convert(data));
}

String _provideStringGetterTemplate(Map<String, dynamic> data) {
  var stringGetterTemplate = '\n';
  data.forEach(
        (parentKey, parentValue) {
      if (parentValue is Map<String, dynamic>) {
        var totalArgs = 0;
        var dynamicStringValue = '';
        var argsValue = '';
        final splitValue = parentValue.values.elementAt(0).split(' ');

        for (var value in splitValue) {
          if (value.contains('%s')) totalArgs++;
        }

        for (int i = 0; i < totalArgs; i++) {
          dynamicStringValue += 'dynamic s$i';
          argsValue += 's$i';
          if (i < totalArgs - 1) {
            dynamicStringValue += ', ';
            argsValue += ', ';
          }
        }

        if (dynamicStringValue.isNotEmpty && argsValue.isNotEmpty) {
          stringGetterTemplate += '''
  String $parentKey($dynamicStringValue) {
    return resource.get('$parentKey', args: [$argsValue]);
  }
  ''';
        } else {
          stringGetterTemplate += '''
  String get $parentKey {
    return resource.get('$parentKey');
  }
  ''';
        }
        stringGetterTemplate += '\n';
      }
    },
  );

  return stringGetterTemplate;
}

/// Escape dart strings: ',",$,\
String escape(String string) {
  if (string.isEmpty) {
    return string;
  }
  return string
      .replaceAll('\\', '\\\\') // this must be the first
      .replaceAll("\$", "\\\$")
      .replaceAll("'", "\\'");
}

String _provideResourceLocaleTemplate(Map<String, dynamic> data) {
  var template = '';
  data.forEach(
        (parentKey, parentValue) {
      if (!parentKey.contains('@@')) {
        if (parentValue is Map<String, dynamic>) {
          template += '\n';
          template += '    ';
          template += '\'$parentKey\': {';
          template += '\n';
          parentValue.forEach(
                (childKey, childValue) {
              String value = childValue as String;
              template += '      ';
              template += '\'$childKey\': \'${escape(value)}\',';
              template += '\n';
            },
          );
          template += '    ';
          template += '''},''';
        }
      }
    },
  );
  template += '\n';
  template += '  ';

  return template;
}

void _generateLocaleClassTemplate(
    Map<String, dynamic> data,
    String moduleName,
    String fileName,
    ) {
  String template = '''
// DON'T EDIT THE CODE.
// This code generated by oni locale library.

import 'package:oni_locale/oni.dart';
import 'package:$moduleName/src/locale/${fileName}_resource.dart';

class ${_camelCase(fileName)}Locale extends OniLocale {
  ${_camelCase(fileName)}Locale([String? languageCode]) : super(languageCode);
  ${_provideStringGetterTemplate(data)}  @override
  OniResource get resource {
    return ${_camelCase(fileName)}Resource(languageCode);
  }
}
''';

  final output = StringBuffer();
  final outputFile = File('lib/src/locale/${fileName}_locale.dart');
  output.write(template);
  outputFile.writeAsStringSync('$output');
  output.clear();
}

void _generateLocaleDelegateClassTemplate(
    String moduleName,
    String fileName,
    ) {
  String template = '''
// DON'T EDIT THE CODE.
// This code generated by oni locale library.

import 'package:flutter/widgets.dart';
import 'package:$moduleName/src/locale/${fileName}_locale.dart';

class ${_camelCase(fileName)}Delegate extends LocalizationsDelegate<${_camelCase(fileName)}Locale> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<${_camelCase(fileName)}Locale> load(Locale locale) async {
    return ${_camelCase(fileName)}Locale(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<${_camelCase(fileName)}Locale> old) => false;
}
''';

  final output = StringBuffer();
  final outputFile = File(
    'lib/src/locale/${fileName}_delegate.dart',
  );
  output.write(template);
  outputFile.writeAsStringSync('$output');
  output.clear();
}

void _generateLocaleResourceTemplate(
    Map<String, dynamic> data,
    String fileName,
    ) {
  String template = '''
// DON'T EDIT THE CODE.
// This code generated by oni locale library.

import 'package:oni_locale/oni.dart';

class ${_camelCase(fileName)}Resource extends OniResource {
  ${_camelCase(fileName)}Resource(String? languageCode) : super(languageCode);
  
  @override
  Map<String, Map<String, String>> get resources => {${_provideResourceLocaleTemplate(data)}};
}
''';

  final output = StringBuffer();
  final outputFile = File(
    'lib/src/locale/${fileName}_resource.dart',
  );
  output.write(template);
  outputFile.writeAsStringSync('$output');
  output.clear();
}

String _camelCase(String name) {
  if (name.isEmpty) return '';
  final names = name.split('_');
  var camelName = '';
  for (String text in names) {
    camelName += text[0].toUpperCase() + text.substring(1);
  }
  return camelName;
}

