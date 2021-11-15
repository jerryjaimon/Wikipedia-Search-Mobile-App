import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_api/cubit/search_results_cubit.dart';
import 'package:wiki_api/pages/web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:wiki_api/search_results.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String queryString;
  List<Pages> pageList = [];

  final _controller = TextEditingController();

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
                } else if (state is SearchResultsError) {
                  if (state.dismissed == true) {
                    return Container();
                  } else {
                    pageList = [];
                    return searchErrorWidget(message: state.message);
                  }
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
            child: Image.asset('assets/images/wikipedia.png')),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => submitSearchResults(context, value),
            decoration: InputDecoration(
              hintText: "",
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(70))),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => submitSearchResults(context, _controller.text),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget searchInitialWidget() {
    return Container();
  }

  Widget searchLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget searchLoadedWidget() {
    return searchListView();
  }

  Widget searchErrorWidget({required String message}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 30, top: 5, bottom: 5),
                child: Icon(
                  Icons.warning,
                  color: Colors.white70,
                ),
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchListView() {
    return SingleChildScrollView(
      child: ListView.builder(
          itemCount: pageList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 30, top: 5, bottom: 5),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                pageList[index].thumbnail.source),
                            radius: 30.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pageList[index].title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                pageList[index].terms.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
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
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => WebViewClass(
                              title: pageList[index].title,
                              url:
                                  'https://en.m.wikipedia.org/?curid=${pageList[index].pageid}'),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 2,
                  ),
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
