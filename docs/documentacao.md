# Documentação Técnica - Dartpedia

## 1. Introdução

O Dartpedia é uma biblioteca desenvolvida em Dart que permite consultar informações da Wikipedia por meio de requisições HTTP.

O projeto foi desenvolvido para a Lição 11 - Obter dados da internet.

## 2. Arquitetura

O projeto está organizado em módulos:

- `api_client.dart`: realiza requisições HTTP e interpreta respostas JSON.
- `article.dart`: representa os artigos retornados pela API.
- `wikipedia_service.dart`: implementa a pesquisa de artigos.
- `wikipedia_api_exception.dart`: define as exceções específicas da API.
- `dartpedia_licao_11.dart`: exporta os componentes públicos da biblioteca.

## 3. Requisição HTTP

O cliente utiliza o pacote `http` para realizar requisições GET.

A URI é construída com parâmetros de consulta, como:

- action=query
- list=search
- srsearch=termo pesquisado
- srlimit=quantidade de resultados
- format=json
- formatversion=2

## 4. Conversão JSON

A resposta da Wikipedia é interpretada com `jsonDecode`.

A classe `Article` recebe os campos:

- pageId: identificador do artigo.
- title: título do artigo.
- snippet: trecho de descrição.
- wordCount: quantidade de palavras.
- timestamp: data e horário disponibilizados pela API.

## 5. Tratamento de erros

O cliente trata:

- Erros de comunicação HTTP.
- Respostas HTTP diferentes de 200.
- Tempo limite excedido.
- Respostas JSON inválidas.
- Erros retornados pela API.

## 6. Reutilização

Os componentes públicos são exportados pelo arquivo principal da biblioteca.

Outros projetos podem importar:

`package:dartpedia_licao_11/dartpedia_licao_11.dart`

## 7. Execução

Instalar dependências:

`dart pub get`

Executar o exemplo:

`dart run example/dartpedia_licao_11_example.dart`

Executar testes:

`dart test`

Analisar código:

`dart analyze`

## 8. Controle de versões

O GitHub é utilizado para armazenar o projeto e acompanhar sua evolução.

As alterações são registradas por meio de commits, permitindo identificar as funcionalidades implementadas em cada etapa.

## 9. Conclusão

O projeto demonstra a utilização de requisições HTTP, construção de URIs, processamento de JSON, organização de uma biblioteca Dart e exportação de componentes reutilizáveis.
