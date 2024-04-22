import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_language_selector.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roscodrom Desktop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LanguageSelector(),
      debugShowCheckedModeBanner: false,
    );
  }
}
