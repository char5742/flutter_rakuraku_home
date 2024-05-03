import 'package:flutter/services.dart';

/// [packageName]のアプリのショートカットを検索する
Future<dynamic> searchAppShortcuts(String packageName) async {
  const channel = MethodChannel('app.channel.shortcut');

  return channel.invokeMethod("listShortcutsForPackage", {
    "packageName": packageName,
  });
}
