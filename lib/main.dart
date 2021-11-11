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
        //platform: TargetPlatform.iOS,
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
  Future<PagesList> _fetchSearchResults({required String queryString}) async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$queryString&gpslimit=10'));
    if (response.statusCode == 200) {
      return Queries.fromJson(jsonDecode(response.body)['query']).pages;
    } else {
      throw Exception("Failed to get response from API");
    }
  }

  void fetchSearchResults({required String queryString}) async {
    final searchResult = await _fetchSearchResults(queryString: queryString);
  }

  @override
  Widget build(BuildContext context) {
    String queryString = 'null';
    var response;
    return Scaffold(
        body: SafeArea(
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
                  decoration: const InputDecoration(
                      hintText: "Enter search text here!"),
                  onChanged: (text) {
                    queryString = text;
                  }),
            ),
            TextButton(
              onPressed: () {
                fetchSearchResults(queryString: queryString);
              },
              child: const Text('Search'),
            )
          ],
        ),
      ),
    ));
  }
}
