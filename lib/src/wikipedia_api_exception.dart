class WikipediaApiException implements Exception {
  final String message;
  final int? statusCode;

  const WikipediaApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'WikipediaApiException ($statusCode): $message';
    }

    return 'WikipediaApiException: $message';
  }
}
