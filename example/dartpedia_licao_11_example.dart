import 'dart:io';

import 'package:dartpedia_licao_11/dartpedia_licao_11.dart';

Future<void> main() async {
  final wikipedia = WikipediaService();

  print('====================================');
  print('       DARTPEDIA - WIKIPEDIA');
  print('====================================');

  stdout.write('\nDigite o que deseja pesquisar: ');
  final searchTerm = stdin.readLineSync();

  if (searchTerm == null || searchTerm.trim().isEmpty) {
    print('Você precisa informar um termo de pesquisa.');
    wikipedia.close();
    return;
  }

  try {
    print('\nPesquisando na Wikipedia...\n');

    final articles = await wikipedia.searchArticles(searchTerm, limit: 10);

    if (articles.isEmpty) {
      print('Nenhum artigo encontrado.');
      return;
    }

    for (var i = 0; i < articles.length; i++) {
      final article = articles[i];

      final cleanSnippet = article.snippet
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&#39;', "'");

      print('------------------------------------');
      print('${i + 1}. ${article.title}');
      print('ID: ${article.pageId}');
      print('Palavras: ${article.wordCount}');
      print('Resumo: $cleanSnippet');
      print('Link: https://pt.wikipedia.org/?curid=${article.pageId}');
    }

    print('\nPesquisa concluída com sucesso!');
  } on WikipediaApiException catch (error) {
    print('\nErro na API: $error');
  } on ArgumentError catch (error) {
    print('\nErro nos parâmetros: $error');
  } catch (error) {
    print('\nErro inesperado: $error');
  } finally {
    wikipedia.close();
  }
}
