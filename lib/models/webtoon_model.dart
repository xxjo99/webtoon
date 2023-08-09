class WebtoonModel {
  final String webtoonId;
  final String title;
  final String author;
  final String url;
  final String img;
  final String service;
  final List<String> updateDays;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : webtoonId = json['webtoonId'],
        title = json['title'],
        author = json['author'],
        url = json['url'],
        img = json['img'],
        service = json['service'],
        updateDays = List<String>.from(json['updateDays']);
}
