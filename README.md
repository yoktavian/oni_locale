# oni_locale

Flutter library to support internationalization

## Getting Started

First thing first you have to add flutter localizations into your project, by adding `flutter_localizations` into your `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Add this line
  flutter_localizations:
    sdk: flutter
```
Then you have to add oni_locale also into your project.
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  # Add this line
  oni_locale: ^1.0.0
```
Once you done, you have to sync the project by running `flutter pub get` command in the terminal or just using the ui right away and make sure the process is success.

When sync process has been done, the library should be ready to use.

So how to use this library? simply you could try to run this command

`flutter pub run oni_locale:generator.dart --module-name <name>`


And viola! all of your required files would be automatically generated. Magic? yes for you, but not really for me because i spent a lot of my times to working on this generation things to make your life easier :D.

Your file would be generated under `src/locale` package. So, what the next step? you have to registering your localization delegate into your main app. You could check the example on the `app.dart` file.

```dart
return MaterialApp(
  title: 'Oni Locale Demo',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  <!-- you need to provide all of supported language code here -->
  supportedLocales: const [
    Locale('id'),
    Locale('en'),
  ],
  localizationsDelegates: [
    <!-- this is a must, need to registering material and cupertiono delegates, otherwise you will got an error -->
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    <!-- then registering your delegates from the generation result -->
    ExampleDelegate(),
  ],
  home: const MyHomePage(title: 'Localization demo'),
);
```
All of the setup should be done now. So how to generate or create new string resources? you could jump in right away to the `template.arb` file. If this is the first time you working on it, the example should be already generated. The template should be something like this
```arb
{
  "@@last_modified": "2024-02-03T14:38:37.913408",
  "bookCollection": {
    "id": "buku",
    "en": "book"
  },
  "chairCollection": {
    "id": "kursi %s",
    "en": "chair %s"
  }
}
```
in this example, `bookCollection` is just a simple single string. but if `chairCollection` that is support concatenation string. and in this example we just support only `id` and `en`, but you could add more as you like.

If you already add or edit the template, you could regenerate your locale again by run the same command as before

`flutter pub run oni_locale:generator.dart --module-name <name>`

And your locale resources would be updated. All of registered string should be appear in your local resources now.

So how to use this resources in the widget?
```dart
Widget build(BuildContext context) {
  <!-- Get the locale here. -->
  final oniLocale = OniLocale.of<ExampleLocale>(context);

  return Scaffold(
    appBar: AppBar(
      title: const Text("My collections"),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          <!-- Use the value from locale here. -->
          Text(oniLocale.bookCollection),
          <!-- The parameters will be dynamic, so you could put anything on the parameter because it will converted as a string at the end. -->
          Text(oniLocale.chairCollection("1")),
          Text(oniLocale.chairCollection(2)),
          Text(oniLocale.chairCollection(false)),
        ],
      ),
    ),
  );
}
```

So that's all for now. You could use this library to support localization or just to organized your string resources in elegant way for sure :).

NOTES: If you already registering some supported languages, but when user using unsupported language, by default it will using the first order language in the template. For example in my template, the first order is `id` so for the user who using unsuported language on their device will get `id` language as their default langauge.


DEMO:

https://github.com/yoktavian/oni_locale/assets/23457234/763bfdea-a9a0-44e8-ae93-a1dbe36536e1
