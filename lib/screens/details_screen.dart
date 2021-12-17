import 'package:flutter/material.dart';
import 'package:simple_manga_app/screens/simple_reader_screen.dart';
import 'package:web_scraper/web_scraper.dart';

class DetailsScreen extends StatefulWidget {
  final String mangaImg, mangaTitle, mangaLink;

  const DetailsScreen(
      {Key? key,
      required this.mangaImg,
      required this.mangaTitle,
      required this.mangaLink})
      : super(key: key);
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String mangaAlt = '',
      mangaAuthor = '',
      mangaStatus = '',
      mangaGenre = '',
      mangaRank = '',
      mangaDesc = '',
      mangaVotes = '';

  List<Map<String, dynamic>> mangaDetailList = [];
  List<Map<String, dynamic>> mangaChapterList = [];

  bool mangaLoaded = false;

  static const String baseUrl = "http://www.mangatown.com";

  //Gets the information from the web with WebScrapper package
  void mangaInfo() async {
    String tempBaseUrl = baseUrl.split(".com")[0] + ".com";
    String tempRoute = widget.mangaLink;

    final webscrapper = WebScraper(tempBaseUrl);

    if (await webscrapper.loadWebPage(tempRoute)) {
      mangaDetailList = webscrapper.getElement(
          'body > section.main.gray-bg.clearfix > article.widscreen.left > div.article_content > div.detail_content > div.detail_info.clearfix > ul > li',
          []);
      mangaChapterList = webscrapper.getElement(
          'body > section.main.gray-bg.clearfix > article.widscreen.left > div.article_content > div.detail_content > div.chapter_content > ul.chapter_list > li > a',
          ['href']);
    }

    mangaAlt = mangaDetailList[2]['title'].toString().trim();
    mangaAuthor = mangaDetailList[5]['title'].toString().trim();
    mangaStatus = mangaDetailList[7]['title'].toString().trim();
    mangaGenre = mangaDetailList[4]['title'].toString().trim();
    mangaRank = mangaDetailList[8]['title'].toString().trim();
    mangaDesc = mangaDetailList[10]['title'].toString().trim();
    mangaVotes = mangaDetailList[0]['title'].toString().trim();

    setState(() {
      mangaLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    mangaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: mangaLoaded
            ? CustomScrollView(
                slivers: [
                  _CustomAppBar(),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    _PosterAndTitle(
                      mangaImg: widget.mangaImg,
                      mangaTitle: widget.mangaTitle,
                    ),
                    _DetailManga(
                      mangaDesc: mangaDesc,
                    ),
                    _InfoManga(
                      mangaAlt: mangaAlt,
                      mangaAuthor: mangaAuthor,
                      mangaGenre: mangaGenre,
                      mangaRank: mangaRank,
                      mangaStatus: mangaStatus,
                      mangaVotes: mangaVotes,
                    ),
                    _MangaChapters(
                      mangaChapters: mangaChapterList,
                    ),
                  ]))
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class _CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xffE2E1E6),
      expandedHeight: 60,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Text(
              'Manga Reader',
              style: TextStyle(color: Colors.black54),
            ),
          )),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String mangaImg, mangaTitle;

  const _PosterAndTitle({
    Key? key,
    required this.mangaImg,
    required this.mangaTitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(mangaImg),
              height: 270,
              width: 200,
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 270),
                child: Text(
                  mangaTitle,
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // RaisedButton(
              //   onPressed: () {},
              //   color: Colors.orange,
              //   child: Text('Start',
              //       style: TextStyle(
              //           color: Colors.white, fontWeight: FontWeight.bold)),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(100)),
              // )
            ],
          )
        ],
      ),
    );
  }
}

//Shows the manga description
class _DetailManga extends StatelessWidget {
  final String mangaDesc;

  const _DetailManga({Key? key, required this.mangaDesc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        mangaDesc,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

//Shows the manga alternative name, author, status, genre, rank and votes
class _InfoManga extends StatelessWidget {
  final String mangaAlt,
      mangaAuthor,
      mangaStatus,
      mangaGenre,
      mangaRank,
      mangaVotes;

  const _InfoManga(
      {Key? key,
      required this.mangaAlt,
      required this.mangaAuthor,
      required this.mangaStatus,
      required this.mangaGenre,
      required this.mangaRank,
      required this.mangaVotes})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 70),
                child: Text(
                  mangaAlt,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [Text(mangaAuthor)],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width - 70),
                  child: Text(mangaStatus))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width - 70),
                child: Text(
                  mangaGenre,
                  maxLines: 2,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [Text(mangaRank)],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.green,
              ),
              Text(mangaVotes)
            ],
          )
        ],
      ),
    );
  }
}

//Shows the list of chapters
class _MangaChapters extends StatelessWidget {
  final List<Map<String, dynamic>> mangaChapters;

  const _MangaChapters({Key? key, required this.mangaChapters})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: mangaChapters.length,
          itemBuilder: (context, int index) {
            return Container(
              height: 50,
              width: double.infinity,
              child: Material(
                child: InkWell(
                  //Navigation to reader screen
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SimpleReaderScreen(
                                mangaChapters: mangaChapters[index]
                                    ['attributes']['href'],
                              ))),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mangaChapters[index]['title'],
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
