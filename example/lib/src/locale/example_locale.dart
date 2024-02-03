// DON'T EDIT THE CODE.
// This code generated by lib localization.

import 'package:example/src/locale/example_resource.dart';
import 'package:oni_locale/main.dart';

class ExampleLocale extends OniLocale {
  ExampleLocale([String? languageCode]) : super(languageCode);

  String get bookCollection {
    return resource.get('bookCollection');
  }

  @override
  OniResource get resource {
    return ExampleLocaleResource(localeCode);
  }
}