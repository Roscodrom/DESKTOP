import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:roscodrom_desktop/words.dart';

Future<List<WordCollection>> fetchWords(String language, int page) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:3000/api/words/$language/$page'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => WordCollection.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load words');
  }
}

Future<Map<String, dynamic>> fetchWordsByLetter(
    String language, String letter) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:3000/api/letter/$language/$letter'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load words');
  }
}
