import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_api/search_results.dart';

void main() {
  runApp(WikiApi());
}

class WikiApi extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<SearchResults> fetchSearchResults({required String queryString}) async {
      final response = await http.get(Uri.parse('https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$queryString&gpslimit=10'));
      if(response.statusCode ==200){
        print(jsonDecode(response.body)['query']['pages']);
        return SearchResults.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception("Failed to get response from API");
      }
  }

  @override
  Widget build(BuildContext context) {
    String queryString = 'null';
    var response;
    return Scaffold(
        body:SafeArea(
          child: Container(
            color: Colors.white60,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    decoration: const InputDecoration(hintText: "Enter search text here!"),
                      onChanged: (text) {
                        queryString = text;
                      }
                  ),
                ),
                TextButton(
                  onPressed: () {
                      response = fetchSearchResults(queryString: queryString);
                      print(response);
                  },
                  child: const Text('Search'),
                )
              ],
            ),
          ),
        )
    );
  }
}

