import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api/webtoon"; // 기본 url
  static const int page = 0; // 현재 페이지
  static const int perPage = 50; // 한 페이지에 나올 개수
  static const String service = "naver"; // 서비스
  static const updateDay = "sun"; // 요일

  // 웹툰 데이터 가져오기
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
}
