import 'package:example/src/locale/example_delegate.dart';
import 'package:example/src/locale/example_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oni_locale/oni.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oni Locale Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ExampleDelegate(),
      ],
      home: const MyHomePage(title: 'Localization demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final oniLocale = OniLocale.of<ExampleLocale>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My collections"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(oniLocale.bookCollection),
            Text(oniLocale.chairCollection("1")),
            Text(oniLocale.chairCollection(2)),
            Text(oniLocale.chairCollection(false)),
          ],
        ),
      ),
    );
  }
}
