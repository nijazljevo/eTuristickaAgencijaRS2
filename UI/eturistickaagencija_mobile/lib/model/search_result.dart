class SearchResult<T> {
  int count = 0;
  List<T> result = [];

  bool get isSuccess => count > 0;

  T? get data => result.isNotEmpty ? result[0] : null;
}