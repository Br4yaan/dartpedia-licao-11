import '../api_client.dart';
import '../models/article.dart';

class WikipediaService {
  final WikipediaApiClient _apiClient;

  WikipediaService({WikipediaApiClient? apiClient})
    : _apiClient = apiClient ?? WikipediaApiClient();

  Future<List<Article>> searchArticles(
    String searchTerm, {
    int limit = 10,
  }) async {
    if (searchTerm.trim().isEmpty) {
      throw ArgumentError('O termo de pesquisa não pode estar vazio.');
    }

    if (limit < 1 || limit > 50) {
      throw ArgumentError('O limite deve estar entre 1 e 50.');
    }

    final data = await _apiClient.getJson({
      'action': 'query',
      'list': 'search',
      'srsearch': searchTerm.trim(),
      'srprop': 'snippet|wordcount|timestamp',
      'srlimit': limit.toString(),
      'format': 'json',
      'formatversion': '2',
      'utf8': '1',
    });

    final query = data['query'];

    if (query is! Map<String, dynamic>) {
      throw const FormatException(
        'A resposta não contém os dados da pesquisa.',
      );
    }

    final results = query['search'];

    if (results is! List) {
      throw const FormatException(
        'A resposta não contém uma lista de artigos.',
      );
    }

    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Um resultado da pesquisa possui formato inválido.',
        );
      }

      return Article.fromJson(item);
    }).toList();
  }

  void close() {
    _apiClient.close();
  }
}
