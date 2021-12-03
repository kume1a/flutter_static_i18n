import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'static_i18n.dart';

extension StaticI18NX on String {
  // Checks whether the language code and country code are present, and
  // whether the key is also present.
  bool get _fullLocaleAndKey {
    final String key = '${StaticI18N.locale!.languageCode}_${StaticI18N.locale!.countryCode}';

    return StaticI18N.translations.containsKey(key) &&
        StaticI18N.translations[key]!.containsKey(this);
  }

  // Checks if there is a callback language in the absence of the specific
  // country, and if it contains that key.
  Map<String, String>? get _getSimilarLanguageTranslation {
    final Map<String, Map<String, String>> translationsWithNoCountry = StaticI18N.translations.map(
      (String key, Map<String, String> value) =>
          MapEntry<String, Map<String, String>>(key.split('_').first, value),
    );

    final bool containsKey = translationsWithNoCountry.containsKey(StaticI18N.locale!.languageCode);
    if (!containsKey) {
      return null;
    }

    return translationsWithNoCountry[StaticI18N.locale!.languageCode];
  }

  String get tr {
    // Returns the key if locale is null.
    if (StaticI18N.locale?.languageCode == null) return this;

    final String translationsKey =
        '${StaticI18N.locale!.languageCode}_${StaticI18N.locale!.countryCode}';

    if (_fullLocaleAndKey) {
      return StaticI18N.translations[translationsKey]![this]!;
    }
    final Map<String, String>? similarTranslation = _getSimilarLanguageTranslation;
    if (similarTranslation != null && similarTranslation.containsKey(this)) {
      return similarTranslation[this]!;
      // If there is no corresponding language or corresponding key, return
      // the key.
    } else if (StaticI18N.fallbackLocale != null) {
      final Locale fallback = StaticI18N.fallbackLocale!;
      final String key = '${fallback.languageCode}_${fallback.countryCode}';

      if (StaticI18N.translations.containsKey(key) &&
          StaticI18N.translations[key]!.containsKey(this)) {
        return StaticI18N.translations[key]![this]!;
      }
      if (StaticI18N.translations.containsKey(fallback.languageCode) &&
          StaticI18N.translations[fallback.languageCode]!.containsKey(this)) {
        return StaticI18N.translations[fallback.languageCode]![this]!;
      }
      return this;
    } else {
      return this;
    }
  }

  String trArgs([
    List<String> args = const <String>[],
  ]) {
    String key = tr;
    if (args.isNotEmpty) {
      for (final String arg in args) {
        key = key.replaceFirst(RegExp('%s'), arg);
      }
    }
    return key;
  }

  String trPlural([
    String? pluralKey,
    int? i,
    List<String> args = const <String>[],
  ]) =>
      i == 1 ? trArgs(args) : pluralKey!.trArgs(args);

  String trParams([Map<String, String> params = const <String, String>{}]) {
    String trans = tr;
    if (params.isNotEmpty) {
      params.forEach((String key, String value) {
        trans = trans.replaceAll('@$key', value);
      });
    }
    return trans;
  }

  String trPluralParams([
    String? pluralKey,
    int? i,
    Map<String, String> params = const <String, String>{},
  ]) =>
      i == 1 ? trParams(params) : pluralKey!.trParams(params);
}
