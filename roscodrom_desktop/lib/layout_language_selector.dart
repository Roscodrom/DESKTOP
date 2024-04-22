import 'package:flutter/material.dart';
import 'package:roscodrom_desktop/words.dart';
import 'requests.dart';
import 'app_data.dart';
import 'package:provider/provider.dart';
import 'layout_word_display.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector> {
  late Future<List<WordCollection>> words;

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select language'),
        ),
        body: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Catala'),
                  onPressed: () {
                    setState(() {
                      words = fetchWords('catala', 1);
                      words.then((wordList) {
                        for (var word in wordList) {
                          appData.languageWords.add(word.word);
                        }
                        if (appData.languageWords.isNotEmpty) {
                          appData.currentLanguage = 'catala';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WordDisplay()));
                        }
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
