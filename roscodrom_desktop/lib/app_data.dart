import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)
  List<String> languageWords = [];
  String currentLanguage = "";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}
