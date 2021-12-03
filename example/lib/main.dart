import 'package:flutter/material.dart';
import 'package:static_i18n/static_i18n.dart';

class AppTranslations extends Translations {
  @override
  Map<Locale, Map<String, String>> get keys => <Locale, Map<String, String>>{
        const Locale('en', 'us'): enUs,
        const Locale('ka', 'ge'): kaGe,
      };

  Map<String, String> enUs = <String, String>{
    'test': 'test',
  };

  Map<String, String> kaGe = <String, String>{
    'test': 'ტესტი',
  };
}

void main() {
  StaticI18N.initialize(
    tr: AppTranslations(),
    locale: const Locale('ka', 'ge'),
    fallbackLocale: const Locale('ka', 'ge'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'static i18n demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('test translation bellow'),
            Text(
              'test'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => StaticI18N.changeLocale(const Locale('ka', 'ge')),
              child: const Text('geo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => StaticI18N.changeLocale(const Locale('en', 'us')),
              child: const Text('en'),
            ),
          ],
        ),
      ),
    );
  }
}
