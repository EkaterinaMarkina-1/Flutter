import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    MaterialColor primarySwatch = MaterialColor(0xFFEBE0B6, {
      50: Color(0xFFEBE0B6),
      100: Color(0xFFEBE0B6),
      200: Color(0xFFEBE0B6),
      300: Color(0xFFEBE0B6),
      400: Color(0xFFEBE0B6),
      500: Color(0xFFEBE0B6),
      600: Color(0xFFEBE0B6),
      700: Color(0xFFEBE0B6),
      800: Color(0xFFEBE0B6),
      900: Color(0xFFEBE0B6),
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Кофейня',
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Реализация виджета MyHomePage
    return Container();
  }
}
