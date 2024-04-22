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
  late Future<Map<String, dynamic>> jsonResponse;
  final TextEditingController _pageController = TextEditingController();
  int _currentPage = 1;
  final _itemsPerPage =
      13; // Change this to the number of items you want per page

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${appData.currentLanguage[0].toUpperCase()}${appData.currentLanguage.substring(1)} dictionary'),
        ),
        body: Stack(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Container(
                width: 800,
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0,
                    runSpacing: 2.0,
                    children: 'ABCDEFGHIJKLMNOPQRSTUVXYZ'
                        .split('')
                        .map((String letter) {
                      return TextButton(
                        child: Text(letter, style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          jsonResponse = fetchWordsByLetter(
                              appData.currentLanguage, letter);
                          words = jsonResponse.then((jsonResponse) {
                            List<dynamic> wordList = jsonResponse['words'];
                            _currentPage = jsonResponse['page'];
                            return wordList
                                .map((item) => WordCollection.fromJson(item))
                                .toList();
                          });
                          words.then((wordList) {
                            setState(() {
                              List<String> newWords = [];
                              for (var word in wordList) {
                                newWords.add(word.word);
                              }
                              appData.languageWords = newWords;
                            });
                          });
                        },
                      );
                    }).toList()),
              )),
              Expanded(
                child: ListView.builder(
                  itemCount: _itemsPerPage - 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Text(appData.languageWords[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      Text('Go to page:'),
                      SizedBox(width: 10), // adjust this value as needed
                      Container(
                        width: 50, // adjust this value as needed
                        child: TextField(
                          controller: _pageController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            setState(() {
                              _currentPage = int.parse(value);
                              words = fetchWords(
                                  appData.currentLanguage, _currentPage);
                              words.then((wordList) {
                                setState(() {
                                  List<String> newWords = [];
                                  for (var word in wordList) {
                                    newWords.add(word.word);
                                  }
                                  appData.languageWords = newWords;
                                });
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          )
        ]),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                child: Text('Prev'),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          words = fetchWords(
                              appData.currentLanguage, _currentPage - 1);
                          words.then((wordList) {
                            setState(() {
                              List<String> newWords = [];
                              for (var word in wordList) {
                                newWords.add(word.word);
                              }
                              appData.languageWords = newWords;
                              if (appData.languageWords.isNotEmpty) {
                                _currentPage--;
                              }
                            });
                          });
                        });
                      }
                    : null, // Disable the button if _currentPage is 1
              ),
            ),
            Text('Page $_currentPage'),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                  words = fetchWords(appData.currentLanguage, _currentPage + 1);
                  words.then((wordList) {
                    setState(() {
                      List<String> newWords = [];
                      for (var word in wordList) {
                        newWords.add(word.word);
                      }
                      appData.languageWords = newWords;
                      if (appData.languageWords.isNotEmpty) {
                        _currentPage++;
                      }
                    });
                  });
                }, // Disable the button if there are no more items
              ),
            ),
          ],
        ));
  }
}
