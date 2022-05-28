import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_learn/bloc/json_api.dart';
import 'package:rxdart_learn/bloc/search_result.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({required JsonApi jsonApi}) {
    final textChanges = BehaviorSubject<String>();

    final results = textChanges.distinct().debounceTime(const Duration(milliseconds: 300)).switchMap<SearchResult?>((value) {
      if (value.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => jsonApi.search(value))
            .delay(const Duration(milliseconds: 200)) // Fake delay
            .map((event) => event.isEmpty ? const SearchResultNoResult() : SearchResultWithResult(event))
            .startWith(const SearchResultLoading())
            .onErrorReturnWith((error, _) => SearchResultHasError(error));
      }
    });

    return SearchBloc._(textChanges.sink, results);
  }

  const SearchBloc._(this.search, this.results);
}
