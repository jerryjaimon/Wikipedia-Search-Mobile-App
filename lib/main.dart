import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wiki_api/pages/web_view.dart';
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
  String queryString = 'null';
  List<Pages> pageList = [];

  Future<PagesList> fetchSearchResults({required String queryString}) async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$queryString&gpslimit=10'));
    if (response.statusCode == 200) {
      return Queries.fromJson(jsonDecode(response.body)['query']).pages;
    } else {
      throw Exception("Failed to get response from API");
    }
  }

  @override
  Widget build(BuildContext context) {
    PagesList response;
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Colors.white60,
        child: ListView(
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
              onPressed: () async {
                response = await fetchSearchResults(queryString: queryString);
                pageList = response.page;
                setState(() {
                  print(pageList.length.toString());
                });
              },
              child: const Text('Search'),
            ),
            ListView.builder(
                itemCount: pageList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Container(
                          child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Image.network(
                              pageList[index].thumbnail.source,
                              width: pageList[index].thumbnail.width.toDouble(),
                              height:
                                  pageList[index].thumbnail.height.toDouble(),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pageList[index].title),
                              Text(pageList[index].terms.description)
                            ],
                          ),
                        ],
                      )),
                      onPressed: () {
                        print('pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewClass(
                                  url:
                                      'https://en.m.wikipedia.org/?curid=${pageList[index].pageid}')),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    ));
  }
}
