import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wiki_api/search_results.dart';
import 'package:wiki_api/utils/fetch_json.dart';

part 'search_results_state.dart';

class SearchResultsCubit extends Cubit<SearchResultsState> {
  final SearchResults jsonDecoded;
  SearchResultsCubit(this.jsonDecoded) : super(SearchResultsInitial());

  Future<void> getData(String url) async {
    try {
      emit(const SearchResultsLoading());
      final jsonDecoded =
          await SearchResults().fetchSearchResults(queryString: url);
      emit(SearchResultsLoaded(jsonDecoded));
    } on NetworkException {
      emit(const SearchResultsError(
          "The application is not able to connect to the internet"));
    }
  }
}
