import 'package:flutter/widgets.dart';

import '../oni/resource.dart';

abstract class OniLocale {
  final String? languageCode;

  abstract final OniResource resource;

  OniLocale(this.languageCode);

  static T of<T extends OniLocale>(BuildContext context) {
    return Localizations.of(context, T);
  }
}
