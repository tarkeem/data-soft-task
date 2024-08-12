class NewsException implements Exception {
  String message;
  NewsException([this.message = 'Error']) {
    message = 'Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
