import 'package:flutter/material.dart';
import 'package:flutter_rakuraku_home/pages/home_page.dart';

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
