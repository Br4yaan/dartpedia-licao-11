import 'dart:convert';

import 'package:dartpedia_licao_11/dartpedia_licao_11.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('Article', () {
    test('converte JSON em objeto Dart', () {
      final article = Article.fromJson({
        'pageid': 123,
        'title': 'Dart',
        'snippet': 'Linguagem de programação',
        'wordcount': 500,
        'timestamp': '2026-01-01T10:00:00Z',
      });

      expect(article.pageId, 123);
      expect(article.title, 'Dart');
      expect(article.wordCount, 500);
      expect(article.timestamp, isNotNull);
    });

    test('converte objeto Dart em JSON', () {
      const article = Article(
        pageId: 456,
        title: 'Wikipedia',
        snippet: 'Enciclopédia livre',
        wordCount: 1000,
      );

      final json = article.toJson();

      expect(json['pageid'], 456);
      expect(json['title'], 'Wikipedia');
      expect(json['wordcount'], 1000);
    });
  });

  group('WikipediaService', () {
    test('pesquisa artigos e constrói parâmetros da URI', () async {
      Uri? requestedUri;

      final mockClient = MockClient((request) async {
        requestedUri = request.url;

        return http.Response(
          jsonEncode({
            'query': {
              'search': [
                {
                  'pageid': 123,
                  'title': 'Dart',
                  'snippet': 'Linguagem de programação',
                  'wordcount': 500,
                  'timestamp': '2026-01-01T10:00:00Z',
                },
              ],
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final apiClient = WikipediaApiClient(
        client: mockClient,
        baseUrl: 'https://example.test/w/api.php',
      );

      final service = WikipediaService(apiClient: apiClient);

      try {
        final articles = await service.searchArticles('Dart', limit: 5);

        expect(articles, hasLength(1));
        expect(articles.first.title, 'Dart');
        expect(requestedUri?.queryParameters['action'], 'query');
        expect(requestedUri?.queryParameters['list'], 'search');
        expect(requestedUri?.queryParameters['srsearch'], 'Dart');
        expect(requestedUri?.queryParameters['srlimit'], '5');
      } finally {
        service.close();
      }
    });

    test('rejeita pesquisa vazia', () async {
      final service = WikipediaService();

      expect(() => service.searchArticles('   '), throwsArgumentError);

      service.close();
    });
  });
}
