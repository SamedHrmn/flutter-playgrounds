import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_learn/model/post_model.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultNoResult implements SearchResult {
  const SearchResultNoResult();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object? error;
  const SearchResultHasError(this.error);
}

@immutable
class SearchResultWithResult implements SearchResult {
  final List<SearchableBaseModel> result;
  const SearchResultWithResult(this.result);
}
