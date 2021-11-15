import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki_api/cubit/search_results_cubit.dart';
import 'package:wiki_api/pages/home_page.dart';
import 'package:wiki_api/utils/fetch_json.dart';

void main() {
  runApp(const WikiApi());
}

class WikiApi extends StatelessWidget {
  const WikiApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Search Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.grey[200],
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (BuildContext context) => SearchResultsCubit(SearchResults()),
          child: const HomePage()),
    );
  }
}
