import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const MyApp());
}

// Size(320.0, 528.9)
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  @override
  Widget build(context, ref) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
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
                  onTap: () => DeviceApps.openApp('com.android.contacts'),
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
                // AppBox(
                //   icon: const Icon(
                //     Icons.public,
                //     size: 60,
                //   ),
                //   text: 'LINE',
                //   width: 150,
                //   height: 500,
                //   onTap: () => DeviceApps.openApp(''),
                // ),
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
          ],
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
