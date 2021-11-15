import 'dart:convert';
import 'dart:io';

import 'package:wiki_api/search_results.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SearchResults {
  Future<PagesList> fetchSearchResults({required String queryString}) async {
    //String fileName = "CacheData.json";
    //var cacheDir = await getTemporaryDirectory();

    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$queryString&gpslimit=10'));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body).containsKey('query')) {
        /*//Saving to cache
        var tempDir = await getTemporaryDirectory();
        if (await File(cacheDir.path + "/" + fileName).exists()) {
          File file = File(cacheDir.path + "/" + fileName);
          var jsonQuery =
              jsonDecode(response.body)['query']['pages'].toString();
          file.writeAsString(jsonQuery.substring(1, jsonQuery.length) + ",",
              flush: true, mode: FileMode.append);
        } else {
          File file = File(tempDir.path + "/" + fileName);
          var jsonQuery =
              jsonDecode(response.body)['query']['pages'].toString();
          file.writeAsString(jsonQuery.substring(0, jsonQuery.length - 1) + ",",
              flush: true, mode: FileMode.write);
        }*/
        return Queries.fromJson(jsonDecode(response.body)['query']).pages;
      } else {
        throw SearchResultNotFound();
      }
    } else {
      throw Exception("Failed to get response from API");
    }
  }
}
