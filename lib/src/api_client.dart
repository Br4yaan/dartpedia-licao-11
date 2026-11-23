import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'wikipedia_api_exception.dart';

class WikipediaApiClient {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  WikipediaApiClient({
    http.Client? client,
    this.baseUrl = 'https://pt.wikipedia.org/w/api.php',
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getJson(Map<String, String> parameters) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: parameters);

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'DartpediaLicao11/1.0 (Dart application)',
            },
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw WikipediaApiException(
          'A Wikipedia retornou um erro HTTP.',
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (decoded is! Map<String, dynamic>) {
        throw const WikipediaApiException(
          'A resposta da API não possui o formato JSON esperado.',
        );
      }

      if (decoded.containsKey('error')) {
        throw WikipediaApiException(
          'Erro retornado pela Wikipedia: ${decoded['error']}',
        );
      }

      return decoded;
    } on TimeoutException {
      throw const WikipediaApiException('A requisição excedeu o tempo limite.');
    } on http.ClientException catch (error) {
      throw WikipediaApiException('Erro de comunicação HTTP: ${error.message}');
    } on FormatException {
      throw const WikipediaApiException(
        'Não foi possível interpretar a resposta JSON.',
      );
    }
  }

  void close() {
    _client.close();
  }
}
