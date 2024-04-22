class WordCollection {
  final String word;
  final String language;
  final int times_used;

  const WordCollection({
    required this.word,
    required this.language,
    required this.times_used,
  });

  factory WordCollection.fromJson(Map<String, dynamic> json) {
    return WordCollection(
      word: json['word'],
      language: json['language'],
      times_used: json['times_used'],
    );
  }
}
