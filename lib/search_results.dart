class SearchResults {
  final String imageURL;
  final int pageID;

  SearchResults({
    required this.imageURL,
    required this.pageID,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      imageURL: json['query']['pages']['thumbnail'],
      pageID: json['query']['pages']['pageid'],
    );
  }
}