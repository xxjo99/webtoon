# 웹툰 앱
개발기간 : 23.08.01 ~ 23.08.13
참고 : https://nomadcoders.co/flutter-for-beginners/lobby

## 메인화면
![image](https://github.com/xxjo99/webtoon/assets/96373083/0457687e-8a35-4226-8f45-5e27ee95ce09)
- api를 통해 웹툰 목록 생성
- 두 가지 방법을 통해 생성가능
1. 직접 개발한 스프링부트의 RESTApi를 통해 생성
2. 참고사이트에서 제공한 Api를 통해 생성

```
  static const String baseUrl = "http://10.0.2.2:8080/api/webtoon"; // 기본 url
  static const String baseUrl2 =
      "https://webtoon-crawler.nomadcoders.workers.dev";

  static Future<List<WebtoonModel>> getWebtoons() async {
    List<WebtoonModel> webtoonInstances = []; // 웹툰 결과값 리스트

    final url = Uri.parse(
        "$baseUrl/webtoons?page=$page&perPage=$perPage&service=$service&updateDay=$updateDay"); // Url to Uri
    final response = await http.get(url); // 결과값

    // 정상적인 응답 (200)
    if (response.statusCode == 200) {
      final List<dynamic> webtoons =
          jsonDecode(utf8.decode(response.bodyBytes)); // json 데이터 파싱

      // 리스트에 결과 값 저장
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }

      return webtoonInstances;
    }

    throw Error(); // 그 외의 응답일 경우 에러 처리
  }

  // 웹툰 데이터 가져오기2
  static Future<List<WebtoonModel2>> getWebtoons2() async {
    List<WebtoonModel2> webtoonInstances = []; // 웹툰 결과값 리스트

    final url = Uri.parse("$baseUrl2/$today"); // Url to Uri
    final response = await http.get(url); // 결과값

    // 정상적인 응답 (200)
    if (response.statusCode == 200) {
      final List<dynamic> webtoons =
          jsonDecode(utf8.decode(response.bodyBytes)); // json 데이터 파싱

      // 리스트에 결과 값 저장
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel2.fromJson(webtoon));
      }

      return webtoonInstances;
    }

    throw Error(); // 그 외의 응답일 경우 에러 처리
  }
```
- 웹툰 클릭시 웹툰 상세 페이지로 이동


## 웹툰 상세페이지
![image](https://github.com/xxjo99/webtoon/assets/96373083/2386c517-a1eb-4281-bf67-fa28964d41fc)
- api를 통해 웹툰의 정보, 에피소드 생성, 참고사이트에서 제공한 api 사용
```
  static Future<WebtoonDetailModel> getWebtoonById(String id) async {
    final url = Uri.parse("$baseUrl2/$id"); // Url to Uri
    final response = await http.get(url); // 결과값

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(utf8.decode(response.bodyBytes));
      return WebtoonDetailModel.fromJson(webtoon);
    }

    throw Error();
  }

  // 웹툰 에피소드
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodeById(String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];

    final url = Uri.parse("$baseUrl2/$id/episodes"); // Url to Uri
    final response = await http.get(url); // 결과값

    if (response.statusCode == 200) {
      final episodes = jsonDecode(utf8.decode(response.bodyBytes));

      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }

      return episodesInstances;
    }

    throw Error();
  }
```

- 에피소드 클릭시 해당 웹툰 페이지로 이동
```
    onTap: () async {
      await launchUrlString(
          "https://comic.naver.com/webtoon/detail?titleId=${widget.id}&no=${episode.id}");
    },
```