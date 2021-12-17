import 'package:flutter/material.dart';
import 'package:simple_manga_app/screens/details_screen.dart';
import 'package:simple_manga_app/screens/details_screen.dart';
import 'package:simple_manga_app/screens/details_screen.dart';
import 'package:web_scraper/web_scraper.dart';

class MangaSwiper extends StatefulWidget {
  const MangaSwiper({Key? key}) : super(key: key);

  @override
  State<MangaSwiper> createState() => MangaSwiperState();
}

class MangaSwiperState extends State<MangaSwiper> {
  bool mangaLoaded = false;
  late List<Map<String, dynamic>> mangaTitle = [];
  late List<Map<String, dynamic>> mangaImg = [];
  late List<Map<String, dynamic>> mangaUrl = [];

  //Gets the information with WebScrapper package
  void fetchManga() async {
    const String baseUrl = "http://www.mangatown.com/";
    final webscrapper = WebScraper(baseUrl);

    if (await webscrapper.loadWebPage('/latest/')) {
      mangaTitle = webscrapper.getElement(
          'html > body > section.main.gray-bg.clearfix > article.widscreen.left > div.article_content > div.manga_pic_content > ul.manga_pic_list > li > a > img',
          ['alt']);
      mangaImg = webscrapper.getElement(
          'html > body > section.main.gray-bg.clearfix > article.widscreen.left > div.article_content > div.manga_pic_content > ul.manga_pic_list > li > a > img',
          ['src']);
      mangaUrl = webscrapper.getElement(
          'html > body > section.main.gray-bg.clearfix > article.widscreen.left > div.article_content > div.manga_pic_content > ul.manga_pic_list > li > a',
          ['href']);

      setState(() {
        mangaLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchManga();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 280,
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Top',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mangaTitle.length,
                  itemBuilder: (_, int index) => MangaPoster(
                        mangaImgPoster: mangaImg[index]['attributes']['src'],
                        mangaTitlePoster: mangaTitle[index]['attributes']
                            ['alt'],
                        mangaUrlPoster: mangaUrl[index]['attributes']['href'],
                      )),
            )
          ],
        ));
  }
}

//Image, title and Url for each manga in the slider
class MangaPoster extends StatelessWidget {
  final String mangaTitlePoster, mangaImgPoster, mangaUrlPoster;
  const MangaPoster(
      {required this.mangaImgPoster,
      required this.mangaTitlePoster,
      required this.mangaUrlPoster});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              //Navigation to detail screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          mangaImg: mangaImgPoster,
                          mangaTitle: mangaTitlePoster,
                          mangaLink: mangaUrlPoster)));
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(mangaImgPoster),
              width: 130,
              height: 190,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            mangaTitlePoster,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
