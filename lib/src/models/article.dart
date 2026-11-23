class Article {
  final int pageId;
  final String title;
  final String snippet;
  final int wordCount;
  final DateTime? timestamp;

  const Article({
    required this.pageId,
    required this.title,
    required this.snippet,
    required this.wordCount,
    this.timestamp,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      pageId: json['pageid'] as int,
      title: json['title'] as String,
      snippet: (json['snippet'] as String?) ?? '',
      wordCount: (json['wordcount'] as int?) ?? 0,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.tryParse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageid': pageId,
      'title': title,
      'snippet': snippet,
      'wordcount': wordCount,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Article(pageId: $pageId, title: $title)';
  }
}
