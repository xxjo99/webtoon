import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model2.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel2>> webtoons = ApiService.getWebtoons2();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: webtoons,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(height: 50),
                  makeGrid(snapshot),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel2>> snapshot) {

    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(webtoonId: webtoon.id, title: webtoon.title, img: webtoon.thumb);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );

  }

  GridView makeGrid(AsyncSnapshot<List<WebtoonModel2>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(webtoonId: webtoon.id, title: webtoon.title, img: webtoon.thumb);
      },
    );
  }

}
