abstract class OniResource {
  final String? localeCode;

  abstract final Map<String, Map<String, String>> resources;

  OniResource(this.localeCode);

  String get(String key, {List<dynamic> args = const []}) {
    final resourceValue = resources[key];
    // If the locale code not registered, will use first map as a default value.
    String? localizedValue = resourceValue?[localeCode] ?? resourceValue?[0];
    if (localizedValue == null) {
      throw Exception(
        'ERROR: Failed to provide $key value from resources. Have you registering the $key already?',
      );
    }
    // localizedValue should safe using assertion! since the null value already
    // handled in the previous line.
    if (args.isNotEmpty) {
      for (var e in args) {
        localizedValue = localizedValue!.replaceFirst('%s', e);
      }
    }

    return localizedValue!;
  }
}
