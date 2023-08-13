import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model2.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel2>> webtoons = ApiService.getWebtoons2();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: webtoons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    makeWebtoonList(snapshot, itemHeight, itemWidth),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  GridView makeWebtoonList(AsyncSnapshot<List<WebtoonModel2>> snapshot, double itemHeight, double itemWidth) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
            webtoonId: webtoon.id, title: webtoon.title, img: webtoon.thumb);
      },
    );
  }
}
