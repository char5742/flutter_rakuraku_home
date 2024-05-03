import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rakuraku_home/pages/app_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config.dart' as config;

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});
  static const MethodChannel _channel = MethodChannel('app.channel.shortcut');

  void lineCall(String chatName) {
    _channel.invokeMethod("startShortcut", {
      "packageName": "jp.naver.line.android",
      "id": "FreeCall$chatName" // 通話:FreeCall チャット:Chat
    });
  }

  void lineChat(String chatName) {
    _channel.invokeMethod("startShortcut", {
      "packageName": "jp.naver.line.android",
      "id": "Chat$chatName" // 通話:FreeCall チャット:Chat
    });
  }

  @override
  Widget build(context, ref) {
    final memo =
        useMemoized(() => DeviceApps.getApp('jp.naver.line.android', true));
    final line = useFuture(memo);
    if (line.connectionState == ConnectionState.waiting) {
      return Container();
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: PopScope(
        onPopInvoked: (_) => false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: ListView(
            children: [
              _buildPhoneAndMailRow(),
              _buildLineCallRow(),
              _buildLinePhoneAndAppRow(line.data as ApplicationWithIcon),
              _buildMyPhoneNumberBox(),
              _buildSettingsAndCalculatorRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneAndMailRow() {
    return Row(
      children: [
        AppBox(
          icon: const Icon(Icons.phone, size: 120),
          text: '電話/電話帳',
          width: 150,
          height: 210,
          onTap: () => DeviceApps.openApp('com.android.dialer'),
        ),
        Column(
          children: [
            AppBox(
              icon: const Icon(Icons.mail, size: 60),
              text: 'メール',
              width: 150,
              height: 100,
              onTap: () => DeviceApps.openApp('jp.co.nttdocomo.carriermail'),
            ),
            AppBox(
              icon: const Icon(Icons.public, size: 60),
              text: 'インターネット',
              width: 150,
              height: 100,
              onTap: () => DeviceApps.openApp('com.android.browser'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineCallRow() {
    return Row(
      children: [
        if (config.name1 != null) _buildLineCallBox(config.name1!),
        if (config.name2 != null) _buildLineCallBox(config.name2!),
        if (config.name3 != null) _buildLineCallBox(config.name3!),
        if (config.name4 != null) _buildLineCallBox(config.name4!),
        if (config.name5 != null) _buildLineCallBox(config.name5!),
      ],
    );
  }

  Widget _buildLineCallBox(String name) {
    return AppBox(
      icon: Container(),
      text: name,
      width: 54,
      height: 54,
      onTap: () => lineCall(name),
    );
  }

  Widget _buildLineChatRow() {
    return Row(
      children: [
        if (config.name1 != null) _buildLineChatBox(config.name1!),
        if (config.name2 != null) _buildLineChatBox(config.name2!),
        if (config.name3 != null) _buildLineChatBox(config.name3!),
        if (config.name4 != null) _buildLineChatBox(config.name4!),
        if (config.name5 != null) _buildLineChatBox(config.name5!),
      ],
    );
  }

  Widget _buildLineChatBox(String name) {
    return AppBox(
      icon: Container(),
      text: name,
      width: 54,
      height: 54,
      onTap: () => lineChat(name),
    );
  }

  Widget _buildLinePhoneAndAppRow(ApplicationWithIcon lineApp) {
    return Row(
      children: [
        AppBox(
          icon: const Icon(Icons.phone, size: 60),
          text: 'LINE電話',
          width: 150,
          height: 100,
          onTap: () => const AndroidIntent(
            action: 'action_view',
            data: 'https://line.me/R/call/contacts',
          ).launch(),
        ),
        AppBox(
          icon: Image.memory(lineApp.icon, width: 50),
          text: lineApp.appName,
          width: 150,
          height: 100,
          onTap: () => lineApp.openApp(),
        ),
      ],
    );
  }

  Widget _buildMyPhoneNumberBox() {
    return AppBox(
      isRow: true,
      icon: const Icon(Icons.phone_android, size: 60),
      text: '自分の電話番号',
      height: 70,
      width: 320,
      onTap: () => const AndroidIntent(
        action: 'action_view',
        package: 'com.android.contacts',
        componentName: 'com.android.contacts.ViewMyPageActivity',
      ).launch(),
    );
  }

  Widget _buildSettingsAndCalculatorRow() {
    return Row(
      children: [
        AppBox(
          icon: const Icon(Icons.settings, size: 60),
          text: '設定',
          width: 150,
          height: 100,
          onTap: () => DeviceApps.openApp('com.android.settings'),
        ),
        AppBox(
          icon: const Icon(Icons.calculate, size: 60),
          text: '電卓',
          width: 150,
          height: 100,
          onTap: () => DeviceApps.openApp('com.android.calculator2'),
        ),
      ],
    );
  }
}
