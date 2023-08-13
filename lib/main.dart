import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webtoon/screens/home_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36';
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: "SCDream"),
          titleSmall: TextStyle(
              fontSize: 10,
              color: Color(0xff999999),
              fontFamily: "SCDream",
              fontWeight: FontWeight.w400),
          displayMedium: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: "SCDream",
              fontWeight: FontWeight.w400),
          displaySmall: TextStyle(
              color: Color(0xffA7A7A7),
              fontSize: 10,
              fontFamily: "SCDream",
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
