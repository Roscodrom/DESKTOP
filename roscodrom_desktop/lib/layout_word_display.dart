import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'words.dart';
import 'requests.dart';

class WordDisplay extends StatefulWidget {
  const WordDisplay({super.key});

  @override
  WordDisplayState createState() => WordDisplayState();
}

class WordDisplayState extends State<WordDisplay> {
  late Future<List<WordCollection>> words;
  int _currentPage = 1;
  final _itemsPerPage =
      20; // Change this to the number of items you want per page

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex =
        min(startIndex + _itemsPerPage, appData.languageWords.length);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Words'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: endIndex - startIndex,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child:
                              Text(appData.languageWords[startIndex + index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 10.0),
              child: ElevatedButton(
                child: Text('Prev'),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null, // Disable the button if _currentPage is 1
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, bottom: 10.0),
              child: ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                  setState(() {
                    words =
                        fetchWords(appData.currentLanguage, _currentPage + 1);
                    words.then((wordList) {
                      setState(() {
                        appData.languageWords.clear();
                        for (var word in wordList) {
                          appData.languageWords.add(word.word);
                        }
                        _currentPage++;
                      });
                    });
                  });
                }, // Disable the button if there are no more items
              ),
            ),
          ],
        ));
  }
}
