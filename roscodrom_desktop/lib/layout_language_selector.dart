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
    AppData appData = Provider.of<AppData>(context);
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
                appData.isLoading
                    ? const Column(
                        children: [
                          CircularProgressIndicator(),
                          Text('Loading words...',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 3, 0, 0)))
                        ],
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  right: 32, left: 32, top: 24, bottom: 24)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/catalan_flag.png'),
                            const SizedBox(height: 24),
                            const Text('Catalan',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 3, 0, 0))),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            appData.isLoading = true;
                          });
                          fetchWords('catala', 1).then((wordList) {
                            for (var word in wordList) {
                              appData.languageWords.add(word.word);
                            }
                            if (appData.languageWords.isNotEmpty) {
                              setState(() {
                                appData.currentLanguage = 'catala';
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WordDisplay()));
                            }
                          });
                        },
                      ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     padding: MaterialStateProperty.all(const EdgeInsets.only(
                //         right: 32, left: 32, top: 24, bottom: 24)),
                //     backgroundColor:
                //         MaterialStateProperty.all(Colors.transparent),
                //     elevation: MaterialStateProperty.all(0),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset('assets/catalan_flag.png'),
                //       const SizedBox(height: 24),
                //       const Text('Spanish',
                //           style:
                //               TextStyle(color: Color.fromARGB(255, 3, 0, 0))),
                //     ],
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       appData.isLoading = true;
                //     });
                //     fetchWords('castellano', 1).then((wordList) {
                //       for (var word in wordList) {
                //         appData.languageWords.add(word.word);
                //       }
                //       if (appData.languageWords.isNotEmpty) {
                //         setState(() {
                //           appData.currentLanguage = 'castellano';
                //         });
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const WordDisplay()));
                //       }
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
