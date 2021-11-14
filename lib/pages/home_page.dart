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
              listener: (context, state) {},
              builder: (context, state) {
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

  ListView searchListView() {
    return ListView.builder(
        itemCount: pageList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.network(
                      pageList[index].thumbnail.source,
                      width: pageList[index].thumbnail.width.toDouble(),
                      height: pageList[index].thumbnail.height.toDouble(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pageList[index].title),
                        Text(pageList[index].terms.description),
                      ],
                    ),
                  ),
                ],
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
            ),
          );
        });
  }

  void submitSearchResults(BuildContext context, String searchQuery) {
    final searchCubit = context.read<SearchResultsCubit>();
    searchCubit.getData(searchQuery);
  }
}
