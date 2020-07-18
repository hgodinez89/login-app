import 'dart:async';
import 'package:flutter/material.dart';

import 'package:login_app/src/internationalization/localizations_util.dart';

class LocalizationsUtilDelegate
    extends LocalizationsDelegate<LocalizationsUtil> {
  const LocalizationsUtilDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<LocalizationsUtil> load(Locale locale) async {
    LocalizationsUtil localizations = new LocalizationsUtil(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsUtilDelegate old) => false;
}
