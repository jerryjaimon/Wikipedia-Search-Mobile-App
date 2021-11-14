import 'dart:convert';

import '../search_results.dart';
import 'package:http/http.dart' as http;

class SearchResults {
  Future<PagesList> fetchSearchResults({required String queryString}) async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$queryString&gpslimit=10'));
    if (response.statusCode == 200) {
      return Queries.fromJson(jsonDecode(response.body)['query']).pages;
    } else {
      throw Exception("Failed to get response from API");
    }
  }
}
