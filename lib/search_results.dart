class Queries {
  PagesList pages;
  Queries({required this.pages});
  factory Queries.fromJson(Map<String, dynamic> parsedJson) {
    return Queries(pages: PagesList.fromJson(parsedJson['pages']));
  }
}

class PagesList {
  final List<Pages> page;
  PagesList({
    required this.page,
  });
  factory PagesList.fromJson(List<dynamic> parsedJson) {
    List<Pages> pages = [];
    pages = parsedJson.map((i) => Pages.fromJson(i)).toList();
    return PagesList(page: pages);
  }
}

class Pages {
  int pageid;
  int ns;
  String title;
  int index;
  Thumbnails thumbnail;
  Terms terms;

  Pages(
      {required this.pageid,
      required this.ns,
      required this.title,
      required this.index,
      required this.thumbnail,
      required this.terms});

  factory Pages.fromJson(Map<String, dynamic> parsedJson) {
    return Pages(
      pageid: parsedJson['pageid'],
      ns: parsedJson['ns'],
      title: parsedJson['title'],
      index: parsedJson['index'],
      thumbnail: parsedJson.containsKey('thumbnail') == true
          ? Thumbnails.fromJson(parsedJson['thumbnail'])
          : Thumbnails(
              source:
                  'https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-1.jpg',
              width: 50,
              height: 50),
      terms: parsedJson.containsKey('terms') == true
          ? Terms.fromJson(parsedJson['terms'])
          : Terms(description: 'null'),
    );
  }
}

class Thumbnails {
  String source;
  int width;
  int height;

  Thumbnails({required this.source, required this.width, required this.height});

  factory Thumbnails.fromJson(Map<String, dynamic> parsedJson) {
    return Thumbnails(
        source: parsedJson['source'],
        width: parsedJson['width'],
        height: parsedJson['height']);
  }
}

class Terms {
  String description;

  Terms({required this.description});

  factory Terms.fromJson(Map<String, dynamic> parsedJson) {
    return Terms(description: parsedJson['description'][0].toString());
  }
}

class SearchResultNotFound implements Exception {}
