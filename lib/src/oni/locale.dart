import 'package:flutter/widgets.dart';

import '../oni/resource.dart';

abstract class OniLocale {
  final String? localeCode;

  abstract final OniResource resource;

  OniLocale(this.localeCode);

  static T of<T extends OniLocale>(BuildContext context) {
    return Localizations.of(context, T);
  }
}
