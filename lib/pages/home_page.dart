import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_api/cubit/search_results_cubit.dart';
import 'package:wiki_api/pages/web_view.dart';

import '../search_results.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String queryString;
  List<Pages> pageList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          logoAndSearchWidget(),
          BlocConsumer<SearchResultsCubit, SearchResultsState>(
              listener: (context, state) {
            if (state is SearchResultsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          }, builder: (context, state) {
            if (state is SearchResultsInitial) {
              return searchInitialWidget();
            } else if (state is SearchResultsLoading) {
              return searchLoadingWidget();
            } else if (state is SearchResultsLoaded) {
              pageList = state.pages.page;
              return searchLoadedWidget();
            } else {
              return searchInitialWidget();
            }
          }),
          searchListView(),
        ],
      ),
    ));
  }

  Widget logoAndSearchWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 20, right: 100, left: 100),
            child: Image.asset('assests/images/wikipedia.png')),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onSubmitted: (value) => submitSearchResults(context, value),
            decoration: const InputDecoration(
              hintText: "",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchInitialWidget() {
    return Container(child: Text("Intial State"));
  }

  Widget searchLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget searchLoadedWidget() {
    return searchListView();
  }

  Widget searchErrorWidget() {
    return Container();
  }

  Widget searchListView() {
    return SingleChildScrollView(
      child: ListView.builder(
          itemCount: pageList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ElevatedButton(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(pageList[index].thumbnail.source),
                          radius: 30.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pageList[index].title,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              pageList[index].terms.description,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewClass(
                            title: pageList[index].title,
                            url:
                                'https://en.m.wikipedia.org/?curid=${pageList[index].pageid}')),
                  );
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )),
                ),
              ),
            );
          }),
    );
  }

  void submitSearchResults(BuildContext context, String searchQuery) {
    final searchCubit = context.read<SearchResultsCubit>();
    searchCubit.getData(searchQuery);
  }
}
