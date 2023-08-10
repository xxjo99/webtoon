class WebtoonModel2 {
  final String id;
  final String title;
  final String thumb;

  WebtoonModel2.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        thumb = json['thumb'];
}
