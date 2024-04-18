import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'layout_connection.dart'; // Import the connection screen

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roscodrom Desktop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
