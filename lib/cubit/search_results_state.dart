part of 'search_results_cubit.dart';

@immutable
abstract class SearchResultsState {
  const SearchResultsState();
}

class SearchResultsInitial extends SearchResultsState {
  const SearchResultsInitial();
}

class SearchResultsLoading extends SearchResultsState {
  const SearchResultsLoading();
}

class SearchResultsLoaded extends SearchResultsState {
  final PagesList pages;
  const SearchResultsLoaded(this.pages);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SearchResultsLoaded && o.pages == pages;
  }

  @override
  int get hashCode => pages.hashCode;
}

class SearchResultsError extends SearchResultsState {
  final String message;
  const SearchResultsError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SearchResultsError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
