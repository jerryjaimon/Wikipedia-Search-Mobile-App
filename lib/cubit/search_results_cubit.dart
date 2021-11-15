import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:wiki_api/search_results.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    } on SocketException {
      emit(const SearchResultsError(
          "Oops! The application is not able to connect to the internet. Please check your connection",
          false));
    } on SearchResultNotFound {
      emit(const SearchResultsError("Oops! No results available", false));
    } catch (e) {
      print(e);
      emit(const SearchResultsError(
          "Oops! We are not able to process your request now. Please try again later.",
          false));
    }
  }
}
