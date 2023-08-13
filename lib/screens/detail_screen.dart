import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String id, title, thumb;

  const DetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedWebtoons = prefs.getStringList("likedWebtoons");

    if (likedWebtoons != null) {
      if (likedWebtoons.contains(widget.id) == true) {
        isLiked = true;
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList("likedWebtoons", []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getWebtoonById(widget.id);
    episodes = ApiService.getLatestEpisodeById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedWebtoons = prefs.getStringList("likedWebtoons");

    if (likedWebtoons != null) {
      if (isLiked) {
        likedWebtoons.remove(widget.id);
      } else {
        likedWebtoons.add(widget.id);
      }

      await prefs.setStringList("likedWebtoons", likedWebtoons);

      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline_outlined),
            color: Colors.pink,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: widget.id,
                  child: SizedBox(
                    height: 220,
                    child: Image.network(
                      widget.thumb,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                    future: webtoon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Text(
                              snapshot.data!.about,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${snapshot.data!.genre} / ${snapshot.data!.age}",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        );
                      }
                      return const Text("...");
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                      future: episodes,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              makeList(snapshot),
                            ],
                          );
                        }
                        return Container();
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonEpisodeModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var episode = snapshot.data![index];
        return GestureDetector(
          onTap: () async {
            await launchUrlString(
                "https://comic.naver.com/webtoon/detail?titleId=${widget.id}&no=${episode.id}");
          },
          child: Row(
            children: [
              Container(
                width: 80,
                height: 55,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.network(
                  episode.thumb,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rate_sharp,
                        color: Color(0xffA7A7A7),
                        size: 14,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        episode.rating,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        episode.date,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
