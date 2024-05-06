import 'package:flutter/material.dart';
import 'layout_language_selector.dart';
import 'layout_spectate.dart';
import 'app_data.dart';

class LayoutMainMenu extends StatelessWidget {
  LayoutMainMenu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Menu'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LayoutSpectate()));
                },
                child: Text('Spectate a game'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LanguageSelector()));
                },
                child: Text('Visualize words'),
              ),
            ])));
  }
}
