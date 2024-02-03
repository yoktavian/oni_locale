import 'package:flutter/widgets.dart';

import '../oni/resource.dart';

abstract class OniLocale {
  final String? localeCode;
  final String defaultCode;

  abstract final OniResource resource;

  OniLocale(this.localeCode, this.defaultCode);

  static T of<T extends OniLocale>(BuildContext context) {
    return Localizations.of(context, T);
  }
}
