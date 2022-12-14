import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'config.dart' as config;

// Size(320.0, 528.9)
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFd40072),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});
  static const MethodChannel _channel = MethodChannel('app.channel.shortcut');

  void lineCall(String chatName) {
    _channel.invokeMethod("startShortcut", {
      "packageName": "jp.naver.line.android",
      "id": "FreeCall$chatName" // 通話:FreeCall チャッ:Chat
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
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: ListView(
            children: [
              Row(
                children: [
                  AppBox(
                    icon: const Icon(
                      Icons.phone,
                      size: 120,
                    ),
                    text: '電話/電話帳',
                    width: 150,
                    height: 210,
                    onTap: () => DeviceApps.openApp('com.android.dialer'),
                  ),
                  Column(
                    children: [
                      AppBox(
                        icon: const Icon(
                          Icons.mail,
                          size: 60,
                        ),
                        text: 'メール',
                        width: 150,
                        height: 100,
                        onTap: () =>
                            DeviceApps.openApp('jp.co.nttdocomo.carriermail'),
                      ),
                      AppBox(
                        icon: const Icon(
                          Icons.public,
                          size: 60,
                        ),
                        text: 'インターネット',
                        width: 150,
                        height: 100,
                        onTap: () => DeviceApps.openApp('com.android.browser'),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (config.name1 != null)
                    AppBox(
                        icon: Container(),
                        text: config.name1!, // TODO: アプリない設定で変更できるようにしたい
                        width: 54,
                        height: 54,
                        onTap: () => lineCall(config.name1!)),
                  if (config.name2 != null)
                    AppBox(
                        icon: Container(),
                        text: config.name2!,
                        width: 54,
                        height: 54,
                        onTap: () => lineCall(config.name2!)),
                  if (config.name3 != null)
                    AppBox(
                        icon: Container(),
                        text: config.name3!,
                        width: 54,
                        height: 54,
                        onTap: () => lineCall(config.name3!)),
                  if (config.name4 != null)
                    AppBox(
                        icon: Container(),
                        text: config.name4!,
                        width: 54,
                        height: 54,
                        onTap: () => lineCall(config.name4!)),
                  if (config.name5 != null)
                    AppBox(
                        icon: Container(),
                        text: config.name5!,
                        width: 54,
                        height: 54,
                        onTap: () => lineCall(config.name5!)),
                ],
              ),
              Row(
                children: [
                  AppBox(
                    icon: const Icon(
                      Icons.phone,
                      size: 60,
                    ),
                    text: 'LINE電話',
                    width: 150,
                    height: 100,
                    onTap: () => const AndroidIntent(
                            action: 'action_view',
                            data: 'https://line.me/R/call/contacts')
                        .launch(),
                  ),
                  AppBox(
                      icon: Image.memory(
                        (line.data as ApplicationWithIcon).icon,
                        width: 50,
                      ),
                      text: line.data!.appName,
                      width: 150,
                      height: 100,
                      onTap: () => line.data!.openApp()),
                ],
              ),
              AppBoxRow(
                icon: const Icon(
                  Icons.phone_android,
                  size: 60,
                ),
                text: '自分の電話番号',
                height: 70,
                width: 320,
                onTap: () => const AndroidIntent(
                  action: 'action_view',
                  package: 'com.android.contacts',
                  componentName: 'com.android.contacts.ViewMyPageActivity',
                ).launch(),
              ),
              Row(
                children: [
                  AppBox(
                    icon: const Icon(
                      Icons.settings,
                      size: 60,
                    ),
                    text: '設定',
                    width: 150,
                    height: 100,
                    onTap: () => DeviceApps.openApp('com.android.settings'),
                  ),
                  AppBox(
                    icon: const Icon(
                      Icons.calculate,
                      size: 60,
                    ),
                    text: '電卓',
                    width: 150,
                    height: 100,
                    onTap: () => DeviceApps.openApp('com.android.calculator2'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBox extends HookConsumerWidget {
  final Widget icon;
  final String text;
  final double height;
  final double width;
  final Function()? onTap;
  const AppBox({
    super.key,
    required this.icon,
    required this.text,
    required this.height,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(context, ref) {
    final press = useState(false);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
          onTapDown: (_) => press.value = true,
          onTapCancel: () => press.value = false,
          onTapUp: (_) => press.value = false,
          onTap: Feedback.wrapForTap(onTap, context),
          child: Container(
            decoration: BoxDecoration(
              color: press.value
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(text,
                    style: GoogleFonts.mPlusRounded1c(
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                    )),
              ],
            ),
          )),
    );
  }
}

class AppBoxRow extends HookConsumerWidget {
  final Widget icon;
  final String text;
  final double height;
  final double width;
  final Function()? onTap;
  const AppBoxRow({
    super.key,
    required this.icon,
    required this.text,
    required this.height,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(context, ref) {
    final press = useState(false);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
          onTapDown: (_) => press.value = true,
          onTapCancel: () => press.value = false,
          onTapUp: (_) => press.value = false,
          onTap: Feedback.wrapForTap(onTap, context),
          child: Container(
            decoration: BoxDecoration(
              color: press.value
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            width: width,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(text,
                    style: GoogleFonts.mPlusRounded1c(
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w900),
                    )),
              ],
            ),
          )),
    );
  }
}
