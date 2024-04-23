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
  final _itemsPerPage = 13;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<AppData>(context, listen: false).isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${appData.currentLanguage[0].toUpperCase()}${appData.currentLanguage.substring(1)} dictionary'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AppData>(context, listen: false).isLoading = false;
            },
          ),
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
                        child:
                            Text(letter, style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          setState(() {
                            appData.isLoading = true;
                          });
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
                              appData.isLoading = false;
                            });
                          });
                        },
                      );
                    }).toList()),
              )),
              SizedBox(height: 48),
              Expanded(
                child: appData.isLoading
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('Loading words...',
                              style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _itemsPerPage - 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                              appData.isLoading = true;
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
                                  if (appData.languageWords.isNotEmpty) {
                                    appData.isLoading = false;
                                  }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 64, bottom: 10.0),
              child: ElevatedButton(
                child: const Text('Prev'),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          appData.isLoading = true;
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
                                appData.isLoading = false;
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
              padding: const EdgeInsets.only(left: 64, bottom: 10.0),
              child: ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                  setState(() {
                    appData.isLoading = true;
                  });
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
                        appData.isLoading = false;
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
