import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'translations.dart';

class StaticI18N {
  static Locale? locale;

  static Locale? fallbackLocale;

  static final Map<String, Map<String, String>> translations = <String, Map<String, String>>{};

  static void initialize({
    required Translations tr,
    required Locale locale,
    Locale? fallbackLocale,
  }) {
    StaticI18N.locale = locale;
    StaticI18N.fallbackLocale = fallbackLocale;

    final Map<String, Map<String, String>> mapped =
        tr.keys.map((Locale locale, Map<String, String> value) {
      final String key = '${locale.languageCode}_${locale.countryCode}';

      return MapEntry<String, Map<String, String>>(key, value);
    });

    translations.addAll(mapped);
  }

  static Future<void> changeLocale(Locale locale) async {
    StaticI18N.locale = locale;

    await WidgetsBinding.instance?.performReassemble();
  }
}
